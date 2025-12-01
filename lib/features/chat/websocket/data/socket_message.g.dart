// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'socket_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SocketMessage _$SocketMessageFromJson(Map<String, dynamic> json) =>
    _SocketMessage(
      id: (json['id'] as num?)?.toInt() ?? 0,
      urgency_display: json['urgency_display'] as String? ?? '',
      sender_name: json['sender_name'] as String? ?? '',
      urgency_color: json['urgency_color'] as String? ?? '',
      urgency_bg_color: json['urgency_bg_color'] as String? ?? '',
      created_at: json['created_at'] as String? ?? '',
      updated_at: json['updated_at'] as String? ?? '',
      urgency: json['urgency'] as String? ?? '',
      content: json['content'] as String? ?? '',
      image: json['image'] as String? ?? '',
      timestamp: json['timestamp'] as String?,
      sender: (json['sender'] as num?)?.toInt() ?? 0,
      receiver: (json['receiver'] as num?)?.toInt() ?? 0,
      group: json['group'] as String? ?? '',
      product: (json['product'] as num?)?.toInt() ?? 0,
      order: (json['order'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SocketMessageToJson(_SocketMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'urgency_display': instance.urgency_display,
      'sender_name': instance.sender_name,
      'urgency_color': instance.urgency_color,
      'urgency_bg_color': instance.urgency_bg_color,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'urgency': instance.urgency,
      'content': instance.content,
      'image': instance.image,
      'timestamp': instance.timestamp,
      'sender': instance.sender,
      'receiver': instance.receiver,
      'group': instance.group,
      'product': instance.product,
      'order': instance.order,
    };
