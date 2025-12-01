// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'socket_message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SocketMessage {

 int get id; String get urgency_display; String get sender_name; String get urgency_color; String get urgency_bg_color; String get created_at; String get updated_at; String get urgency; String get content; String get image; String? get timestamp; int get sender; int get receiver; String get group; int get product; int get order;
/// Create a copy of SocketMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SocketMessageCopyWith<SocketMessage> get copyWith => _$SocketMessageCopyWithImpl<SocketMessage>(this as SocketMessage, _$identity);

  /// Serializes this SocketMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SocketMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.urgency_display, urgency_display) || other.urgency_display == urgency_display)&&(identical(other.sender_name, sender_name) || other.sender_name == sender_name)&&(identical(other.urgency_color, urgency_color) || other.urgency_color == urgency_color)&&(identical(other.urgency_bg_color, urgency_bg_color) || other.urgency_bg_color == urgency_bg_color)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.updated_at, updated_at) || other.updated_at == updated_at)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.content, content) || other.content == content)&&(identical(other.image, image) || other.image == image)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.receiver, receiver) || other.receiver == receiver)&&(identical(other.group, group) || other.group == group)&&(identical(other.product, product) || other.product == product)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,urgency_display,sender_name,urgency_color,urgency_bg_color,created_at,updated_at,urgency,content,image,timestamp,sender,receiver,group,product,order);

@override
String toString() {
  return 'SocketMessage(id: $id, urgency_display: $urgency_display, sender_name: $sender_name, urgency_color: $urgency_color, urgency_bg_color: $urgency_bg_color, created_at: $created_at, updated_at: $updated_at, urgency: $urgency, content: $content, image: $image, timestamp: $timestamp, sender: $sender, receiver: $receiver, group: $group, product: $product, order: $order)';
}


}

/// @nodoc
abstract mixin class $SocketMessageCopyWith<$Res>  {
  factory $SocketMessageCopyWith(SocketMessage value, $Res Function(SocketMessage) _then) = _$SocketMessageCopyWithImpl;
@useResult
$Res call({
 int id, String urgency_display, String sender_name, String urgency_color, String urgency_bg_color, String created_at, String updated_at, String urgency, String content, String image, String? timestamp, int sender, int receiver, String group, int product, int order
});




}
/// @nodoc
class _$SocketMessageCopyWithImpl<$Res>
    implements $SocketMessageCopyWith<$Res> {
  _$SocketMessageCopyWithImpl(this._self, this._then);

  final SocketMessage _self;
  final $Res Function(SocketMessage) _then;

/// Create a copy of SocketMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? urgency_display = null,Object? sender_name = null,Object? urgency_color = null,Object? urgency_bg_color = null,Object? created_at = null,Object? updated_at = null,Object? urgency = null,Object? content = null,Object? image = null,Object? timestamp = freezed,Object? sender = null,Object? receiver = null,Object? group = null,Object? product = null,Object? order = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,urgency_display: null == urgency_display ? _self.urgency_display : urgency_display // ignore: cast_nullable_to_non_nullable
as String,sender_name: null == sender_name ? _self.sender_name : sender_name // ignore: cast_nullable_to_non_nullable
as String,urgency_color: null == urgency_color ? _self.urgency_color : urgency_color // ignore: cast_nullable_to_non_nullable
as String,urgency_bg_color: null == urgency_bg_color ? _self.urgency_bg_color : urgency_bg_color // ignore: cast_nullable_to_non_nullable
as String,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as String,updated_at: null == updated_at ? _self.updated_at : updated_at // ignore: cast_nullable_to_non_nullable
as String,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as int,receiver: null == receiver ? _self.receiver : receiver // ignore: cast_nullable_to_non_nullable
as int,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SocketMessage].
extension SocketMessagePatterns on SocketMessage {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SocketMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SocketMessage() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SocketMessage value)  $default,){
final _that = this;
switch (_that) {
case _SocketMessage():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SocketMessage value)?  $default,){
final _that = this;
switch (_that) {
case _SocketMessage() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String urgency_display,  String sender_name,  String urgency_color,  String urgency_bg_color,  String created_at,  String updated_at,  String urgency,  String content,  String image,  String? timestamp,  int sender,  int receiver,  String group,  int product,  int order)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SocketMessage() when $default != null:
return $default(_that.id,_that.urgency_display,_that.sender_name,_that.urgency_color,_that.urgency_bg_color,_that.created_at,_that.updated_at,_that.urgency,_that.content,_that.image,_that.timestamp,_that.sender,_that.receiver,_that.group,_that.product,_that.order);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String urgency_display,  String sender_name,  String urgency_color,  String urgency_bg_color,  String created_at,  String updated_at,  String urgency,  String content,  String image,  String? timestamp,  int sender,  int receiver,  String group,  int product,  int order)  $default,) {final _that = this;
switch (_that) {
case _SocketMessage():
return $default(_that.id,_that.urgency_display,_that.sender_name,_that.urgency_color,_that.urgency_bg_color,_that.created_at,_that.updated_at,_that.urgency,_that.content,_that.image,_that.timestamp,_that.sender,_that.receiver,_that.group,_that.product,_that.order);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String urgency_display,  String sender_name,  String urgency_color,  String urgency_bg_color,  String created_at,  String updated_at,  String urgency,  String content,  String image,  String? timestamp,  int sender,  int receiver,  String group,  int product,  int order)?  $default,) {final _that = this;
switch (_that) {
case _SocketMessage() when $default != null:
return $default(_that.id,_that.urgency_display,_that.sender_name,_that.urgency_color,_that.urgency_bg_color,_that.created_at,_that.updated_at,_that.urgency,_that.content,_that.image,_that.timestamp,_that.sender,_that.receiver,_that.group,_that.product,_that.order);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SocketMessage implements SocketMessage {
  const _SocketMessage({this.id = 0, this.urgency_display = '', this.sender_name = '', this.urgency_color = '', this.urgency_bg_color = '', this.created_at = '', this.updated_at = '', this.urgency = '', this.content = '', this.image = '', this.timestamp, this.sender = 0, this.receiver = 0, this.group = '', this.product = 0, this.order = 0});
  factory _SocketMessage.fromJson(Map<String, dynamic> json) => _$SocketMessageFromJson(json);

@override@JsonKey() final  int id;
@override@JsonKey() final  String urgency_display;
@override@JsonKey() final  String sender_name;
@override@JsonKey() final  String urgency_color;
@override@JsonKey() final  String urgency_bg_color;
@override@JsonKey() final  String created_at;
@override@JsonKey() final  String updated_at;
@override@JsonKey() final  String urgency;
@override@JsonKey() final  String content;
@override@JsonKey() final  String image;
@override final  String? timestamp;
@override@JsonKey() final  int sender;
@override@JsonKey() final  int receiver;
@override@JsonKey() final  String group;
@override@JsonKey() final  int product;
@override@JsonKey() final  int order;

/// Create a copy of SocketMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SocketMessageCopyWith<_SocketMessage> get copyWith => __$SocketMessageCopyWithImpl<_SocketMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SocketMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SocketMessage&&(identical(other.id, id) || other.id == id)&&(identical(other.urgency_display, urgency_display) || other.urgency_display == urgency_display)&&(identical(other.sender_name, sender_name) || other.sender_name == sender_name)&&(identical(other.urgency_color, urgency_color) || other.urgency_color == urgency_color)&&(identical(other.urgency_bg_color, urgency_bg_color) || other.urgency_bg_color == urgency_bg_color)&&(identical(other.created_at, created_at) || other.created_at == created_at)&&(identical(other.updated_at, updated_at) || other.updated_at == updated_at)&&(identical(other.urgency, urgency) || other.urgency == urgency)&&(identical(other.content, content) || other.content == content)&&(identical(other.image, image) || other.image == image)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.receiver, receiver) || other.receiver == receiver)&&(identical(other.group, group) || other.group == group)&&(identical(other.product, product) || other.product == product)&&(identical(other.order, order) || other.order == order));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,urgency_display,sender_name,urgency_color,urgency_bg_color,created_at,updated_at,urgency,content,image,timestamp,sender,receiver,group,product,order);

@override
String toString() {
  return 'SocketMessage(id: $id, urgency_display: $urgency_display, sender_name: $sender_name, urgency_color: $urgency_color, urgency_bg_color: $urgency_bg_color, created_at: $created_at, updated_at: $updated_at, urgency: $urgency, content: $content, image: $image, timestamp: $timestamp, sender: $sender, receiver: $receiver, group: $group, product: $product, order: $order)';
}


}

/// @nodoc
abstract mixin class _$SocketMessageCopyWith<$Res> implements $SocketMessageCopyWith<$Res> {
  factory _$SocketMessageCopyWith(_SocketMessage value, $Res Function(_SocketMessage) _then) = __$SocketMessageCopyWithImpl;
@override @useResult
$Res call({
 int id, String urgency_display, String sender_name, String urgency_color, String urgency_bg_color, String created_at, String updated_at, String urgency, String content, String image, String? timestamp, int sender, int receiver, String group, int product, int order
});




}
/// @nodoc
class __$SocketMessageCopyWithImpl<$Res>
    implements _$SocketMessageCopyWith<$Res> {
  __$SocketMessageCopyWithImpl(this._self, this._then);

  final _SocketMessage _self;
  final $Res Function(_SocketMessage) _then;

/// Create a copy of SocketMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? urgency_display = null,Object? sender_name = null,Object? urgency_color = null,Object? urgency_bg_color = null,Object? created_at = null,Object? updated_at = null,Object? urgency = null,Object? content = null,Object? image = null,Object? timestamp = freezed,Object? sender = null,Object? receiver = null,Object? group = null,Object? product = null,Object? order = null,}) {
  return _then(_SocketMessage(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,urgency_display: null == urgency_display ? _self.urgency_display : urgency_display // ignore: cast_nullable_to_non_nullable
as String,sender_name: null == sender_name ? _self.sender_name : sender_name // ignore: cast_nullable_to_non_nullable
as String,urgency_color: null == urgency_color ? _self.urgency_color : urgency_color // ignore: cast_nullable_to_non_nullable
as String,urgency_bg_color: null == urgency_bg_color ? _self.urgency_bg_color : urgency_bg_color // ignore: cast_nullable_to_non_nullable
as String,created_at: null == created_at ? _self.created_at : created_at // ignore: cast_nullable_to_non_nullable
as String,updated_at: null == updated_at ? _self.updated_at : updated_at // ignore: cast_nullable_to_non_nullable
as String,urgency: null == urgency ? _self.urgency : urgency // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,timestamp: freezed == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as String?,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as int,receiver: null == receiver ? _self.receiver : receiver // ignore: cast_nullable_to_non_nullable
as int,group: null == group ? _self.group : group // ignore: cast_nullable_to_non_nullable
as String,product: null == product ? _self.product : product // ignore: cast_nullable_to_non_nullable
as int,order: null == order ? _self.order : order // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
