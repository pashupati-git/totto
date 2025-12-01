import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:totto/config/app_config.dart';
import 'package:totto/data/models/message_model.dart';
import 'package:totto/data/models/order_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/chat/providers/message_provider.dart';
import 'package:totto/features/chat/websocket/domain/chat_connection_params.dart';
import 'package:totto/features/chat/websocket/providers/websocket_provider.dart';
import 'package:totto/features/order/providers/order_providers.dart';

part 'chat_controller.g.dart';

@riverpod
class ChatController extends _$ChatController
{
    @override
    Future<List<Message>> build(ChatConnectionParams params) async
    {
        _setupWebSocketListener(params);
        final messageRepository = ref.read(messageRepositoryProvider);
        if (params.type == ChatType.group) 
        {
            final messages = await messageRepository.fetchMessagesForGroup(params.id);
            return messages;
        }
        else 
        {
            print("NOTE: Personal chat history not yet implemented in MessageRepository.");
            return Future.value([]);
        }
    }

    void _setupWebSocketListener(ChatConnectionParams params) 
    {
        ref.listen(webSocketMessagesProvider(params), (previous, next)
            {
                if (next.hasError) 
                {
                    print("WebSocket listener reported an error: ${next.error}");
                    return;
                }
                if (next.hasValue) 
                {
                    final webSocketMessageData = next.value;
                    if (webSocketMessageData == null) return;

                    var newMessage = Message.fromJson(webSocketMessageData);

                    if (newMessage.image != null && newMessage.image!.startsWith(ApiConfig.webSocketLegacyHost)) 
                    {
                        newMessage = newMessage.copyWith(
                            image: newMessage.image!.replaceFirst(ApiConfig.webSocketLegacyHost, ApiConfig.baseUrl),
                        );
                    }

                    if (newMessage.order?.imageUrl != null && newMessage.order!.imageUrl!.startsWith(ApiConfig.webSocketLegacyHost)) 
                    {
                        final updatedOrder = newMessage.order!.copyWith(
                            imageUrl: newMessage.order!.imageUrl!.replaceFirst(ApiConfig.webSocketLegacyHost, ApiConfig.baseUrl),
                        );
                        newMessage = newMessage.copyWith(order: updatedOrder);
                    }

                    final previousMessages = state.valueOrNull ?? [];
                    final currentUser = ref.read(authStateChangesProvider).value;

                    if (newMessage.senderId == currentUser?.id.toString()) 
                    {
                        final optimisticMessageIndex = previousMessages.indexWhere((m) =>
                            m.id > 1000000000 &&
                                (m.content == newMessage.content || m.image != null && !m.image!.startsWith('http')));

                        if (optimisticMessageIndex != -1) 
                        {
                            final updatedMessages = List<Message>.from(previousMessages);
                            final optimisticMessage = updatedMessages[optimisticMessageIndex];

                            updatedMessages[optimisticMessageIndex] = optimisticMessage.copyWith(
                                id: newMessage.id,
                                image: newMessage.image,
                                isUploading: false,
                            );
                            state = AsyncData(updatedMessages);
                        }
                        else 
                        {
                            if (!previousMessages.any((m) => m.id == newMessage.id)) 
                            {
                                state = AsyncData([newMessage, ...previousMessages]);
                            }
                        }
                    }
                    else 
                    {
                        if (!previousMessages.any((m) => m.id == newMessage.id)) 
                        {
                            state = AsyncData([newMessage, ...previousMessages]);
                        }
                    }
                }
            }
        );
    }

    Future<void> sendMessage(String content, ChatConnectionParams params,
        {int? replyToId, required String urgency}) async
    {
        final currentUser = ref.read(authStateChangesProvider).value;
        if (currentUser == null) 
        {
            print("Error: Cannot send message, user is not authenticated.");
            return;
        }

        final currentMessages = state.valueOrNull ?? [];
        Message? replyToMessage;
        if (replyToId != null) 
        {
            try
            {
                replyToMessage =
                currentMessages.firstWhere((m) => m.id == replyToId);
            }
            on StateError
            {
                print("Could not find reply message in state.");
            }
        }

        final optimisticMessage = Message(
            id: DateTime.now().millisecondsSinceEpoch,
            content: content,
            senderName:
            currentUser.name.isNotEmpty ? currentUser.name : currentUser.username,
            senderId: currentUser.id.toString(),
            group: params.id,
            timestamp: DateTime.now(),
            replyTo: replyToMessage,
            urgency: urgency,
        );

        state = AsyncData([optimisticMessage, ...currentMessages]);

        final payload = 
        {
            'content': content,
            'group': params.id,
            if (replyToId != null) 'reply_to': replyToId,
            'urgency': urgency,
        };

        try
        {
            final channel =
                await ref.read(webSocketChannelProvider(params).future);
            channel.sink.add(json.encode(payload));
        }
        catch (e)
        {
            print("Failed to send message via WebSocket: $e");
            state = AsyncData(
                currentMessages.where((m) => m.id != optimisticMessage.id).toList());
        }
    }

    Future<void> sendImageMessage(File imageFile, ChatConnectionParams params,
        {String? content, required String urgency}) async
    {
        final currentUser = ref.read(authStateChangesProvider).value;
        if (currentUser == null) return;

        final currentMessages = state.valueOrNull ?? [];

        final optimisticMessage = Message(
            id: DateTime.now().millisecondsSinceEpoch,
            content: content ?? '',
            senderName: currentUser.name.isNotEmpty ? currentUser.name : currentUser.username,
            senderId: currentUser.id.toString(),
            group: params.id,
            timestamp: DateTime.now(),
            image: imageFile.path,
            isUploading: true,
            urgency: urgency,
        );
        state = AsyncData([optimisticMessage, ...currentMessages]);

        try
        {
            final messageRepository = ref.read(messageRepositoryProvider);
            final imageUrl = await messageRepository.uploadChatImage(imageFile);

            final payload = 
            {
                'group': params.id,
                'content': content ?? '',
                'image_url': imageUrl,
                'urgency': urgency,
            };

            final channel = await ref.read(webSocketChannelProvider(params).future);
            channel.sink.add(json.encode(payload));

        }
        catch (e)
        {
            print("Failed to send image message: $e");
            state = AsyncData(
                currentMessages.where((m) => m.id != optimisticMessage.id).toList());
        }
    }

    Future<void> sendOrderMessage({
        required Order order,
        required String urgency,
        required ChatConnectionParams params,
    }) async
    {
        final currentUser = ref.read(authStateChangesProvider).value;
        if (currentUser == null) return;

        final currentMessages = state.valueOrNull ?? [];
        final tempId = DateTime.now().millisecondsSinceEpoch;

        final tempMessage = Message(
            id: tempId,
            content: "Sharing an order...",
            senderName: currentUser.name.isNotEmpty ? currentUser.name : currentUser.username,
            senderId: currentUser.id.toString(),
            group: params.id,
            timestamp: DateTime.now(),
            urgency: urgency,
            isUploading: true,
        );
        state = AsyncData([tempMessage, ...currentMessages]);

        try
        {
            final orderRepository = ref.read(orderRepositoryProvider);

            final payload = 
            {
                'group': params.id,
                'order_id': order.id,
                'urgency': urgency,
            };

            final optimisticMessage = tempMessage.copyWith(
                order: order,
                isUploading: false,
                content: "",
            );

            final updatedMessages = List<Message>.from(state.valueOrNull ?? []);
            final tempMessageIndex = updatedMessages.indexWhere((m) => m.id == tempId);
            if (tempMessageIndex != -1) 
            {
                updatedMessages[tempMessageIndex] = optimisticMessage;
                state = AsyncData(updatedMessages);
            }

            final channel = await ref.read(webSocketChannelProvider(params).future);
            channel.sink.add(json.encode(payload));

        }
        catch (e)
        {
            print("Failed to send order message via WebSocket: $e");
            state = AsyncData(currentMessages);
        }
    }

    Future<void> deleteMessage(int messageId) async
    {
        try
        {
            final messageRepository = ref.read(messageRepositoryProvider);
            await messageRepository.deleteMessage(messageId);
            final currentMessages = state.valueOrNull ?? [];
            final updatedMessages =
                currentMessages.where((msg) => msg.id != messageId).toList();
            state = AsyncData(updatedMessages);
        }
        catch (e)
        {
            print("Controller Error: Failed to delete message: $e");
        }
    }

    Future<void> editMessage(int messageId, String newContent) async
    {
        try
        {
            final messageRepository = ref.read(messageRepositoryProvider);
            final updatedMessage =
                await messageRepository.editMessage(messageId, newContent);
            final currentMessages = state.valueOrNull ?? [];
            final updatedList = currentMessages.map((msg)
                {
                    return msg.id == messageId ? updatedMessage : msg;
                }
            ).toList();

            state = AsyncData(updatedList);
        }
        catch (e)
        {
            print("Controller Error: Failed to edit message: $e");
        }
    }
}
