import 'package:totto/data/models/order_model.dart';

class Message
{
    final int id;
    final String content;
    final String senderName;
    final String senderId;
    final String group;
    final DateTime timestamp;
    final String urgency;
    final Order? order;
    final Message? replyTo;
    final String? image;
    final bool isUploading;

    const Message({
        required this.id,
        required this.content,
        required this.senderName,
        required this.senderId,
        required this.group,
        required this.timestamp,
        required this.urgency,
        this.order,
        this.replyTo,
        this.image,
        this.isUploading = false,
    });

    factory Message.fromJson(Map<String, dynamic> json)
    {
        String senderIdStr = json['sender']?.toString() ?? '';

        Message? replyMessage;
        if (json['reply_to'] != null && json['reply_to'] is Map<String, dynamic>) 
        {
            final replyJson = json['reply_to'] as Map<String, dynamic>;
            replyMessage = Message.fromJson(replyJson);
        }

        final String? imageUrl = json['image_url'] as String? ?? json['image'] as String?;

        Order? order;
        if (json['order'] != null && json['order'] is Map<String, dynamic>) 
        {
            order = Order.fromJson(json['order']);
        }

        return Message(
            id: json['id'] as int? ?? 0,
            content: json['content'] as String? ?? '',
            senderName: json['sender_name'] as String? ?? 'Unknown',
            senderId: senderIdStr,
            group: json['group'] as String? ?? '',
            timestamp: DateTime.tryParse(json['timestamp'] as String? ?? json['created_at'] as String? ?? '')?.toLocal() ?? DateTime.now(),
            urgency: json['urgency'] as String? ?? 'NORMAL',
            replyTo: replyMessage,
            image: imageUrl,
            order: order,
        );
    }

    Message copyWith({
        int? id,
        String? content,
        String? senderName,
        String? senderId,
        String? group,
        DateTime? timestamp,
        String? urgency,
        Order? order,
        Message? replyTo,
        String? image,
        bool? isUploading,
    }) 
    {
        return Message(
            id: id ?? this.id,
            content: content ?? this.content,
            senderName: senderName ?? this.senderName,
            senderId: senderId ?? this.senderId,
            group: group ?? this.group,
            timestamp: timestamp ?? this.timestamp,
            urgency: urgency ?? this.urgency,
            order: order ?? this.order,
            replyTo: replyTo ?? this.replyTo,
            image: image ?? this.image,
            isUploading: isUploading ?? this.isUploading,
        );
    }
}
