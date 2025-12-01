
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingNotifier extends StateNotifier<AsyncValue<bool>>
{
    OnboardingNotifier() : super(const AsyncValue.loading())
    {
        _checkOnboardingStatus();
    }

    static const String _onboardingCompleteKey = 'onboardingComplete';
    Future<void> _checkOnboardingStatus() async
    {
        try
        {
            final prefs = await SharedPreferences.getInstance();
            final hasCompleted = prefs.getBool(_onboardingCompleteKey) ?? false;
            state = AsyncValue.data(hasCompleted);
        }
        catch (e, s)
        {
            state = AsyncValue.error(e, s);
        }
    }

    Future<void> completeOnboarding() async
    {
        try
        {
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool(_onboardingCompleteKey, true);
            state = const AsyncValue.data(true);
            print('Onboarding status set to complete.');
        }
        catch (e, s)
        {
            state = AsyncValue.error(e, s);
        }
    }
}
final onboardingProvider =
    StateNotifierProvider<OnboardingNotifier, AsyncValue<bool>>((ref)
        {
            return OnboardingNotifier();
        }
    );
