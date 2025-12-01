import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:totto/data/models/group_model.dart';
import 'package:totto/data/models/message_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/chat/utils/urgency_helpers.dart';
import 'package:totto/features/chat/websocket/domain/chat_connection_params.dart';
import 'package:totto/features/chat/websocket/providers/chat_controller.dart';
import 'package:totto/features/chat/websocket/providers/websocket_provider.dart';
import 'package:totto/features/chat/widgets/chat_bubble.dart';
import 'package:totto/features/chat/widgets/image_preview_widget.dart';
import 'package:totto/features/order/order_history_page.dart';
import 'package:totto/l10n/app_localizations.dart';

import '../order/order_placement_page.dart';
import 'chat_settings_page.dart';

class IndividualChatPage extends ConsumerStatefulWidget
{
    const IndividualChatPage({
        super.key,
        required this.group,
        required this.params,
    });

    final Group group;
    final ChatConnectionParams params;

    @override
    ConsumerState<IndividualChatPage> createState() => _IndividualChatPageState();
}

class _IndividualChatPageState extends ConsumerState<IndividualChatPage>
{
    final _messageController = TextEditingController();
    final ScrollController _scrollController = ScrollController();

    final FocusNode _focusNode = FocusNode();
    String _selectedUrgency = 'NORMAL';
    final List<String> _urgencyLevels = ['NORMAL', 'HIGH', 'URGENT'];

    bool _isTyping = false;

    Message? _editingMessage;
    Message? _replyingToMessage;

    @override
    void initState()
    {
        super.initState();
        _messageController.addListener(()
            {
                if (mounted)
                {
                    setState(()
                        {
                            _isTyping = _messageController.text.isNotEmpty;
                        }
                    );
                }
            }
        );

        _focusNode.addListener(()
            {
                if (mounted)
                {
                    setState(()
                        {
                        }
                    );
                }
            }
        );
    }

    @override
    void dispose()
    {
        _messageController.dispose();
        _scrollController.dispose();
        _focusNode.dispose();
        super.dispose();
    }

    void _cycleUrgency()
    {
        setState(()
            {
                final currentIndex = _urgencyLevels.indexOf(_selectedUrgency);
                final nextIndex = (currentIndex + 1) % _urgencyLevels.length;
                _selectedUrgency = _urgencyLevels[nextIndex];
            }
        );
    }

    void _sendMessage()
    {
        final content = _messageController.text.trim();
        if (content.isEmpty) return;

        if (_editingMessage != null)
        {
            ref
                .read(chatControllerProvider(widget.params).notifier)
                .editMessage(_editingMessage!.id, content);
            setState(() => _editingMessage = null);
        }
        else if (_replyingToMessage != null)
        {
            ref.read(chatControllerProvider(widget.params).notifier).sendMessage(
                content,
                widget.params,
                replyToId: _replyingToMessage!.id,
                urgency: _selectedUrgency,
            );
            setState(() => _replyingToMessage = null);
        }
        else
        {
            ref
                .read(chatControllerProvider(widget.params).notifier)
                .sendMessage(content, widget.params, urgency: _selectedUrgency);
        }

        _messageController.clear();
        setState(()
            {
                _selectedUrgency = 'NORMAL';
            }
        );
        FocusScope.of(context).unfocus();
    }

    Future<void> _sendImage() async
    {
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

        if (image != null)
        {
            final imageFile = File(image.path);
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => ImagePreviewWidget(
                        imageFile: imageFile,
                        params: widget.params,
                    ),
                ),
            );
        }
    }

    void _handleCopyMessage(String content)
    {
        Clipboard.setData(ClipboardData(text: content));
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Message copied to clipboard"),
                duration: Duration(seconds: 2),
            ),
        );
    }

    void _handleDeleteMessage(int messageId)
    {
        showDialog(
            context: context,
            builder: (BuildContext context)
            {
                return AlertDialog(
                    title: const Text("Delete Message"),
                    content:
                    const Text("Are you sure you want to permanently delete this message?"),
                    actions: <Widget>[
                        TextButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                            child: const Text("Delete", style: TextStyle(color: Colors.red)),
                            onPressed: ()
                            {
                                Navigator.of(context).pop();
                                ref
                                    .read(chatControllerProvider(widget.params).notifier)
                                    .deleteMessage(messageId);
                            },
                        ),
                    ],
                );
            },
        );
    }

    void _handleEditMessage(Message message)
    {
        setState(()
            {
                _editingMessage = message;
                _replyingToMessage = null;
                _messageController.text = message.content;
                _messageController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _messageController.text.length),
                );
            }
        );
        FocusScope.of(context).requestFocus();
    }

    void _handleReplyMessage(Message message)
    {
        setState(()
            {
                _replyingToMessage = message;
                _editingMessage = null;
            }
        );
        FocusScope.of(context).requestFocus();
    }

    void _cancelEdit()
    {
        setState(()
            {
                _editingMessage = null;
                _messageController.clear();
            }
        );
        FocusScope.of(context).unfocus();
    }

    void _cancelReply()
    {
        setState(()
            {
                _replyingToMessage = null;
            }
        );
    }

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        final messagesAsync = ref.watch(chatControllerProvider(widget.params));
        final currentUser = ref.watch(authStateChangesProvider).value;

        return Scaffold(
            backgroundColor: const Color(0xFFF1F2F6),
            appBar: AppBar(
                backgroundColor: const Color(0xFFF1F2F6),
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                title: GestureDetector(
                    onTap: ()
                    {
                        Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => ChatSettingsPage(
                                    group: widget.group,
                                ),
                            ),
                        );
                    },
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Text(
                                widget.group.name,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black54,
                                size: 20,
                            ),
                        ],
                    ),
                ),
                actions: [
                    Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: ()
                            {
                                Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => const OrderHistoryPage(),
                                    ),
                                );
                            },
                            child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                        BoxShadow(
                                            color: Colors.blue.withOpacity(0.3),
                                            blurRadius: 6,
                                            offset: const Offset(0, 3),
                                        ),
                                    ],
                                    image: const DecorationImage(
                                        image: AssetImage('assets/orderhistoryicon.png'),
                                        fit: BoxFit.cover,
                                    ),
                                ),
                            ),
                        ),
                    ),
                ],
                centerTitle: true,
            ),
            body: Column(
                children: [
                    ConnectionStatusIndicator(params: widget.params),
                    Expanded(
                        child: messagesAsync.when(
                            loading: () =>
                            const Center(child: CircularProgressIndicator(color: Colors.red)),
                            error: (err, stack) =>
                            Center(child: Text(l10n.failedToLoadMessages(err.toString()))),
                            data: (messages)
                            {
                                WidgetsBinding.instance.addPostFrameCallback((_)
                                    {
                                        if (_scrollController.hasClients)
                                        {
                                            _scrollController.animateTo(
                                                0.0,
                                                duration: const Duration(milliseconds: 300),
                                                curve: Curves.easeOut,
                                            );
                                        }
                                    }
                                );
                                return ListView.builder(
                                    controller: _scrollController,
                                    reverse: true,
                                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                    itemCount: messages.length,
                                    itemBuilder: (context, index)
                                    {
                                        final message = messages[index];
                                        final isCurrentUser =
                                            message.senderId == currentUser?.id.toString();

                                        final chatBubble = ChatBubble(
                                            message: message,
                                            isCurrentUser: isCurrentUser,
                                            group: widget.group,
                                            onCopy: () => _handleCopyMessage(message.content),
                                            onDelete: () => _handleDeleteMessage(message.id),
                                            onEdit: () => _handleEditMessage(message),
                                            onReply: () => _handleReplyMessage(message),
                                        );

                                        if (index == messages.length - 1)
                                        {
                                            return Column(
                                                children: [
                                                    _buildTimestamp(l10n.today),
                                                    chatBubble,
                                                ],
                                            );
                                        }
                                        return chatBubble;
                                    },
                                );
                            },
                        ),
                    ),
                    if (_editingMessage != null) _buildEditPreview(),
                    if (_replyingToMessage != null) _buildReplyPreview(),
                    _buildMessageComposer(l10n),
                ],
            ),
        );
    }

    Widget _buildEditPreview()
    {
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

    Widget _buildReplyPreview()
    {
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

    Widget _buildTimestamp(String text)
    {
        return Center(
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                ),
                child: Text(text,
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
            ),
        );
    }

    Widget _buildMessageComposer(AppLocalizations l10n)
    {
        final isEditing = _editingMessage != null;

        final Map<String, IconData> urgencyIcons =
        {
            'NORMAL': Icons.flag_outlined,
            'HIGH': Icons.flag,
            'URGENT': Icons.flag,
        };
        final Map<String, Color> urgencyColors =
        {
            'NORMAL': getUrgencyTextColor('NORMAL'),
            'HIGH': getUrgencyTextColor('HIGH'),
            'URGENT': getUrgencyTextColor('URGENT'),
        };

        Widget urgencySelector = CircleAvatar(
            backgroundColor: Colors.grey.shade200,
            child: IconButton(
                tooltip: 'Set message urgency',
                icon: Icon(
                    urgencyIcons[_selectedUrgency],
                    color: urgencyColors[_selectedUrgency],
                ),
                onPressed: _cycleUrgency,
            ),
        );

        Widget orderButton = CircleAvatar(
            backgroundColor: Colors.red.shade100,
            child: IconButton(
                icon: Image.asset('assets/logos/Order.png', color: Colors.red),
                onPressed: () async {
                    final result = await Navigator.of(context).push<bool>(
                        MaterialPageRoute(
                            builder: (context) =>
                                OrderPlacementPage(groupId: widget.group.id),
                        ),
                    );

                    if (result == true) {
                        ref.invalidate(chatControllerProvider(widget.params));
                    }
                },
            ),
        );

        return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            color: Colors.white,
            child: SafeArea(
                child: Row(
                    children: [
                        _focusNode.hasFocus ? urgencySelector : orderButton,
                        const SizedBox(width: 12),
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
                                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    suffixIcon: _isTyping
                                        ? IconButton(
                                            icon: Icon(isEditing ? Icons.check : Icons.send,
                                                color: Colors.red),
                                            onPressed: _sendMessage,
                                        )
                                        : (isEditing
                                            ? null
                                            : Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                    IconButton(
                                                        icon: const Icon(Icons.mic,
                                                            color: Colors.grey),
                                                        onPressed: ()
                                                        {
                                                        }
                                                    ),
                                                    IconButton(
                                                        icon: const Icon(Icons.image,
                                                            color: Colors.grey),
                                                        onPressed: _sendImage),
                                                ],
                                            )),
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

class ConnectionStatusIndicator extends ConsumerWidget
{
    const ConnectionStatusIndicator({super.key, required this.params});
    final ChatConnectionParams params;
    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        final socketConnection = ref.watch(webSocketChannelProvider(params));
        return socketConnection.when(
            data: (_) => const SizedBox.shrink(),
            loading: () => Container(
                width: double.infinity,
                color: Colors.orange.shade100,
                padding: const EdgeInsets.all(4.0),
                child: const Text(
                    "Connecting...",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                ),
            ),
            error: (err, stack) => Container(
                width: double.infinity,
                color: Colors.red.shade100,
                padding: const EdgeInsets.all(4.0),
                child: const Text(
                    "Connection error. Trying to reconnect...",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.red),
                ),
            ),
        );
    }
}

