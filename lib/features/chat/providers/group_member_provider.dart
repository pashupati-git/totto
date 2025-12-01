import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/data/models/group_member_model.dart';
import 'package:totto/data/repositories/group_member_repository.dart';
import 'package:totto/data/repositories/group_repository.dart';
import 'package:totto/features/chat/providers/group_provider.dart';

final groupMemberRepositoryProvider = Provider<GroupMemberRepository>((ref)
    {
        return GroupMemberRepository();
    }
);

final groupRepositoryProvider = Provider<GroupRepository>((ref)
    {
        return GroupRepository();
    }
);

final groupMembersProvider = FutureProvider.family<List<GroupMember>, String>((ref, groupId)
    {
        final repository = ref.watch(groupMemberRepositoryProvider);
        return repository.fetchGroupMembers(groupId);
    }
);

class GroupMemberActionNotifier extends StateNotifier<AsyncValue<void>>
{
    final Ref _ref;
    final String groupId;

    GroupMemberActionNotifier(this._ref, this.groupId) : super(const AsyncData(null));

    Future<void> updateRole({required int memberId, required String newRole}) async
    {
        state = const AsyncLoading();
        try
        {
            final repository = _ref.read(groupMemberRepositoryProvider);
            await repository.updateMemberRole(memberId: memberId, newRole: newRole);
            _ref.invalidate(groupMembersProvider(groupId));
            _ref.invalidate(allGroupsProvider);
            _ref.invalidate(myGroupsProvider);
            state = const AsyncData(null);
        }
        catch (e, stack)
        {
            state = AsyncError(e, stack);
            rethrow;
        }
    }

    Future<void> removeMember(int memberId) async
    {
        state = const AsyncLoading();
        try
        {
            final repository = _ref.read(groupMemberRepositoryProvider);
            await repository.removeMember(memberId);
            _ref.invalidate(groupMembersProvider(groupId));
            _ref.invalidate(allGroupsProvider);
            _ref.invalidate(myGroupsProvider);
            state = const AsyncData(null);
        }
        catch (e, stack)
        {
            state = AsyncError(e, stack);
            rethrow;
        }
    }
}

final groupMemberActionProvider = StateNotifierProvider.family<GroupMemberActionNotifier, AsyncValue<void>, String>((ref, groupId)
    {
        return GroupMemberActionNotifier(ref, groupId);
    }
);

class GroupSettingsActionNotifier extends StateNotifier<AsyncValue<void>>
{
    final Ref _ref;
    final String groupId;

    GroupSettingsActionNotifier(this._ref, this.groupId) : super(const AsyncData(null));

    Future<void> updateGroupName(String newName) async
    {
        state = const AsyncLoading();
        try
        {
            final repository = _ref.read(groupRepositoryProvider);
            await repository.updateGroup(groupId, newName: newName);
            _ref.invalidate(allGroupsProvider);
            _ref.invalidate(myGroupsProvider);
            state = const AsyncData(null);
        }
        catch (e, stack)
        {
            state = AsyncError(e, stack);
            rethrow;
        }
    }

    Future<void> leaveGroup(int memberId) async
    {
        state = const AsyncLoading();
        try
        {
            final repository = _ref.read(groupMemberRepositoryProvider);
            await repository.removeMember(memberId);
            _ref.invalidate(allGroupsProvider);
            _ref.invalidate(groupMembersProvider(groupId));
            _ref.invalidate(myGroupsProvider);
            state = const AsyncData(null);
        }
        catch (e, stack)
        {
            state = AsyncError(e, stack);
            rethrow;
        }
    }

    Future<void> deleteGroup() async
    {
        state = const AsyncLoading();
        try
        {
            final repository = _ref.read(groupRepositoryProvider);
            await repository.deleteGroup(groupId);
            _ref.invalidate(allGroupsProvider);
            _ref.invalidate(myGroupsProvider);
            state = const AsyncData(null);
        }
        catch (e, stack)
        {
            state = AsyncError(e, stack);
            rethrow;
        }
    }
}

final groupSettingsActionProvider = StateNotifierProvider.family<GroupSettingsActionNotifier, AsyncValue<void>, String>((ref, groupId)
    {
        return GroupSettingsActionNotifier(ref, groupId);
    }
);

class AddMemberNotifier extends StateNotifier<AsyncValue<void>>
{
    final Ref _ref;
    AddMemberNotifier(this._ref) : super(const AsyncData(null));

    Future<void> addMember({required String groupId, required String userId}) async
    {
        state = const AsyncLoading();
        try
        {
            await _ref.read(groupMemberRepositoryProvider).addMember(groupId: groupId, userId: userId);
            _ref.invalidate(groupMembersProvider(groupId));
            _ref.invalidate(allGroupsProvider);
            _ref.invalidate(myGroupsProvider);
            state = const AsyncData(null);
        }
        catch (e, stack)
        {
            state = AsyncError(e, stack);
            rethrow;
        }
    }
}

final addMemberProvider = StateNotifierProvider.family<AddMemberNotifier, AsyncValue<void>, String>((ref, userId)
    {
        return AddMemberNotifier(ref);
    }
);

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

    Future<void> joinGroup({required String groupId, required String userId}) async
    {
        state = const JoinGroupState(isLoading: true);
        try
        {
            final repository = _ref.read(groupMemberRepositoryProvider);
            await repository.joinGroup(groupId: groupId, userId: userId);
            _ref.invalidate(allGroupsProvider);
            _ref.invalidate(myGroupsProvider);
            state = const JoinGroupState(isLoading: false);
        }
        catch (e)
        {
            state = JoinGroupState(isLoading: false, error: e.toString());
        }
    }
}

final joinGroupProvider = StateNotifierProvider.family<JoinGroupNotifier, JoinGroupState, String>((ref, groupId)
    {
        return JoinGroupNotifier(ref);
    }
);
