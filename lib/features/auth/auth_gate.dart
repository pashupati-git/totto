
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/home/home_screen.dart';
import 'package:totto/features/onboarding/OTP_screens/otp_phone_input_page.dart';
import 'package:totto/features/onboarding/profile_setup_page.dart';

class AuthGate extends ConsumerWidget
{
    const AuthGate({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref)
    {
        final authState = ref.watch(authStateChangesProvider);

        return authState.when(

            loading: () => const Scaffold(
                body: Center(
                    child: CircularProgressIndicator(),
                ),
            ),

            error: (err, stack) => const OTPPhoneInputPage(),

            data: (user)
            {
                if (user != null)
                {

                    if (user.isProfileComplete)
                    {
                        return const HomeScreen();
                    }
                    else
                    {
                        return const ProfileSetupPage();
                    }
                }
                else
                {

                    return const OTPPhoneInputPage();
                }
            },
        );
    }
}
