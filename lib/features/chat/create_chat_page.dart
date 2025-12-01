// lib/features/chat/presentation/create_chat_page.dart (CORRECTED)

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/data/models/group_model.dart';
import 'package:totto/data/models/order_model.dart';
import 'package:totto/data/models/user_profile_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/chat/personal_message_page.dart';
import 'package:totto/features/chat/providers/group_provider.dart';

class CreateChatPage extends ConsumerStatefulWidget {
  final UserProfile otherUser;
  final Order? initialOrder;

  const CreateChatPage({
    super.key,
    required this.otherUser,
    this.initialOrder,
  });

  @override
  ConsumerState<CreateChatPage> createState() => _CreateChatPageState();
}

class _CreateChatPageState extends ConsumerState<CreateChatPage> {
  @override
  void initState() {
    super.initState();
    // Start the find-or-create process as soon as the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _findOrCreateChat();
    });
  }

  // This is the core "Find or Create" logic
  Future<void> _findOrCreateChat() async {
    final currentUser = ref.read(authStateChangesProvider).value;
    if (currentUser == null) return; // Should not happen if user is logged in

    // 1. Fetch all groups the current user is a member of.
    final myGroups = await ref.read(myGroupsProvider.future);

    Group? existingChat;
    try {
      // 2. Search for a group that has exactly 2 members AND contains the other user.
      existingChat = myGroups.firstWhere(
            (group) =>
        group.memberCount == 2 &&
            group.members.any((member) => member.user.id == widget.otherUser.id),
      );
    } catch (e) {
      // firstWhere throws an error if no group is found, which is normal.
      existingChat = null;
    }

    if (existingChat != null) {
      // 3. FIND SUCCESS: If we found an existing chat, navigate directly to it.
      _navigateToChat(existingChat);
    } else {
      // 4. CREATE: If no chat exists, call the creator notifier to make a new one.
      ref.read(personalChatCreatorProvider.notifier).createChatWithUser(
        otherUserName: widget.otherUser.name,
      );
    }
  }

  // Helper function to navigate to the chat page
  void _navigateToChat(Group group) {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PersonalMessagePage(
          group: group,
          otherUser: widget.otherUser,
          initialOrder: widget.initialOrder,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // We still listen for the result of the CREATE operation.
    ref.listen<PersonalChatCreatorState>(personalChatCreatorProvider, (previous, next) {
      if (next.value == PersonalChatCreatorStateValue.success && next.group != null) {
        // When the group is successfully created, navigate to it.
        _navigateToChat(next.group!);
      } else if (next.value == PersonalChatCreatorStateValue.error) {
        // If creation fails, show an error.
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text(next.errorMessage ?? 'Could not create chat.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(); // Close dialog
                  Navigator.of(context).pop(); // Go back from this loading page
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    });

    // The UI is just a simple loading spinner while the logic runs.
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Starting chat...'),
          ],
        ),
      ),
    );
  }
}