import 'package:flutter/foundation.dart';

@immutable
class Unit
{
    final int id;
    final String name;

    const Unit({
        required this.id,
        required this.name,
    });

    factory Unit.fromJson(Map<String, dynamic> json)
    {
        return Unit(
            id: json['id'] as int? ?? 0,

            name: json['name'] as String? ?? 'Unnamed Unit',


        );
    }

    @override
    bool operator==(Object other) =>
    identical(this, other) ||
        other is Unit && runtimeType == other.runtimeType && id == other.id;

    @override
    int get hashCode => id.hashCode;
}
