import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/data/models/group_model.dart';
import 'package:totto/data/repositories/group_repository.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';

final groupRepositoryProvider = Provider<GroupRepository>((ref)
    {
        return GroupRepository();
    }
);

// final allGroupsProvider = FutureProvider<List<Group>>((ref) async {
//     ref.watch(authStateChangesProvider);
//     final groupRepository = ref.watch(groupRepositoryProvider);
//     final allGroups = await groupRepository.fetchGroups();
//     return allGroups.where((group) => group.memberCount > 2).toList();
//
//
// }
// );



final allGroupsProvider = FutureProvider<List<Group>>((ref) async {
  ref.watch(authStateChangesProvider);
  final groupRepository = ref.watch(groupRepositoryProvider);
  return await groupRepository.fetchGroups();
});











final myGroupsProvider = FutureProvider<List<Group>>((ref) {
    ref.watch(authStateChangesProvider);
    final groupRepository = ref.watch(groupRepositoryProvider);
    return groupRepository.fetchMyGroups();
});

final isMemberOfProvider = Provider.family<bool, String>((ref, groupId)
    {
        final myGroups = ref.watch(myGroupsProvider).value ?? [];
        return myGroups.any((myGroup) => myGroup.id == groupId);
    }
);

final activeGroupsProvider = Provider<List<Group>>((ref)
    {
        final myGroupsAsync = ref.watch(myGroupsProvider);
        return myGroupsAsync.value ?? [];
    }

);

final groupDetailProvider =
FutureProvider.family.autoDispose<Group, String>((ref, groupId) {
    final groupRepository = ref.watch(groupRepositoryProvider);
    return groupRepository.fetchGroupDetails(groupId);
});

final personalChatGroupProvider =
FutureProvider.family<Group, String>((ref, otherUserId) async {
    final groupRepository = ref.watch(groupRepositoryProvider);
    final group = await groupRepository.getOrCreatePersonalChat(otherUserId);
    return group;
});





class JoinGroupState
{
    final bool isLoading;
    final String? error;
    const JoinGroupState({this.isLoading = false, this.error});
}

class JoinGroupNotifier extends StateNotifier<JoinGroupState>
{
    final Ref _ref;
    JoinGroupNotifier(this._ref) : super(const JoinGroupState());

    Future<void> joinGroup({required String groupId}) async
    {
        state = const JoinGroupState(isLoading: true, error: null);
        try
        {
            final repository = _ref.read(groupRepositoryProvider);
            await repository.joinGroup(groupId);
            _ref.invalidate(allGroupsProvider);
            _ref.invalidate(myGroupsProvider);
            state = const JoinGroupState(isLoading: false);
        }
        catch (e)
        {
            state = JoinGroupState(isLoading: false, error: e.toString());
            rethrow;
        }
    }
}

final joinGroupProvider = StateNotifierProvider.family<JoinGroupNotifier, JoinGroupState, String>((ref, groupId)
    {
        return JoinGroupNotifier(ref);
    }


);


enum PersonalChatCreatorStateValue { initial, loading, success, error }

class PersonalChatCreatorState {
    final PersonalChatCreatorStateValue value;
    final String? errorMessage;
    final Group? group;

    const PersonalChatCreatorState._(this.value, {this.errorMessage, this.group});

    const PersonalChatCreatorState.initial()
        : this._(PersonalChatCreatorStateValue.initial);
    const PersonalChatCreatorState.loading()
        : this._(PersonalChatCreatorStateValue.loading);
    const PersonalChatCreatorState.success(Group group)
        : this._(PersonalChatCreatorStateValue.success, group: group);
    const PersonalChatCreatorState.error(String message)
        : this._(PersonalChatCreatorStateValue.error, errorMessage: message);
}

class PersonalChatCreator extends StateNotifier<PersonalChatCreatorState> {
    final GroupRepository _repository;
    final Ref _ref;

    PersonalChatCreator(this._repository, this._ref)
        : super(const PersonalChatCreatorState.initial());

    Future<void> createChatWithUser({
        required String otherUserName,
    }) async {
        state = const PersonalChatCreatorState.loading();
        try {

            await _repository.createGroup(
                name: otherUserName,
                guidelines: 'Personal Chat',
                categoryId: 4,
                roomType: 'F',
            );

            final myFreshGroups = await _ref.refresh(myGroupsProvider.future);

            final newPersonalChat = myFreshGroups.firstWhere(
                    (g) => g.name == otherUserName && g.memberCount <= 2,
                orElse: () => throw Exception('Could not find the newly created personal chat.'),
            );

            state = PersonalChatCreatorState.success(newPersonalChat);

        } catch (e) {
            state = PersonalChatCreatorState.error(e.toString());
        }
    }
}

final personalChatCreatorProvider =
StateNotifierProvider<PersonalChatCreator, PersonalChatCreatorState>((ref) {
    final repository = ref.watch(groupRepositoryProvider);
    return PersonalChatCreator(repository, ref);
});

