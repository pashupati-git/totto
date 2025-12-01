import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/data/models/group_member_model.dart';
import 'package:totto/data/models/group_model.dart';
import 'package:totto/data/models/message_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/chat/create_chat_page.dart';
import 'package:totto/features/chat/personal_message_page.dart';
import 'package:totto/features/chat/utils/urgency_helpers.dart';
import 'package:totto/common/cards/order_history_card.dart';
import 'package:totto/features/order/order_history_page.dart';

class ChatBubble extends ConsumerWidget
{
    const ChatBubble({
        super.key,
        required this.message,
        required this.isCurrentUser,
        required this.group,
        required this.onCopy,
        required this.onDelete,
        required this.onEdit,
        required this.onReply,
    });

    final Message message;
    final bool isCurrentUser;
    final Group group;
    final VoidCallback onCopy;
    final VoidCallback onDelete;
    final VoidCallback onEdit;
    final VoidCallback onReply;

    @override
    Widget build(BuildContext context, WidgetRef ref) 
    {
        final backgroundColor = getUrgencyBackgroundColor(message.urgency);
        final textColor = getUrgencyTextColor(message.urgency);

        Widget avatarWidget;
        String displayName;

        if (isCurrentUser) 
        {
            final currentUser = ref.watch(authStateChangesProvider).value;
            final imageUrl = currentUser?.profileImageUrl;
            displayName = currentUser?.name.isNotEmpty == true ? currentUser!.name : message.senderName;

            final bool hasValidImageUrl = imageUrl != null && imageUrl.isNotEmpty;

            avatarWidget = CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: hasValidImageUrl ? NetworkImage(imageUrl) : null,
                child: !hasValidImageUrl ? const Icon(Icons.person, color: Colors.white) : null,
            );
        }
        else 
        {
            final matchingMembers = group.members.where((m) => m.user.id.toString() == message.senderId).toList();
            final GroupMember? senderMember = matchingMembers.isNotEmpty ? matchingMembers.first : null;
            if (senderMember != null) 
            {
                final imageUrl = senderMember.user.profileImageUrl;
                displayName = senderMember.user.name.isNotEmpty ? senderMember.user.name : senderMember.user.username;

                avatarWidget = CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: (imageUrl != null && imageUrl.isNotEmpty) ? NetworkImage(imageUrl) : null,
                    child: (imageUrl == null || imageUrl.isEmpty) ? const Icon(Icons.person, color: Colors.white) : null,
                );
            }
            else 
            {
                displayName = message.senderName;
                avatarWidget = const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, color: Colors.white),
                );
            }
        }

        if (message.order != null) {
            final order = message.order!;
            final currentUser = ref.watch(authStateChangesProvider).value;

            final adminMember = group.members.firstWhere(
                    (member) => member.role == 'A',
                orElse: () => GroupMember.empty(),
            );

            final orderCreatorMember = group.members.firstWhere(
                    (member) =>
                member.user.name == order.buyerName ||
                    member.user.username == order.buyerName,
                orElse: () => GroupMember.empty());
            final orderCreatorId = orderCreatorMember.user.id;

            final isGroupAdmin = currentUser?.id.toString() == adminMember.user.id.toString();
            final isOrderCreator = currentUser?.id.toString() == orderCreatorId;

            String buttonText;
            VoidCallback onButtonPressed;

            if (isGroupAdmin || isOrderCreator) {
                buttonText = 'View Group Orders'; // Changed text for clarity
                onButtonPressed = () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => OrderHistoryPage(
                                groupId: group.id,
                            ),
                        ),
                    );
                };
            } else {
                buttonText = 'Place a Bid';
                onButtonPressed = () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CreateChatPage(
                                otherUser: adminMember.user,
                                initialOrder: order,
                            ),
                        ),
                    );
                };
            }


            return Align(
                alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                    constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: OrderHistoryCard(
                        cardColor: getUrgencySolidColor(order.urgency ?? 'NORMAL'),
                        productName: order.productName,
                        price: order.displayPrice,
                        quantity: 'Qty: ${order.quantity}',
                        imageUrl: order.imageUrl ?? '',
                        buttonText: buttonText,
                        onButtonPressed: onButtonPressed,
                        statusDisplay: order.statusDisplay,
                        isAdmin: isGroupAdmin,
                        onStatusPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => OrderHistoryPage(
                                        groupId: group.id,
                                    ),
                                ),
                            );
                        },
                    ),
                ),
            );
        }

        final bool hasImage = message.image != null && message.image!.isNotEmpty;

        return GestureDetector(
            onLongPress: ()
            {
                final RenderBox renderBox = context.findRenderObject() as RenderBox;
                final position = renderBox.localToGlobal(Offset.zero);
                showMenu(
                    context: context,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    position: RelativeRect.fromLTRB(
                        position.dx + 50,
                        position.dy,
                        position.dx + renderBox.size.width - 50,
                        position.dy + renderBox.size.height,
                    ),
                    items: [
                        if (message.content.isNotEmpty) PopupMenuItem(onTap: onCopy, child: const ListTile(leading: Icon(Icons.copy), title: Text('Copy'))),
                        PopupMenuItem(onTap: onReply, child: const ListTile(leading: Icon(Icons.reply), title: Text('Reply'))),
                        if (isCurrentUser) PopupMenuItem(onTap: onEdit, child: const ListTile(leading: Icon(Icons.edit), title: Text('Edit'))),
                        if (isCurrentUser) PopupMenuItem(onTap: onDelete, child: const ListTile(leading: Icon(Icons.delete, color: Colors.red), title: Text('Delete', style: TextStyle(color: Colors.red)))),
                    ],
                );
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                    mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        if (!isCurrentUser) ...[
                            avatarWidget,
                            const SizedBox(width: 12),
                        ],
                        Flexible(
                            child: Column(
                                crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                children: [
                                    Text(displayName, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                    const SizedBox(height: 4),
                                    if (message.replyTo != null) _buildReplyContentPreview(context, message.replyTo!),
                                    Container(
                                        padding: hasImage && message.content.isEmpty ? EdgeInsets.zero : const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                            color: hasImage && message.content.isEmpty ? Colors.transparent : backgroundColor,
                                            borderRadius: BorderRadius.only(
                                                topLeft: isCurrentUser ? const Radius.circular(16) : Radius.zero,
                                                topRight: isCurrentUser ? Radius.zero : const Radius.circular(16),
                                                bottomLeft: const Radius.circular(16),
                                                bottomRight: const Radius.circular(16),
                                            ),
                                        ),
                                        child: Column(
                                            crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                            children: [
                                                if (hasImage) _buildImageContent(),
                                                if (message.content.isNotEmpty)
                                                Padding(
                                                    padding: hasImage ? const EdgeInsets.only(top: 8.0) : EdgeInsets.zero,
                                                    child: Text(
                                                        message.content,
                                                        style: TextStyle(color: textColor, height: 1.4),
                                                    ),
                                                ),
                                            ],
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        if (isCurrentUser) ...[
                            const SizedBox(width: 12),
                            avatarWidget,
                        ],
                    ],
                ),
            ),
        );
    }

    Widget _buildImageContent() 
    {
        Widget imageWidget;

        if (message.image!.startsWith('http')) 
        {
            imageWidget = Image.network(message.image!);
        }
        else 
        {
            imageWidget = Image.file(File(message.image!));
        }

        return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
                alignment: Alignment.center,
                children: [
                    imageWidget,
                    if (message.isUploading) const CircularProgressIndicator(color: Colors.white),
                ],
            ),
        );
    }

    Widget _buildReplyContentPreview(BuildContext context, Message replyMessage) 
    {
        return Container(
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                ),
                border: Border(left: BorderSide(color: Colors.red.shade300, width: 4)),
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        replyMessage.senderName,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade300, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                        replyMessage.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                ],
            ),
        );
    }
}
