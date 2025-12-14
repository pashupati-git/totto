import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/common/appbar/common_app_bar.dart';
import 'package:totto/data/models/group_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/chat/individual_chat_page.dart';
import 'package:totto/features/chat/providers/group_provider.dart';
import 'package:totto/features/chat/websocket/domain/chat_connection_params.dart';
import 'package:totto/l10n/app_localizations.dart';

class GroupHistoryPage extends ConsumerWidget {
  const GroupHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final allGroupsAsync = ref.watch(allGroupsProvider);
    final myGroupsAsync = ref.watch(myGroupsProvider);
    final currentUser = ref.watch(authStateChangesProvider).value;

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
        title: const Text(
          'Group History',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [SizedBox(width: 56)],
      ),
      body: allGroupsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error loading groups: ${err.toString()}'),
        ),
        data: (allGroups) {
          return myGroupsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Text('Error loading my groups: ${err.toString()}'),
            ),
            data: (myGroups) {
              // Get current user ID as string
              final currentUserId = currentUser?.id?.toString() ?? '';

              // Filter groups into three categories
              final myCreatedGroups = <Group>[];
              final myJoinedGroups = <Group>[];

              for (var group in myGroups) {
                // Debug print to see what we're comparing
                print('Group: ${group.name}');
                print('  isCreator: ${group.isCreator}');
                print('  userRole: ${group.userRole}');
                print('  createdBy: ${group.createdBy}');
                print('  currentUserId: $currentUserId');

                // Check if user is creator using multiple conditions
                final isGroupCreator =
                    group.isCreator == true ||
                        group.userRole?.toLowerCase() == 'creator' ||
                        group.userRole?.toUpperCase() == 'C' ||
                        (currentUserId.isNotEmpty && group.createdBy == currentUserId);

                print('  -> isGroupCreator: $isGroupCreator\n');

                if (isGroupCreator) {
                  myCreatedGroups.add(group);
                } else {
                  myJoinedGroups.add(group);
                }
              }

              final availableGroups = allGroups.where((group) {
                return !myGroups.any((myGroup) => myGroup.id == group.id);
              }).toList();

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section 2: Groups I've Joined
                      _buildSectionHeader(
                        context,
                        'Joined Groups',
                        myJoinedGroups.length,
                      ),
                      const SizedBox(height: 12),
                      if (myJoinedGroups.isEmpty)
                        _buildEmptyState('You haven\'t joined any groups yet')
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: myJoinedGroups.length,
                          itemBuilder: (context, index) {
                            final group = myJoinedGroups[index];
                            return _GroupTile(
                              group: group,
                              actionType: GroupTileAction.view,
                            );
                          },
                        ),
                      const SizedBox(height: 24),

                      // Section 3: Available Groups
                      _buildSectionHeader(
                        context,
                        'Available Groups',
                        availableGroups.length,
                      ),
                      const SizedBox(height: 12),
                      if (availableGroups.isEmpty)
                        _buildEmptyState('No available groups to join')
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: availableGroups.length,
                          itemBuilder: (context, index) {
                            final group = availableGroups[index];
                            return _GroupTile(
                              group: group,
                              actionType: GroupTileAction.join,
                            );
                          },
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, int count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        '$title ($count)',
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.groups_outlined, size: 48, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

enum GroupTileAction { view, join }

class _GroupTile extends ConsumerStatefulWidget {
  final Group group;
  final GroupTileAction actionType;

  const _GroupTile({
    required this.group,
    required this.actionType,
  });

  @override
  ConsumerState<_GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends ConsumerState<_GroupTile> {
  bool _isJoining = false;

  Color _getGroupColor(String name) {
    final colors = [
      const Color(0xFF5B8DEE),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
    ];
    return colors[name.hashCode % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authStateChangesProvider).value;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Group Icon
          CircleAvatar(
            radius: 20,
            backgroundColor: _getGroupColor(widget.group.name),
            child: const Icon(
              Icons.groups,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Group Name
          Expanded(
            child: Text(
              widget.group.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),

          // View or Join Button
          widget.actionType == GroupTileAction.view
              ? _buildViewButton(context, currentUser)
              : _buildJoinButton(context, currentUser),
        ],
      ),
    );
  }

  Widget _buildViewButton(BuildContext context, dynamic currentUser) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        onTap: () async {
          final params = ChatConnectionParams(
            type: ChatType.group,
            id: widget.group.id,
          );

          if (!context.mounted) return;

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => IndividualChatPage(
                group: widget.group,
                params: params,
              ),
            ),
          );
        },
        child: const Text(
          'View',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildJoinButton(BuildContext context, dynamic currentUser) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        onTap: _isJoining
            ? null
            : () async {
          if (currentUser == null) return;

          setState(() => _isJoining = true);

          try {
            await ref
                .read(joinGroupProvider(widget.group.id).notifier)
                .joinGroup(groupId: widget.group.id);

            if (!context.mounted) return;

            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Successfully joined ${widget.group.name}'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );

            // Navigate to the group
            final params = ChatConnectionParams(
              type: ChatType.group,
              id: widget.group.id,
            );

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => IndividualChatPage(
                  group: widget.group,
                  params: params,
                ),
              ),
            );
          } catch (e) {
            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to join group: ${e.toString()}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 2),
              ),
            );
          } finally {
            if (mounted) {
              setState(() => _isJoining = false);
            }
          }
        },
        child: _isJoining
            ? const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black54),
          ),
        )
            : const Text(
          'Join',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}