import 'package:flutter/foundation.dart';
import 'package:totto/data/models/group_member_model.dart';

@immutable
class Group
{
    final String id;
    final String name;
    final String guidelines;
    final String roomTypeDisplay;
    final String category;
    final int categoryId;
    final String createdBy;
    final int memberCount;
    final DateTime createdAt;
    final List<GroupMember> members;

    final bool? isCreator;
    final bool? isMember;
    final String? userRole;

    const Group({
        required this.id,
        required this.name,
        required this.guidelines,
        required this.roomTypeDisplay,
        required this.category,
        required this.categoryId,
        required this.createdBy,
        required this.memberCount,
        required this.createdAt,
        required this.members,
        this.isCreator,
        this.isMember,
        this.userRole,
    });

    factory Group.fromJson(Map<String, dynamic> json)
    {
        final membersData = json['members'] as List<dynamic>? ?? [];
        final membersList = membersData.map((memberJson) => GroupMember.fromJson(memberJson)).toList();

        return Group(
            id: json['id'] as String? ?? '',
            name: json['name'] as String? ?? 'Unnamed Group',
            guidelines: json['guidelines'] as String? ?? 'No guidelines provided.',
            roomTypeDisplay: json['room_type_display'] as String? ?? 'Unknown',
            category: json['category'] as String? ?? 'General',
            categoryId: json['category_id'] as int? ?? 0,
            createdBy: json['created_by'] as String? ?? 'Unknown',
            memberCount: json['member_count'] as int? ?? 0,
            createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
            members: membersList,
            isCreator: json['is_creator'] as bool?,
            isMember: json['is_member'] as bool?,
            userRole: json['user_role'] as String?,
        );
    }

    Group copyWith({
        List<GroupMember>? members,
        int? memberCount,
    })
    {
        return Group(
            id: id,
            name: name,
            guidelines: guidelines,
            roomTypeDisplay: roomTypeDisplay,
            category: category,
            categoryId: categoryId,
            createdBy: createdBy,
            memberCount: memberCount ?? this.memberCount,
            createdAt: createdAt,
            members: members ?? this.members,
            isCreator: isCreator,
            isMember: isMember,
            userRole: userRole,
        );
    }
}
