import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:totto/common/appbar/common_app_bar.dart';
import 'package:totto/data/models/group_model.dart';
import 'package:totto/data/models/message_model.dart';
import 'package:totto/data/models/order_model.dart';
import 'package:totto/data/models/user_profile_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/chat/individual_chat_page.dart';
import 'package:totto/features/chat/providers/group_provider.dart';
import 'package:totto/features/chat/websocket/domain/chat_connection_params.dart';
import 'package:totto/features/chat/websocket/providers/chat_controller.dart';
import 'package:totto/features/chat/websocket/providers/websocket_provider.dart';
import 'package:totto/features/chat/widgets/chat_bubble.dart';
import 'package:totto/features/chat/widgets/image_preview_widget.dart';
import 'package:totto/l10n/app_localizations.dart';

class PersonalMessagePage extends ConsumerStatefulWidget {
    final UserProfile otherUser;
    final Order? initialOrder;
    final Group group;

    const PersonalMessagePage({
        super.key,
        required this.otherUser,
        required this.group,
        this.initialOrder,
    });

    @override
    ConsumerState<PersonalMessagePage> createState() =>
        _PersonalMessagePageState();
}

class _PersonalMessagePageState extends ConsumerState<PersonalMessagePage> {
    final _messageController = TextEditingController();
    final ScrollController _scrollController = ScrollController();
    final FocusNode _focusNode = FocusNode();
    bool _isTyping = false;

    Message? _editingMessage;
    Message? _replyingToMessage;

    bool _showInfoBanner = true;
    bool _initialOrderSent = false;

    @override
    void initState() {
        super.initState();
        _messageController.addListener(() {
            if (mounted) {
                setState(() {
                    _isTyping = _messageController.text.isNotEmpty;
                });
            }
        });
        _focusNode.addListener(() {
            if (mounted) setState(() {});
        });
    }

    @override
    void dispose() {
        _messageController.dispose();
        _scrollController.dispose();
        _focusNode.dispose();
        super.dispose();
    }

    void _handleCopyMessage(String content) {
        Clipboard.setData(ClipboardData(text: content));
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Message copied to clipboard"),
                duration: Duration(seconds: 2),
            ),
        );
    }

    void _handleDeleteMessage(int messageId, ChatConnectionParams params) {
        ref.read(chatControllerProvider(params).notifier).deleteMessage(messageId);
    }

    void _handleEditMessage(Message message) {
        setState(() {
            _editingMessage = message;
            _replyingToMessage = null;
            _messageController.text = message.content;
            _messageController.selection = TextSelection.fromPosition(
                TextPosition(offset: _messageController.text.length));
            _focusNode.requestFocus();
        });
    }

    void _handleReplyMessage(Message message) {
        setState(() {
            _replyingToMessage = message;
            _editingMessage = null;
            _focusNode.requestFocus();
        });
    }

    void _cancelEdit() {
        setState(() {
            _editingMessage = null;
            _messageController.clear();
            _focusNode.unfocus();
        });
    }

    void _cancelReply() {
        setState(() {
            _replyingToMessage = null;
        });
    }


    @override
    Widget build(BuildContext context) {
        final l10n = AppLocalizations.of(context)!;

        final group = widget.group;
        final params = ChatConnectionParams(type: ChatType.group, id: group.id);
        final messagesAsync = ref.watch(chatControllerProvider(params));
        final chatNotifier = ref.read(chatControllerProvider(params).notifier);

        if (widget.initialOrder != null && !_initialOrderSent) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
                chatNotifier.sendOrderMessage(
                    order: widget.initialOrder!,
                    urgency: widget.initialOrder!.urgency ?? 'NORMAL',
                    params: params,
                );
                if (mounted) {
                    setState(() {
                        _initialOrderSent = true;
                        _showInfoBanner = false;
                    });
                }
            });
        }

        return Scaffold(
            backgroundColor: const Color(0xFFF1F2F6),
            appBar: CommonAppBar(
                backgroundColor: const Color(0xFFF1F2F6),
                elevation: 0,
                leading: IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                title: Text(
                    widget.otherUser.name.isNotEmpty
                        ? widget.otherUser.name
                        : widget.otherUser.username.replaceFirst('@', ''),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                    ),
                ),
                actions: [
                    IconButton(
                        icon: const Icon(Icons.settings, color: Colors.black54),
                        onPressed: () {},
                    ),
                ],
            ),
            body: Column(
                children: [
                    if (_showInfoBanner && (messagesAsync.valueOrNull ?? []).isEmpty)
                        _buildInfoBanner(),
                    ConnectionStatusIndicator(params: params),
                    Expanded(
                        child: messagesAsync.when(
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (err, stack) =>
                                Center(child: Text('Error loading messages: $err')),
                            data: (messages) {
                                if (messages.isNotEmpty && _showInfoBanner) {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                        if (mounted) setState(() => _showInfoBanner = false);
                                    });
                                }
                                if (messages.isEmpty && !_showInfoBanner) {
                                    return _buildEmptyChatView(l10n);
                                }
                                return ListView.builder(
                                    controller: _scrollController,
                                    reverse: true,
                                    padding: const EdgeInsets.all(16.0),
                                    itemCount: messages.length,
                                    itemBuilder: (context, index) {
                                        final message = messages[index];
                                        final currentUser = ref.watch(authStateChangesProvider).value;
                                        final isCurrentUser =
                                            message.senderId == currentUser?.id.toString();

                                        return ChatBubble(
                                            message: message,
                                            isCurrentUser: isCurrentUser,
                                            group: group,
                                            onCopy: () => _handleCopyMessage(message.content),
                                            onDelete: () =>
                                                _handleDeleteMessage(message.id, params),
                                            onEdit: () => _handleEditMessage(message),
                                            onReply: () => _handleReplyMessage(message),
                                        );
                                    },
                                );
                            },
                        ),
                    ),
                    if (_editingMessage != null) _buildEditPreview(),
                    if (_replyingToMessage != null) _buildReplyPreview(),
                    _buildMessageComposer(l10n, params),
                ],
            ),
        );
    }

    Widget _buildInfoBanner() {
        return Align(
            alignment: Alignment.center,
            child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.red.shade700,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(4),
                        topRight: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                    ),
                ),
                child: const Text(
                    'Start a conversation with your vendor.\nQuick, Clear, and Direct.',
                    style: TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
                    textAlign: TextAlign.center,
                ),
            ),
        );
    }

    Widget _buildEmptyChatView(AppLocalizations l10n) =>
        Center(child: Text(l10n.noMessagesYet));

    Widget _buildEditPreview() {
        return Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
                children: [
                    const Icon(Icons.edit, size: 20, color: Colors.black54),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                const Text('Editing Message', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    _editingMessage!.content,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.black54),
                                ),
                            ],
                        ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.close, size: 20, color: Colors.black54),
                        onPressed: _cancelEdit,
                    )
                ],
            ),
        );
    }

    Widget _buildReplyPreview() {
        return Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
                children: [
                    const Icon(Icons.reply, size: 20, color: Colors.black54),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text('Replying to ${_replyingToMessage!.senderName}',
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                    _replyingToMessage!.content,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: Colors.black54),
                                ),
                            ],
                        ),
                    ),
                    IconButton(
                        icon: const Icon(Icons.close, size: 20, color: Colors.black54),
                        onPressed: _cancelReply,
                    )
                ],
            ),
        );
    }

    Widget _buildMessageComposer(AppLocalizations l10n,
        ChatConnectionParams params)  {
        final isEditing = _editingMessage != null;

        void _sendMessage() {
            final content = _messageController.text.trim();
            if (content.isEmpty) return;

            if (isEditing) {
                ref.read(chatControllerProvider(params).notifier).editMessage(_editingMessage!.id, content);
                _cancelEdit();
            } else if (_replyingToMessage != null) {
                ref.read(chatControllerProvider(params).notifier).sendMessage(
                    content,
                    params,
                    replyToId: _replyingToMessage!.id,
                    urgency: 'NORMAL',
                );
                _cancelReply();
            } else {
                ref.read(chatControllerProvider(params).notifier).sendMessage(
                    content,
                    params,
                    urgency: 'NORMAL',
                );
            }
            _messageController.clear();
            if (mounted) setState(() => _showInfoBanner = false);
        }

        Future<void> _sendImage() async {
            final picker = ImagePicker();
            final image =
            await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
            if (image != null) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ImagePreviewWidget(
                        imageFile: File(image.path),
                        params: params,
                    ),
                ));
            }
        }

        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            color: Colors.white,
            child: SafeArea(
                child: Row(
                    children: [
                        Expanded(
                            child: TextField(
                                controller: _messageController,
                                focusNode: _focusNode,
                                decoration: InputDecoration(
                                    hintText: l10n.messageHint,
                                    filled: true,
                                    fillColor: Colors.grey.shade100,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: BorderSide.none,
                                    ),
                                    contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                                    suffixIcon: _isTyping
                                        ? IconButton(
                                        icon: Icon(isEditing ? Icons.check : Icons.send,
                                            color: Colors.red),
                                        onPressed: _sendMessage,
                                    )
                                        : Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                            IconButton(
                                                icon:
                                                const Icon(Icons.mic, color: Colors.grey),
                                                onPressed: () {},
                                            ),
                                            IconButton(
                                                icon:
                                                const Icon(Icons.image, color: Colors.grey),
                                                onPressed: _sendImage,
                                            ),
                                        ],
                                    ),
                                ),
                                onSubmitted: (_) => _sendMessage(),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }
}