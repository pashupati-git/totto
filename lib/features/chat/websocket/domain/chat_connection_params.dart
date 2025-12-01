
import 'package:flutter/foundation.dart';

enum ChatType
{
    group, personal
}

@immutable
class ChatConnectionParams
{
    final ChatType type;
    final String id;

    const ChatConnectionParams({required this.type, required this.id});

    @override
    bool operator==(Object other)
    {
        if (identical(this, other)) return true;
        return other is ChatConnectionParams && other.type == type && other.id == id;
    }

    @override
    int get hashCode => type.hashCode ^ id.hashCode;
}
