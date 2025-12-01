import 'package:totto/data/models/user_profile_model.dart';

class GroupMember
{
    final int id;
    final UserProfile user;
    final String group;
    final String role;
    final DateTime joinedAt;

    const GroupMember({
        required this.id,
        required this.user,
        required this.group,
        required this.role,
        required this.joinedAt,
    });

    factory GroupMember.empty() {
        return GroupMember(
            id: 0,
            user: UserProfile.empty(),
            group: '',
            role: '',
            joinedAt: DateTime.now(),
        );
    }

    factory GroupMember.fromJson(Map<String, dynamic> json)
    {
        return GroupMember(
            id: json['id'] as int? ?? 0,
            user: UserProfile.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
            group: json['group'] as String? ?? '',
            role: json['role'] as String? ?? 'M',
            joinedAt: DateTime.tryParse(json['joined_at'] as String? ?? '') ?? DateTime.now(),
        );
    }
}
