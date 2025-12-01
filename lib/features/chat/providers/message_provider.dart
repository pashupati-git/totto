import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/data/models/message_model.dart';
import 'package:totto/data/repositories/message_repository.dart';

final messageRepositoryProvider = Provider<MessageRepository>((ref)
    {
        return MessageRepository();
    }
);

final messagesProvider = FutureProvider.family<List<Message>, String>((ref, groupId)
    {
        final messageRepository = ref.watch(messageRepositoryProvider);
        return messageRepository.fetchMessagesForGroup(groupId);
    }
);

class SendMessageNotifier extends StateNotifier<AsyncValue<void>>
{
    final Ref _ref;
    SendMessageNotifier(this._ref) : super(const AsyncData(null));

    Future<void> sendMessage({required String content, required String groupId}) async
    {
        state = const AsyncLoading();
        try
        {
            final repository = _ref.read(messageRepositoryProvider);
            await repository.postMessage(content: content, groupId: groupId);

            _ref.invalidate(messagesProvider(groupId));
            state = const AsyncData(null);
        }
        catch (e, stack)
        {
            state = AsyncError(e, stack);
        }
    }
}

final sendMessageProvider = StateNotifierProvider<SendMessageNotifier, AsyncValue<void>>((ref)
    {
        return SendMessageNotifier(ref);
    }
);

