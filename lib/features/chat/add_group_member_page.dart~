
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/data/models/group_model.dart';
import 'package:totto/data/models/user_profile_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/chat/providers/group_member_provider.dart';

class AddGroupMembersPage extends ConsumerWidget
{
    final Group group;
    const AddGroupMembersPage({super.key, required this.group});

    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        final allUsersAsync = ref.watch(allUsersProvider);
        final currentMembersAsync = ref.watch(groupMembersProvider(group.id));
        final currentUser = ref.watch(authStateChangesProvider).value;

        return Scaffold(
            appBar: AppBar(
                title: Text('Add Members to ${group.name}'),
            ),
            body: currentMembersAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(child: Text('Error loading members: $err')),
                data: (currentMembers)
                {
                    return allUsersAsync.when(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, stack) => Center(child: Text('Error loading users: $err')),
                        data: (allUsers)
                        {
                            final memberUsernames = currentMembers.map((m) => m.user).toSet();

                            final usersToAdd = allUsers
                                .where((user) => !memberUsernames.contains(user.username) && user.username != currentUser?.username)
                                .toList();

                            if (usersToAdd.isEmpty)
                            {
                                return const Center(child: Text('All other users are already in this group.'));
                            }

                            return ListView.builder(
                                itemCount: usersToAdd.length,
                                itemBuilder: (context, index)
                                {
                                    return _UserTile(user: usersToAdd[index], group: group);
                                },
                            );
                        },
                    );
                },
            ),
        );
    }
}

class _UserTile extends ConsumerWidget
{
    final UserProfile user;
    final Group group;
    const _UserTile({required this.user, required this.group});

    @override
    Widget build(BuildContext context, WidgetRef ref)
    {

        final addMemberState = ref.watch(addMemberProvider(user.username));

        ref.listen<AsyncValue<void>>(addMemberProvider(user.username), (previous, next)
            {
                if (next.hasError && !next.isLoading)
                {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${next.error}"), backgroundColor: Colors.red));
                }
                if (next.hasValue && !next.isLoading)
                {
                    if (previous is AsyncLoading)
                    {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${user.name} added successfully!"), backgroundColor: Colors.green));
                        Navigator.of(context).pop();
                    }
                }
            }
        );

        return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: ListTile(
                leading: CircleAvatar(
                    backgroundImage: user.profileImageUrl.isNotEmpty ? NetworkImage(user.profileImageUrl) : null,
                    child: user.profileImageUrl.isEmpty ? const Icon(Icons.person) : null,
                ),
                title: Text(user.name.isNotEmpty ? user.name : user.username),
                subtitle: Text(user.tier),
                trailing: ElevatedButton(
                    onPressed: addMemberState.isLoading ? null : ()
                        {
                            ref.read(addMemberProvider(user.username).notifier)
                                .addMember(groupId: group.id, userId: user.username);
                        },
                    child: addMemberState.isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Add'),
                ),
            ),
        );
    }
}
