
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/common/appbar/common_app_bar.dart';
import 'package:totto/common/common_search_bar.dart';
import 'package:totto/common/constants/colors.dart';
import 'package:totto/data/models/group_member_model.dart';
import 'package:totto/data/models/group_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/chat/essential_tier_page.dart';
import 'package:totto/features/chat/individual_chat_page.dart';
import 'package:totto/features/chat/personal_message_page.dart';
import 'package:totto/features/chat/providers/group_provider.dart';
import 'package:totto/features/chat/websocket/domain/chat_connection_params.dart';
import 'package:totto/features/search/search_page.dart';
import 'package:totto/l10n/app_localizations.dart';

import '../notification/notification_page.dart';

class ChatPage extends ConsumerWidget {
    const ChatPage({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final l10n = AppLocalizations.of(context)!;

        final allGroupsAsync = ref.watch(allGroupsProvider);
        final activeGroups = ref.watch(activeGroupsProvider);
        final currentUser = ref.watch(authStateChangesProvider).value;

        return Scaffold(
          // // appBar: AppBar(
          // //   toolbarHeight: 100.0,
          // //   backgroundColor: MainColors.appbarbackground,
          // //   elevation: 5,
          // //   shadowColor: Colors.black.withOpacity(0.05),
          // //   shape: const RoundedRectangleBorder(
          // //     borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          // //   ),
          // //   leadingWidth: 140,
          // //   leading: Padding(
          // //     padding: const EdgeInsets.only(left: 16.0),
          // //     child: Image.asset('assets/logos/tottologo.png', fit: BoxFit.contain),
          // //   ),
          //   actions: [
          //     IconButton(
          //       icon: Image.asset('assets/logos/notification.png', width: 28, height: 28),
          //       onPressed: ()
          //       {
          //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => NotificationPage()),);
          //       },
          //     ),
          //     const SizedBox(width: 8),
          //   ],
          // ),
          body: SingleChildScrollView(
              child: Column(
                  children: [
                      _buildSearchSection(context, l10n),
                      const SizedBox(height: 24),
          
                      allGroupsAsync.when(
                          loading: () =>
                          const Center(heightFactor: 5, child: CircularProgressIndicator()),
                          error: (err, stack) => Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                  child: Text(l10n.errorCouldNotLoadChatBazaar(err.toString()),
                                      textAlign: TextAlign.center)),
                          ),
                          data: (allGroups) => _buildChatBazaarSection(
                              context, allGroups, currentUser?.username, l10n),
                      ),
                      const SizedBox(height: 24),
                      _buildActiveChatsSection(context, activeGroups, l10n),
                      const SizedBox(height: 24),
                  ],
              ),
          ),
        );
    }

    Widget _buildChatBazaarSection(BuildContext context, List<Group> allGroups,
        String? currentUsername, AppLocalizations l10n) {
        final isEssentialJoined = allGroups.any((g) =>
        g.roomTypeDisplay == 'Free' &&
            (currentUsername != null &&
                g.members.any((m) => m.user.username == currentUsername)));
        final isStandardJoined = allGroups.any((g) =>
        g.category == 'Standard Tier' &&
            (currentUsername != null &&
                g.members.any((m) => m.user.username == currentUsername)));
        final isPremiumJoined = allGroups.any((g) =>
        g.category == 'Premium Tier' &&
            (currentUsername != null &&
                g.members.any((m) => m.user.username == currentUsername)));

        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                        children: [
                            Image.asset('assets/logos/chat_bazaar.png',
                                width: 20,
                                height: 20,
                                errorBuilder: (c, e, s) => const Icon(Icons.store)),
                            const SizedBox(width: 8),
                            Text(l10n.chatBazaar,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                    ),
                    const SizedBox(height: 12),
                    Column(
                        children: [
                            _buildTierTile(context, l10n,
                                name: l10n.essentialTier,
                                iconUrl: 'assets/logos/tier/tier_essential.png',
                                isJoined: isEssentialJoined,
                                keyName: 'Essential Tier'),
                            _buildTierTile(context, l10n,
                                name: l10n.standardTier,
                                iconUrl: 'assets/logos/tier/tier_standard.png',
                                isJoined: isStandardJoined,
                                keyName: 'Standard Tier'),
                            _buildTierTile(context, l10n,
                                name: l10n.premiumTier,
                                iconUrl: 'assets/logos/tier/tier_premium.png',
                                isJoined: isPremiumJoined,
                                keyName: 'Premium Tier'),
                        ],
                    ),
                ],
            ),
        );
    }

    Widget _buildTierTile(BuildContext context, AppLocalizations l10n,
        {required String name,
            required String iconUrl,
            required bool isJoined,
            required String keyName}) {
        return Card(
            margin: const EdgeInsets.only(bottom: 8.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            color: Colors.white,
            child: ListTile(
                leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset(iconUrl,
                        errorBuilder: (c, e, s) => const Icon(Icons.group)),
                ),
                title: Text(name, style: const TextStyle(fontWeight: FontWeight.w400)),
                trailing: isJoined
                    ? OutlinedButton(
                    onPressed: () {
                        if (keyName == 'Essential Tier') {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const EssentialTierPage()));
                        }
                    },
                    style: OutlinedButton.styleFrom(
                        backgroundColor: MainColors.buttonsbackgroundred,
                        foregroundColor: Colors.white,
                        side: BorderSide.none,
                    ),
                    child: Text(l10n.viewButton),
                )
                    : ElevatedButton(
                    onPressed: keyName == 'Essential Tier'
                        ? () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const EssentialTierPage()));
                    }
                        : null,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDC143C),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: Text(l10n.joinButton),
                ),
                onTap: () {
                    if (keyName == 'Essential Tier') {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const EssentialTierPage()));
                    }
                },
            ),
        );
    }

    Widget _buildSearchSection(BuildContext context, AppLocalizations l10n) {
        return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
            child: Row(
                children: [
                    Expanded(
                        child: CommonSearchBar(
                            onTap: () => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => const SearchPage())),
                            readOnly: true,
                        ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                        onPressed: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) => const SearchPage())),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC143C),
                            foregroundColor: Colors.white,
                            padding:
                            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(l10n.searchButton),
                    ),
                ],
            ),
        );
    }


    Widget _buildActiveChatsSection(
        BuildContext context, List<Group> activeGroups, AppLocalizations l10n) {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(l10n.activeChats,
                        style:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    if (activeGroups.isEmpty)
                        Card(
                            color: Colors.white,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Center(child: Text(l10n.noActiveChats)),
                                ),
                            ),
                        ),
                    if (activeGroups.isNotEmpty)
                        Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: activeGroups.length,
                                itemBuilder: (context, index) =>
                                _ActiveChatTile(group: activeGroups[index]),
                                separatorBuilder: (context, index) =>
                                const Divider(height: 1, indent: 72),
                            ),
                        ),
                ],
            ),
        );
    }
}

class _ActiveChatTile extends ConsumerWidget {
    final Group group;
    const _ActiveChatTile({required this.group});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final currentUser = ref.watch(authStateChangesProvider).value;

        if (group.memberCount <= 2) {
            final groupDetailsAsync = ref.watch(groupDetailProvider(group.id));
            return groupDetailsAsync.when(
                loading: () => ListTile(
                    leading: const CircleAvatar(radius: 22, child: Icon(Icons.group)),
                    title: Text(group.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: const Text('Loading...'),
                ),
                error: (err, stack) => const ListTile(
                    leading:  CircleAvatar(radius: 22, child: Icon(Icons.error, color: Colors.red)),
                    title: Text('Error', style:  TextStyle(fontWeight: FontWeight.w500, color: Colors.red)),
                ),
                data: (fullGroup) {
                    final otherMember = fullGroup.members.firstWhere(
                            (member) => member.user.id != currentUser?.id.toString(),
                        orElse: () => GroupMember.empty(),
                    );
                    final displayName = otherMember.user.name.isNotEmpty
                        ? otherMember.user.name
                        : group.name;

                    return _buildTile(context, ref, fullGroup, displayName);
                },
            );
        } else {
            return _buildTile(context, ref, group, group.name);
        }
    }

    Widget _buildTile(BuildContext context, WidgetRef ref, Group groupForNav, String displayName) {
        final currentUser = ref.watch(authStateChangesProvider).value;

        return Material(
          child: ListTile(
              leading: const CircleAvatar(radius: 22, child: Icon(Icons.group)),
              title: Text(displayName, style: const TextStyle(fontWeight: FontWeight.w500)),
              onTap: () {
                  final params = ChatConnectionParams(
                      type: ChatType.group,
                      id: groupForNav.id,
                  );
          
                  if (groupForNav.memberCount <= 2) {
                      final otherMember = groupForNav.members.firstWhere(
                              (member) => member.user.id != currentUser?.id.toString(),
                          orElse: () => GroupMember.empty(),
                      );
          
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => PersonalMessagePage(
                                  group: groupForNav,
                                  otherUser: otherMember.user,
                              ),
                          ),
                      );
                  } else {
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => IndividualChatPage(
                                  group: groupForNav,
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