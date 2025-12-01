// lib/features/onboarding/provider/profile_setup_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/data/models/business_category_model.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';

class ProfileSetupState
{
    final String fullName;
    final String? memberCategory;
    final BusinessCategory? selectedBusinessCategory;
    final String? tradingFrequency;

    final AsyncValue<List<BusinessCategory>> businessCategories;
    final bool isLoading;
    final String? errorMessage;

    const ProfileSetupState({
        this.fullName = '',
        this.memberCategory,
        this.selectedBusinessCategory,
        this.tradingFrequency,
        this.businessCategories = const AsyncValue.loading(),
        this.isLoading = false,
        this.errorMessage,
    });

    /// Checks if the mandatory fields have been filled.
    bool get isFormValid => fullName.trim().isNotEmpty && memberCategory != null;

    ProfileSetupState copyWith({
        String? fullName,
        String? memberCategory,
        BusinessCategory? selectedBusinessCategory,
        String? tradingFrequency,
        AsyncValue<List<BusinessCategory>>? businessCategories,
        bool? isLoading,
        String? errorMessage,
        bool clearErrorMessage = false,
    })
    {
        return ProfileSetupState(
            fullName: fullName ?? this.fullName,
            memberCategory: memberCategory ?? this.memberCategory,
            selectedBusinessCategory: selectedBusinessCategory ?? this.selectedBusinessCategory,
            tradingFrequency: tradingFrequency ?? this.tradingFrequency,
            businessCategories: businessCategories ?? this.businessCategories,
            isLoading: isLoading ?? this.isLoading,
            errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
        );
    }
}

class ProfileSetupNotifier extends StateNotifier<ProfileSetupState>
{
    final Ref _ref;

    ProfileSetupNotifier(this._ref) : super(const ProfileSetupState())
    {
        fetchBusinessCategories();
    }

    Future<void> fetchBusinessCategories() async
    {
        state = state.copyWith(businessCategories: const AsyncValue.loading());
        try
        {
            // Assuming fetchBusinessCategories exists in your AuthRepository
            final categories = await _ref.read(authRepositoryProvider).fetchBusinessCategories();
            state = state.copyWith(businessCategories: AsyncValue.data(categories));
        }
        catch (e, s)
        {
            state = state.copyWith(businessCategories: AsyncValue.error(e, s));
        }
    }

    void onFullNameChanged(String value) => state = state.copyWith(fullName: value, clearErrorMessage: true);
    void onMemberCategoryChanged(String? value) => state = state.copyWith(memberCategory: value, clearErrorMessage: true);
    void onBusinessCategoryChanged(BusinessCategory? value) => state = state.copyWith(selectedBusinessCategory: value);
    void onTradingFrequencyChanged(String? value) => state = state.copyWith(tradingFrequency: value);

    Future<bool> submitProfile() async
    {
        state = state.copyWith(isLoading: true, clearErrorMessage: true);

        if (!state.isFormValid)
        {
            state = state.copyWith(isLoading: false, errorMessage: 'Full Name and Member Category are required.');
            return false;
        }

        // CORRECTED: Splitting the full name into first_name and last_name, as per your backend schema.
        final fullName = state.fullName.trim();
        final nameParts = fullName.split(' ');
        final String firstName = nameParts.isNotEmpty ? nameParts.first : '';
        final String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';

        final Map<String, dynamic> dataToSubmit =
            {
                'first_name': firstName,
                'last_name': lastName,

                // Keeping the cleanup logic as this is a good practice for APIs.
                'member_category': state.memberCategory?.split('(').first.toLowerCase(),

                if (state.selectedBusinessCategory != null)
                'business_category': state.selectedBusinessCategory!.id,

                if (state.tradingFrequency != null)
                'trading_frequency': state.tradingFrequency?.split(' ').first.toLowerCase(),
            };

        // This will remove any keys that have null values, which is safer for PATCH requests.
        dataToSubmit.removeWhere((key, value) => value == null);

        try
        {
            // This calls the updateUserProfile method in your repository.
            await _ref.read(authRepositoryProvider).updateUserProfile(dataToSubmit);

            // Manually refresh the user's data so the whole app is aware of the change.
            await _ref.read(authRepositoryProvider).fetchCurrentUser();

            state = state.copyWith(isLoading: false);
            return true;
        }
        catch (e)
        {
            final errorMessage = e.toString();
            state = state.copyWith(isLoading: false, errorMessage: 'Failed to submit profile: $errorMessage');
            return false;
        }
    }
}

final profileSetupProvider =
    StateNotifierProvider<ProfileSetupNotifier, ProfileSetupState>((ref)
        {
            return ProfileSetupNotifier(ref);
        }
    );
