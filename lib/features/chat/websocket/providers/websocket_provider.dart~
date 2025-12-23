import 'dart:async';
import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/chat/websocket/domain/chat_connection_params.dart';
import 'package:web_socket_channel/web_socket_channel.dart' as wsc;

part 'websocket_provider.g.dart';

@riverpod
class WebSocketChannel extends _$WebSocketChannel
{
    @override
    Future<wsc.WebSocketChannel> build(ChatConnectionParams params) async
    {
        final token = await ref.watch(authTokenProvider.future);
        if (token == null || token.isEmpty) 
        {
            throw Exception("WebSocket Error: No auth token found.");
        }

        final url = params.type == ChatType.group
            ? 'wss://totto.mindriserstech.com/ws/groupchat/${params.id}/?token=$token'
            : 'wss://totto.mindriserstech.com/ws/chat/${params.id}/?token=$token';

        print("Connecting to WebSocket: $url");

        final channel = wsc.WebSocketChannel.connect(Uri.parse(url));

        await channel.ready;

        print("WebSocket Connection Established.");

        ref.onDispose(()
            {
                print("Disposing WebSocket provider. Closing connection.");
                channel.sink.close();
            }
        );

        return channel;
    }
}

@riverpod
Stream<Map<String, dynamic>> webSocketMessages(
    WebSocketMessagesRef ref,
    ChatConnectionParams params,
)
{
    final channelAsyncValue = ref.watch(webSocketChannelProvider(params));

    return channelAsyncValue.when(
        data: (channel) => channel.stream.map((message)
            {
                return json.decode(message) as Map<String, dynamic>;
            }
        ),
        loading: () => const Stream.empty(),
        error: (err, stack) => Stream.error(err, stack),
    );
}
