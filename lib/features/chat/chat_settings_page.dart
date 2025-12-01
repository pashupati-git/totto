import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/common/appbar/common_app_bar.dart';
import 'package:totto/data/models/group_member_model.dart';
import 'package:totto/data/models/group_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/chat/providers/group_member_provider.dart';
import 'package:totto/l10n/app_localizations.dart';

import 'add_group_member_page.dart';

class ChatSettingsPage extends ConsumerWidget
{
    const ChatSettingsPage({
        super.key,
        required this.group,
    });

    final Group group;

    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        final l10n = AppLocalizations.of(context)!;
        final groupSettingsState = ref.watch(groupSettingsActionProvider(group.id));

        ref.listen<AsyncValue<void>>(groupSettingsActionProvider(group.id), (previous, next)
            {
                if (next.hasError && !next.isLoading)
                {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${next.error}'), backgroundColor: Colors.red),
                    );
                }
            }
        );

        return Scaffold(
            backgroundColor: const Color(0xFFF1F2F6),
            appBar: CommonAppBar(
                height: 60.0,
                backgroundColor: const Color(0xFFF1F2F6),
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(l10n.chatSettingsTitle, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                actions: const[SizedBox(width: 56)],
            ),
            body: Stack(
                children: [
                    SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: Column(
                            children: [
                                _buildChatHeader(l10n),
                                const SizedBox(height: 32),
                                _buildSettingsList(context, ref, l10n),
                            ],
                        ),
                    ),
                    if (groupSettingsState.isLoading)
                    Container(
                        color: Colors.black.withOpacity(0.2),
                        child: const Center(child: CircularProgressIndicator()),
                    ),
                ],
            ),
        );
    }

    Widget _buildChatHeader(AppLocalizations l10n)
    {
        return Column(
            children: [
                SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                        children: [
                            Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.grey.shade300, width: 2),
                                ),
                            ),
                            const Center(
                                child: CircleAvatar(
                                    radius: 55,
                                    backgroundColor: Colors.grey,
                                    child: Icon(Icons.group, size: 50, color: Colors.white),
                                ),
                            ),
                            Positioned(
                                bottom: 8,
                                right: 8,
                                child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                    ),
                                    child: const Icon(Icons.groups, color: Colors.black54, size: 16),
                                ),
                            ),
                        ],
                    ),
                ),
                const SizedBox(height: 16),
                Text(group.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(l10n.participants(group.members.length.toString()), style: const TextStyle(fontSize: 14, color: Colors.grey)),
            ],
        );
    }

    Widget _buildSettingsList(BuildContext context, WidgetRef ref, AppLocalizations l10n)
    {
        final currentUser = ref.watch(authStateChangesProvider).value;
        final bool isGroupOwner = group.createdBy == currentUser?.username;

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(l10n.chatSettingsTitle, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                        children: [
                            _buildMenuItem(
                                icon: Icons.group_outlined,
                                title: l10n.groupMembers,
                                onTap: () => showDialog(context: context, builder: (context) => _GroupMembersDialog(group: group)),
                            ),
                            if (isGroupOwner)
                            _buildMenuItem(
                                icon: Icons.edit_outlined,
                                title: l10n.editName,
                                onTap: () => _showEditNameDialog(context, ref, group, l10n),
                            ),
                            _buildMenuItem(icon: Icons.info_outline, title: l10n.contactInfo, onTap: ()
                                {
                                }
                            ),
                            _buildMenuItem(icon: Icons.notifications_off_outlined, title: l10n.muteNotifications, onTap: ()
                                {
                                }
                            ),
                            if (!isGroupOwner)
                            _buildMenuItem(
                                icon: Icons.exit_to_app,
                                title: l10n.leaveGroup,
                                color: Colors.red,
                                onTap: () => _showLeaveGroupDialog(context, ref, group, l10n),
                            ),
                            if (isGroupOwner)
                            _buildMenuItem(
                                icon: Icons.delete_outline,
                                title: l10n.deleteGroup,
                                color: Colors.red,
                                onTap: () => _showDeleteGroupDialog(context, ref, group, l10n),
                            ),
                        ],
                    ),
                ),
            ],
        );
    }

    Widget _buildMenuItem({
        required IconData icon,
        required String title,
        required VoidCallback onTap,
        Color color = Colors.black,
    })
    {
        return ListTile(
            onTap: onTap,
            leading: Icon(icon, color: color),
            title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
        );
    }

    void _showEditNameDialog(BuildContext context, WidgetRef ref, Group group, AppLocalizations l10n)
    {
        final nameController = TextEditingController(text: group.name);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text(l10n.editGroupNameTitle),
                content: TextField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: l10n.newGroupNameHint),
                    autofocus: true,
                ),
                actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
                    TextButton(
                        onPressed: () async
                        {
                            final newName = nameController.text.trim();
                            if (newName.isNotEmpty)
                            {
                                try
                                {
                                    await ref.read(groupSettingsActionProvider(group.id).notifier).updateGroupName(newName);
                                    Navigator.of(context).pop();
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.groupNameUpdatedSuccess)));
                                }
                                catch (e)
                                {
                                }
                            }
                        },
                        child: Text(l10n.save),
                    ),
                ],
            ),
        );
    }

    void _showLeaveGroupDialog(BuildContext context, WidgetRef ref, Group group, AppLocalizations l10n)
    {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text(l10n.leaveGroupDialogTitle),
                content: Text(l10n.leaveGroupDialogContent),
                actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
                    TextButton(
                        onPressed: () async
                        {
                            final List<GroupMember> members = group.members;
                            final currentUser = ref.read(authStateChangesProvider).value;
                            if (currentUser == null)
                            {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.couldNotGetUser)));
                                return;
                            }
                            int? currentUserMemberId;
                            for (final member in members)
                            {
                                // MODIFIED: Check against `member.user.username`
                                if (member.user.username == currentUser.username)
                                {
                                    currentUserMemberId = member.id;
                                    break;
                                }
                            }
                            if (currentUserMemberId != null)
                            {
                                try
                                {
                                    await ref.read(groupSettingsActionProvider(group.id).notifier).leaveGroup(currentUserMemberId);
                                    Navigator.of(context)..pop()..pop();
                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.leaveGroupSuccess)));
                                }
                                catch (e)
                                {
                                }
                            }
                            else
                            {
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.leaveGroupError)));
                            }
                        },
                        child: Text(l10n.leaveGroup, style: const TextStyle(color: Colors.red)),
                    ),
                ],
            ),
        );
    }

    void _showDeleteGroupDialog(BuildContext context, WidgetRef ref, Group group, AppLocalizations l10n)
    {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: Text(l10n.deleteGroupDialogTitle),
                content: Text(l10n.deleteGroupDialogContent),
                actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
                    TextButton(
                        onPressed: () async
                        {
                            try
                            {
                                await ref.read(groupSettingsActionProvider(group.id).notifier).deleteGroup();
                                Navigator.of(context)..pop()..pop();
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.groupDeletedSuccess)));
                            }
                            catch (e)
                            {
                            }
                        },
                        child: Text(l10n.deleteGroup, style: const TextStyle(color: Colors.red)),
                    ),
                ],
            ),
        );
    }
}

class _GroupMembersDialog extends ConsumerWidget
{
    final Group group;
    const _GroupMembersDialog({required this.group});

    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        final l10n = AppLocalizations.of(context)!;
        final List<GroupMember> members = group.members;
        final currentUser = ref.watch(authStateChangesProvider).value;
        final actionState = ref.watch(groupMemberActionProvider(group.id));

        ref.listen<AsyncValue<void>>(groupMemberActionProvider(group.id), (previous, next)
            {
                if (next.hasError && !next.isLoading)
                {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${next.error}'), backgroundColor: Colors.red),
                    );
                }
            }
        );

        return AlertDialog(
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text(l10n.groupMembers),
                    IconButton(
                        icon: const Icon(Icons.person_add_alt_1_outlined),
                        tooltip: l10n.addMembers,
                        onPressed: ()
                        {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => AddGroupMembersPage(group: group),
                                ),
                            );
                        },
                    )
                ],
            ),
            backgroundColor: const Color(0xFFF1F2F6),
            content: SizedBox(
                width: double.maxFinite,
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        if (actionState.isLoading) const LinearProgressIndicator(),
                        Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: members.length,
                                itemBuilder: (context, index)
                                {
                                    final member = members[index];
                                    final bool isGroupOwner = group.createdBy == currentUser?.username;
                                    // MODIFIED: Check against `member.user.username`
                                    final bool isCurrentUser = member.user.username == currentUser?.username;
                                    return _MemberTile(
                                        member: member,
                                        isCurrentUser: isCurrentUser,
                                        showActions: isGroupOwner && !isCurrentUser,
                                        onUpdateRole: (newRole)
                                        {
                                            ref.read(groupMemberActionProvider(group.id).notifier).updateRole(memberId: member.id, newRole: newRole);
                                        },
                                        onRemove: ()
                                        {
                                            ref.read(groupMemberActionProvider(group.id).notifier).removeMember(member.id);
                                        },
                                    );
                                },
                            ),
                        ),
                    ],
                ),
            ),
            actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.close),
                ),
            ],
        );
    }
}

class _MemberTile extends ConsumerWidget
{
    final GroupMember member;
    final bool isCurrentUser;
    final bool showActions;
    final Function(String) onUpdateRole;
    final VoidCallback onRemove;

    const _MemberTile({
        required this.member,
        required this.isCurrentUser,
        required this.showActions,
        required this.onUpdateRole,
        required this.onRemove,
    });

    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        final l10n = AppLocalizations.of(context)!;
        final bool isAdmin = member.role == 'A';
        Widget avatarWidget;
        String displayName;

        if (isCurrentUser)
        {
            final currentUser = ref.watch(authStateChangesProvider).value;
            final imageUrl = currentUser?.profileImageUrl;
            displayName = currentUser?.name.isNotEmpty == true ? currentUser!.name : member.user.username;
            avatarWidget = CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                backgroundImage: (imageUrl != null && imageUrl.isNotEmpty) ? NetworkImage(imageUrl) : null,
                child: (imageUrl == null || imageUrl.isEmpty) ? const Icon(Icons.person, color: Colors.white) : null,
            );
        }
        else
        {
            final imageUrl = member.user.profileImageUrl;
            displayName = member.user.name.isNotEmpty ? member.user.name : member.user.username;
            avatarWidget = CircleAvatar(
                backgroundColor: Colors.grey.shade300,
                backgroundImage: (imageUrl.isNotEmpty) ? NetworkImage(imageUrl) : null,
                child: (imageUrl.isEmpty) ? const Icon(Icons.person, color: Colors.white) : null,
            );
        }

        return Card(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            child: ListTile(
                leading: avatarWidget,
                title: Text(displayName, style: const TextStyle(fontWeight: FontWeight.w500)),
                subtitle: Text(isAdmin ? l10n.admin : l10n.member),
                trailing: showActions ? PopupMenuButton<String>(
                        onSelected: (value)
                        {
                            if (value == 'role')
                            {
                                onUpdateRole(isAdmin ? 'M' : 'A');
                            }
                            else if (value == 'remove')
                            {
                                onRemove();
                            }
                        },
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                            PopupMenuItem<String>(
                                value: 'role',
                                child: Text(isAdmin ? l10n.makeMember : l10n.makeAdmin),
                            ),
                            const PopupMenuDivider(),
                            PopupMenuItem<String>(
                                value: 'remove',
                                child: Text(l10n.removeMember, style: const TextStyle(color: Colors.red)),
                            ),
                        ],
                    ) : null,
            ),
        );
    }
}
