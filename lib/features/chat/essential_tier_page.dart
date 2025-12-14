//
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:totto/common/appbar/common_app_bar.dart';
// import 'package:totto/common/common_search_bar.dart';
// import 'package:totto/data/models/group_model.dart';
// import 'package:totto/features/auth/providers/auth_providers.dart';
// import 'package:totto/features/chat/create_new_group_page.dart';
// import 'package:totto/features/chat/personal_message_page.dart';
// import 'package:totto/features/chat/providers/group_provider.dart';
// import 'package:totto/features/chat/websocket/domain/chat_connection_params.dart';
// import 'package:totto/features/search/search_page.dart';
// import 'package:totto/l10n/app_localizations.dart';
//
// import '../../data/models/group_member_model.dart';
// import 'individual_chat_page.dart';
//
// class EssentialTierPage extends ConsumerWidget {
//   const EssentialTierPage({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final l10n = AppLocalizations.of(context)!;
//     final allGroupsAsync = ref.watch(allGroupsProvider);
//     final currentUser = ref.watch(authStateChangesProvider).value;
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF1F2F6),
//       appBar: CommonAppBar(
//         height: 60.0,
//         backgroundColor: const Color(0xFFF1F2F6),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text(
//           l10n.chatBazaar,
//           style: const TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: const [SizedBox(width: 56)],
//       ),
//       body: allGroupsAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, stack) =>
//             Center(child: Text(l10n.errorLoadingGroups(err.toString()))),
//         data: (allGroups) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Search Section
//                   _buildSearchSection(context, l10n),
//                   const SizedBox(height: 16),
//
//                   // Create Group Button
//                   _buildCreateGroupButton(context, l10n),
//                   const SizedBox(height: 14),
//
//                   // Groups List
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: allGroups.length,
//                     itemBuilder: (context, index) {
//                       final group = allGroups[index];
//                       return _GroupTile(group: group);
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildSearchSection(BuildContext context, AppLocalizations l10n) {
//     return Row(
//       children: [
//         const Expanded(child: CommonSearchBar()),
//         const SizedBox(width: 12),
//         ElevatedButton(
//           onPressed: () {
//             Navigator.of(
//               context,
//             ).push(MaterialPageRoute(builder: (context) => const SearchPage()));
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFFDC143C),
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//           ),
//           child: Text(l10n.searchButton),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCreateGroupButton(BuildContext context, AppLocalizations l10n) {
//     return OutlinedButton(
//       onPressed: () {
//         Navigator.of(
//           context,
//         ).push(MaterialPageRoute(builder: (context) => CreateNewGroupPage()));
//       },
//       style: OutlinedButton.styleFrom(
//         backgroundColor: Colors.white,
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         side: BorderSide(color: Colors.grey.shade300),
//       ),
//       child: Text(
//         l10n.createNewChatGroup,
//         style: const TextStyle(
//           color: Colors.black,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }
// }
//
// // condition for if grop member is less than or equal to 2, navigation was for individual.
// // class _GroupTile extends ConsumerWidget {
// //   final Group group;
// //   const _GroupTile({required this.group});
// //
// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final currentUser = ref.watch(authStateChangesProvider).value;
// //
// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 12.0),
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
// //       elevation: 1,
// //       color: Colors.white,
// //       child: ListTile(
// //         leading: const CircleAvatar(radius: 22, child: Icon(Icons.group)),
// //         title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.w500)),
// //         onTap: () async {
// //           // Auto-join group
// //           if (currentUser != null) {
// //             await ref.read(joinGroupProvider(group.id).notifier).joinGroup(groupId: group.id);
// //           }
// //
// //           // Navigate
// //           final params = ChatConnectionParams(type: ChatType.group, id: group.id);
// //
// //           if (group.memberCount <= 2) {
// //             final otherMember = group.members.firstWhere(
// //                   (m) => m.user.id != currentUser?.id.toString(),
// //               orElse: () => GroupMember.empty(),
// //             );
// //
// //             Navigator.of(context).push(
// //               MaterialPageRoute(
// //                 builder: (context) => PersonalMessagePage(
// //                   group: group,
// //                   otherUser: otherMember.user,
// //                 ),
// //               ),
// //             );
// //           } else {
// //             Navigator.of(context).push(
// //               MaterialPageRoute(
// //                 builder: (context) => IndividualChatPage(
// //                   group: group,
// //                   params: params,
// //                 ),
// //               ),
// //             );
// //           }
// //         },
// //       ),
// //     );
// //   }
// // }
//
// class _GroupTile extends ConsumerWidget {
//   final Group group;
//   const _GroupTile({required this.group});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentUser = ref.watch(authStateChangesProvider).value;
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 1,
//       color: Colors.white,
//       child: ListTile(
//         leading: const CircleAvatar(radius: 22, child: Icon(Icons.group)),
//         title: Text(
//           group.name,
//           style: const TextStyle(fontWeight: FontWeight.w500),
//         ),
//         onTap: () async {
//           // 1. Auto-join group logic
//           if (currentUser != null) {
//             await ref
//                 .read(joinGroupProvider(group.id).notifier)
//                 .joinGroup(groupId: group.id);
//           }
//
//           // Check if context is valid after the async operation
//           if (!context.mounted) return;
//
//           // 2. Prepare params
//           final params = ChatConnectionParams(
//             type: ChatType.group,
//             id: group.id,
//           );
//
//           // 3. Navigate directly to IndividualChatPage (Group View)
//           // The conditional check for memberCount <= 2 has been removed.
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) =>
//                   IndividualChatPage(group: group, params: params),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/common/appbar/common_app_bar.dart';
import 'package:totto/common/common_search_bar.dart';
import 'package:totto/data/models/group_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/chat/create_new_group_page.dart';
import 'package:totto/features/chat/providers/group_provider.dart';
import 'package:totto/features/chat/websocket/domain/chat_connection_params.dart';
import 'package:totto/features/search/search_page.dart';
import 'package:totto/l10n/app_localizations.dart';
import 'individual_chat_page.dart';

class EssentialTierPage extends ConsumerWidget {
  const EssentialTierPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final allGroupsAsync = ref.watch(allGroupsProvider);
    final myGroupsAsync = ref.watch(myGroupsProvider);

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
        title: Text(
          l10n.chatBazaar,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [SizedBox(width: 56)],
      ),
      body: allGroupsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) =>
            Center(child: Text(l10n.errorLoadingGroups(err.toString()))),
        data: (allGroups) {
          return myGroupsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) =>
                Center(child: Text('Error loading groups: ${err.toString()}')),
            data: (myGroups) {
              // Get list of group IDs that user is already a member of
              final myGroupIds = myGroups.map((g) => g.id).toSet();

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Section
                      _buildSearchSection(context, l10n),
                      const SizedBox(height: 24),

                      // // Chat Bazaar Header
                      // Center(
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Container(
                      //         padding: const EdgeInsets.all(8),
                      //         decoration: BoxDecoration(
                      //           color: const Color(0xFFDC143C),
                      //           borderRadius: BorderRadius.circular(8),
                      //         ),
                      //         child: const Icon(
                      //           Icons.chat,
                      //           color: Colors.white,
                      //           size: 20,
                      //         ),
                      //       ),
                      //       const SizedBox(width: 8),
                      //       const Text(
                      //         'Chat Bazaar',
                      //         style: TextStyle(
                      //           fontSize: 18,
                      //           fontWeight: FontWeight.w600,
                      //           color: Colors.black87,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Create Group Button
                      _buildCreateGroupButton(context, l10n),

                      const SizedBox(height: 20),

                      // Groups List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: allGroups.length,
                        itemBuilder: (context, index) {
                          final group = allGroups[index];
                          final isMember = myGroupIds.contains(group.id);

                          return _GroupTile(
                            group: group,
                            isMember: isMember,
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

  Widget _buildSearchSection(BuildContext context, AppLocalizations l10n) {
    return Row(
      children: [
        const Expanded(child: CommonSearchBar()),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SearchPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFDC143C),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(l10n.searchButton),
        ),
      ],
    );
  }

  Widget _buildCreateGroupButton(BuildContext context, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const CreateNewGroupPage()),
          );
        },
        child: Text(
          l10n.createNewChatGroup,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _GroupTile extends ConsumerStatefulWidget {
  final Group group;
  final bool isMember;

  const _GroupTile({
    required this.group,
    required this.isMember,
  });

  @override
  ConsumerState<_GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends ConsumerState<_GroupTile> {
  bool _isJoining = false;

  @override
  Widget build(BuildContext context) {
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
          widget.isMember
              ? _buildViewButton(context)
              : _buildJoinButton(context),
        ],
      ),
    );
  }

  Color _getGroupColor(String name) {
    // Generate color based on group name for variety
    final colors = [
      const Color(0xFF5B8DEE),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
      const Color(0xFFF59E0B),
    ];
    return colors[name.hashCode % colors.length];
  }

  Widget _buildViewButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: InkWell(
        onTap: () {
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

  Widget _buildJoinButton(BuildContext context) {
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
          setState(() => _isJoining = true);

          try {
            await ref
                .read(joinGroupProvider(widget.group.id).notifier)
                .joinGroup(groupId: widget.group.id);

            if (!context.mounted) return;

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Successfully joined ${widget.group.name}'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );

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