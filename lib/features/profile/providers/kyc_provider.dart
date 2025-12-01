import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/data/models/kyc_model.dart';
import 'package:totto/data/repositories/kyc_repository.dart';

final kycRepositoryProvider = Provider<KycRepository>((ref) => KycRepository());

final kycStatusProvider = FutureProvider<KycModel?>((ref)
    {
        final kycRepository = ref.watch(kycRepositoryProvider);
        return kycRepository.fetchKycStatus();
    }
);

class KycNotifier extends StateNotifier<AsyncValue<KycModel>>
{
    final Ref _ref;

    KycNotifier(this._ref, KycModel? initialData)
        : super(AsyncData(initialData ?? KycModel()));

    void updateData(KycModel newData)
    {
        if (state is! AsyncLoading)
        {
            state = AsyncData(newData);
        }
    }

    Future<void> submitOrUpdateKyc() async
    {
        if (state.value == null)
        {
            throw Exception("Form data is not available.");
        }

        final kycDataToSubmit = state.value!;
        state = const AsyncLoading();

        try
        {
            final repository = _ref.read(kycRepositoryProvider);
            final initialKycStatus = await _ref.read(kycStatusProvider.future);

            if (initialKycStatus?.id != null)
            {
                await repository.updateKyc(kycDataToSubmit.copyWith(id: initialKycStatus!.id));
            }
            else
            {
                await repository.submitKyc(kycDataToSubmit);
            }

            _ref.invalidate(kycStatusProvider);

            state = AsyncData(kycDataToSubmit);
        }
        catch (e)
        {
            state = AsyncData(kycDataToSubmit);
            rethrow;
        }
    }
}

final kycProvider = StateNotifierProvider<KycNotifier, AsyncValue<KycModel>>((ref)
    {
        final initialKycData = ref.watch(kycStatusProvider).value;
        return KycNotifier(ref, initialKycData);
    }
);
