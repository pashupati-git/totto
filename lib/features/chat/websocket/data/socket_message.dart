
import 'package:freezed_annotation/freezed_annotation.dart';

part 'socket_message.freezed.dart';
part 'socket_message.g.dart';

@freezed
class SocketMessage with _$SocketMessage
{
    const factory SocketMessage({
        @Default(0) int id,
        @Default('') String urgency_display,
        @Default('') String sender_name,
        @Default('') String urgency_color,
        @Default('') String urgency_bg_color,
        @Default('') String created_at,
        @Default('') String updated_at,
        @Default('') String urgency,
        @Default('') String content,
        @Default('') String image,
        String? timestamp,
        @Default(0) int sender,
        @Default(0) int receiver,
        @Default('') String group,
        @Default(0) int product,
        @Default(0) int order,
    }) = _SocketMessage;

    factory SocketMessage.fromJson(Map<String, dynamic> json) =>
    _$SocketMessageFromJson(json);

  @override
  // TODO: implement content
  String get content => throw UnimplementedError();

  @override
  // TODO: implement created_at
  String get created_at => throw UnimplementedError();

  @override
  // TODO: implement group
  String get group => throw UnimplementedError();

  @override
  // TODO: implement id
  int get id => throw UnimplementedError();

  @override
  // TODO: implement image
  String get image => throw UnimplementedError();

  @override
  // TODO: implement order
  int get order => throw UnimplementedError();

  @override
  // TODO: implement product
  int get product => throw UnimplementedError();

  @override
  // TODO: implement receiver
  int get receiver => throw UnimplementedError();

  @override
  // TODO: implement sender
  int get sender => throw UnimplementedError();

  @override
  // TODO: implement sender_name
  String get sender_name => throw UnimplementedError();

  @override
  // TODO: implement timestamp
  String? get timestamp => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  // TODO: implement updated_at
  String get updated_at => throw UnimplementedError();

  @override
  // TODO: implement urgency
  String get urgency => throw UnimplementedError();

  @override
  // TODO: implement urgency_bg_color
  String get urgency_bg_color => throw UnimplementedError();

  @override
  // TODO: implement urgency_color
  String get urgency_color => throw UnimplementedError();

  @override
  // TODO: implement urgency_display
  String get urgency_display => throw UnimplementedError();
}
