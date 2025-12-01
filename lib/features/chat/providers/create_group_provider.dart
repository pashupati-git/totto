import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/features/chat/providers/group_provider.dart';

class CreateGroupState
{
    final bool isLoading;
    final String? error;
    final bool isSuccess;

    CreateGroupState({
        this.isLoading = false,
        this.error,
        this.isSuccess = false,
    });

    CreateGroupState copyWith({bool? isLoading, String? error, bool? isSuccess})
    {
        return CreateGroupState(
            isLoading: isLoading ?? this.isLoading,
            error: error ?? this.error,
            isSuccess: isSuccess ?? this.isSuccess,
        );
    }
}

class CreateGroupNotifier extends StateNotifier<CreateGroupState>
{
    final Ref _ref;
    CreateGroupNotifier(this._ref) : super(CreateGroupState());

    Future<void> createGroup({
        required String name,
        required String guidelines,
        required int categoryId,
        required String roomType,
    }) async
    {
        state = state.copyWith(isLoading: true, error: null, isSuccess: false);

        try
        {
            final repository = _ref.read(groupRepositoryProvider);
            await repository.createGroup(
                name: name,
                guidelines: guidelines,
                categoryId: categoryId,
                roomType: roomType,
            );

            _ref.invalidate(allGroupsProvider);
            _ref.invalidate(myGroupsProvider);

            state = state.copyWith(isLoading: false, isSuccess: true);
        }
        catch (e)
        {
            state = state.copyWith(isLoading: false, error: e.toString());
        }
    }
}

final createGroupProvider = StateNotifierProvider<CreateGroupNotifier, CreateGroupState>((ref)
    {
        return CreateGroupNotifier(ref);
    }
);
