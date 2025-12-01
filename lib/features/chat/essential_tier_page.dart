// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:totto/common/appbar/common_app_bar.dart';
// import 'package:totto/common/common_search_bar.dart';
// import 'package:totto/data/models/group_model.dart';
// import 'package:totto/features/auth/providers/auth_providers.dart';
// import 'package:totto/features/chat/create_new_group_page.dart';
// import 'package:totto/features/chat/providers/group_provider.dart';
// import 'package:totto/features/search/search_page.dart';
// import 'package:totto/l10n/app_localizations.dart';
//
// class EssentialTierPage extends ConsumerWidget
// {
//     const EssentialTierPage({super.key});
//
//     @override
//     Widget build(BuildContext context, WidgetRef ref)
//     {
//         final l10n = AppLocalizations.of(context)!;
//         final allGroupsAsync = ref.watch(allGroupsProvider);
//         final currentUser = ref.watch(authStateChangesProvider).value;
//
//         return Scaffold(
//             backgroundColor: const Color(0xFFF1F2F6),
//             appBar: CommonAppBar(
//                 height: 60.0,
//                 backgroundColor: const Color(0xFFF1F2F6),
//                 elevation: 0,
//                 leading: IconButton(
//                     icon: const Icon(Icons.arrow_back, color: Colors.black),
//                     onPressed: () => Navigator.of(context).pop(),
//                 ),
//                 title: Text(l10n.chatBazaar, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//                 actions: const[SizedBox(width: 56)],
//             ),
//             body: allGroupsAsync.when(
//                 loading: () => const Center(child: CircularProgressIndicator()),
//                 error: (err, stack) => Center(child: Text(l10n.errorLoadingGroups(err.toString()))),
//                 data: (allGroups)
//                 {
//                     final joinableGroups = allGroups.where((group)
//                         {
//                             if (group.roomTypeDisplay != 'Free') return false;
//                             if (currentUser == null) return true;
//                             return !group.members.any((member) => member.user.username == currentUser.username);
//                         }
//                     ).toList();
//
//                     return ListView(
//                         padding: const EdgeInsets.all(16.0),
//                         children: [
//                             _buildSearchSection(context, l10n),
//                             const SizedBox(height: 24),
//                             if (joinableGroups.isEmpty)
//                             Padding(
//                                 padding: const EdgeInsets.all(32.0),
//                                 child: Center(child: Text(l10n.noNewGroupsToJoin)),
//                             ),
//                             ...joinableGroups.map((group) => _ChatGroupTile(group: group)),
//                             const SizedBox(height: 16),
//                             _buildCreateGroupButton(context, l10n),
//                         ],
//                     );
//                 },
//             ),
//         );
//     }
//
//     Widget _buildSearchSection(BuildContext context, AppLocalizations l10n)
//     {
//         return Row(
//             children: [
//                 const Expanded(child: CommonSearchBar()),
//                 const SizedBox(width: 12),
//                 ElevatedButton(
//                     onPressed: ()
//                     {
//                         Navigator.of(context).push(
//                             MaterialPageRoute(
//                                 builder: (context) => const SearchPage(),
//                             ),
//                         );
//                     },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFDC143C),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                     child: Text(l10n.searchButton),
//                 ),
//             ],
//         );
//     }
//
//     Widget _buildCreateGroupButton(BuildContext context, AppLocalizations l10n)
//     {
//         return OutlinedButton(
//             onPressed: ()
//             {
//                 Navigator.of(context).push(
//                     MaterialPageRoute(builder: (context) => CreateNewGroupPage()),
//                 );
//             },
//             style: OutlinedButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 minimumSize: const Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 side: BorderSide(color: Colors.grey.shade300),
//             ),
//             child: Text(
//                 l10n.createNewChatGroup,
//                 style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//             ),
//         );
//     }
// }
//
// class _ChatGroupTile extends ConsumerWidget
// {
//     const _ChatGroupTile({required this.group});
//     final Group group;
//
//     @override
//     Widget build(BuildContext context, WidgetRef ref)
//     {
//         final l10n = AppLocalizations.of(context)!;
//         final joinState = ref.watch(joinGroupProvider(group.id));
//
//         ref.listen<JoinGroupState>(joinGroupProvider(group.id), (previous, next)
//             {
//                 if (next.error != null)
//                 {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Error: ${next.error}'), backgroundColor: Colors.red),
//                     );
//                 }
//                 if (previous?.isLoading == true && !next.isLoading && next.error == null)
//                 {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text(l10n.successfullyJoinedGroup(group.name)), backgroundColor: Colors.green),
//                     );
//                 }
//             }
//         );
//
//         return Card(
//             margin: const EdgeInsets.only(bottom: 12.0),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//             elevation: 1.5,
//             color: Colors.white,
//             child: ListTile(
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 leading: const CircleAvatar(radius: 22, child: Icon(Icons.group)),
//                 title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.w500)),
//                 trailing: ElevatedButton(
//                     onPressed: joinState.isLoading ? null : ()
//                         {
//                             ref.read(joinGroupProvider(group.id).notifier).joinGroup(groupId: group.id);
//                         },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFDC143C),
//                         foregroundColor: Colors.white,
//                     ),
//                     child: joinState.isLoading
//                         ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//                         : Text(l10n.joinButton),
//                 ),
//             ),
//         );
//     }
// }


// Modified Esential tier Page
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
// class EssentialTierPage extends ConsumerWidget
// {
//   const EssentialTierPage({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref)
//   {
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
//         title: Text(l10n.chatBazaar, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
//         actions: const[SizedBox(width: 56)],
//       ),
//       body: allGroupsAsync.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, stack) => Center(child: Text(l10n.errorLoadingGroups(err.toString()))),
//         data: (allGroups) {
//     final currentUser = ref.watch(authStateChangesProvider).value;
//
//     /// Joinable groups (FREE only)
//     final joinableGroups = allGroups.where((group) {
//     if (group.roomTypeDisplay != 'Free') return false;
//     if (currentUser == null) return true;
//     return !group.members.any(
//     (member) => member.user.username == currentUser.username);
//     }).toList();
//
//     /// NEW: All groups (Free + Standard + Premium)
//     final allGroupsList = allGroups;
//
//     return ListView(
//     padding: const EdgeInsets.all(16.0),
//     children: [
//     _buildSearchSection(context, l10n),
//     const SizedBox(height: 24),
//
//     // JOINABLE ESSENTIAL GROUPS (TOP)
//     if (joinableGroups.isNotEmpty)
//     ...joinableGroups.map((group) => _ChatGroupTile(group: group)),
//
//     const SizedBox(height: 32),
//
//     // NEW SECTION: ALL GROUPS
//     Text(
//     l10n.chatBazaar, // Or "All Groups"
//     style: const TextStyle(
//     fontSize: 18, fontWeight: FontWeight.bold),
//     ),
//     const SizedBox(height: 12),
//
//     ...allGroupsList.map(
//     (group) => _AllGroupTile(group: group),
//     ),
//
//     const SizedBox(height: 16),
//     _buildCreateGroupButton(context, l10n),
//     ],
//     );
//     }
//       ,
//       ),
//     );
//   }
//
//   Widget _buildSearchSection(BuildContext context, AppLocalizations l10n)
//   {
//     return Row(
//       children: [
//         const Expanded(child: CommonSearchBar()),
//         const SizedBox(width: 12),
//         ElevatedButton(
//           onPressed: ()
//           {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => const SearchPage(),
//               ),
//             );
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFFDC143C),
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
//             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//           child: Text(l10n.searchButton),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildCreateGroupButton(BuildContext context, AppLocalizations l10n)
//   {
//     return OutlinedButton(
//       onPressed: ()
//       {
//         Navigator.of(context).push(
//           MaterialPageRoute(builder: (context) => CreateNewGroupPage()),
//         );
//       },
//       style: OutlinedButton.styleFrom(
//         backgroundColor: Colors.white,
//         minimumSize: const Size(double.infinity, 50),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         side: BorderSide(color: Colors.grey.shade300),
//       ),
//       child: Text(
//         l10n.createNewChatGroup,
//         style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//       ),
//     );
//   }
// }
//
// class _ChatGroupTile extends ConsumerWidget
// {
//   const _ChatGroupTile({required this.group});
//   final Group group;
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref)
//   {
//     final l10n = AppLocalizations.of(context)!;
//     final joinState = ref.watch(joinGroupProvider(group.id));
//
//     ref.listen<JoinGroupState>(joinGroupProvider(group.id), (previous, next)
//     {
//       if (next.error != null)
//       {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: ${next.error}'), backgroundColor: Colors.red),
//         );
//       }
//       if (previous?.isLoading == true && !next.isLoading && next.error == null)
//       {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(l10n.successfullyJoinedGroup(group.name)), backgroundColor: Colors.green),
//         );
//       }
//     }
//     );
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 1.5,
//       color: Colors.white,
//       child: ListTile(
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         leading: const CircleAvatar(radius: 22, child: Icon(Icons.group)),
//         title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.w500)),
//         trailing: ElevatedButton(
//           onPressed: joinState.isLoading ? null : ()
//           {
//             ref.read(joinGroupProvider(group.id).notifier).joinGroup(groupId: group.id);
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFFDC143C),
//             foregroundColor: Colors.white,
//           ),
//           child: joinState.isLoading
//               ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
//               : Text(l10n.joinButton),
//         ),
//       ),
//     );
//   }
// }
//
// class _AllGroupTile extends ConsumerWidget {
//   final Group group;
//
//   const _AllGroupTile({required this.group});
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
//         title: Text(group.name,
//             style: const TextStyle(fontWeight: FontWeight.w500)),
//
//         onTap: () {
//           // Same navigation logic as ChatPage
//           final params = ChatConnectionParams(
//             type: ChatType.group,
//             id: group.id,
//           );
//
//           if (group.memberCount <= 2) {
//             final otherMember = group.members.firstWhere(
//                   (m) => m.user.id != currentUser?.id.toString(),
//               orElse: () => GroupMember.empty(),
//             );
//
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => PersonalMessagePage(
//                   group: group,
//                   otherUser: otherMember.user,
//                 ),
//               ),
//             );
//           } else {
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (context) => IndividualChatPage(
//                   group: group,
//                   params: params,
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// Updated Latest Code
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/common/appbar/common_app_bar.dart';
import 'package:totto/common/common_search_bar.dart';
import 'package:totto/data/models/group_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/chat/create_new_group_page.dart';
import 'package:totto/features/chat/personal_message_page.dart';
import 'package:totto/features/chat/providers/group_provider.dart';
import 'package:totto/features/chat/websocket/domain/chat_connection_params.dart';
import 'package:totto/features/search/search_page.dart';
import 'package:totto/l10n/app_localizations.dart';

import '../../data/models/group_member_model.dart';
import 'individual_chat_page.dart';

class EssentialTierPage extends ConsumerWidget {
  const EssentialTierPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final allGroupsAsync = ref.watch(allGroupsProvider);
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
        title: Text(l10n.chatBazaar, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: const [SizedBox(width: 56)],
      ),
      body: allGroupsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(l10n.errorLoadingGroups(err.toString()))),
        data: (allGroups) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Section
                  _buildSearchSection(context, l10n),
                  const SizedBox(height: 16),

                  // Create Group Button
                  _buildCreateGroupButton(context, l10n),
                  const SizedBox(height: 14),



                  // Groups List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: allGroups.length,
                    itemBuilder: (context, index) {
                      final group = allGroups[index];
                      return _GroupTile(group: group);
                    },
                  ),


                ],
              ),
            ),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(l10n.searchButton),
        ),
      ],
    );
  }

  Widget _buildCreateGroupButton(BuildContext context, AppLocalizations l10n) {
    return OutlinedButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CreateNewGroupPage()),
        );
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Text(
        l10n.createNewChatGroup,
        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _GroupTile extends ConsumerWidget {
  final Group group;
  const _GroupTile({required this.group});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(authStateChangesProvider).value;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      color: Colors.white,
      child: ListTile(
        leading: const CircleAvatar(radius: 22, child: Icon(Icons.group)),
        title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.w500)),
        onTap: () async {
          // Auto-join group
          if (currentUser != null) {
            await ref.read(joinGroupProvider(group.id).notifier).joinGroup(groupId: group.id);
          }

          // Navigate
          final params = ChatConnectionParams(type: ChatType.group, id: group.id);

          if (group.memberCount <= 2) {
            final otherMember = group.members.firstWhere(
                  (m) => m.user.id != currentUser?.id.toString(),
              orElse: () => GroupMember.empty(),
            );

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PersonalMessagePage(
                  group: group,
                  otherUser: otherMember.user,
                ),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => IndividualChatPage(
                  group: group,
                  params: params,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}