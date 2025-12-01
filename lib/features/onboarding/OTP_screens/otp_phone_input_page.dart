import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/l10n/app_localizations.dart';

import '../../../common/primary_button.dart';
import '../../auth/providers/auth_providers.dart';
import '../../profile/privacy_policy_page.dart';
import '../../profile/terms_and_condition_page.dart';
import 'otp_input_page.dart';

class OTPPhoneInputPage extends ConsumerStatefulWidget
{
    const OTPPhoneInputPage({super.key});

    @override
    ConsumerState<OTPPhoneInputPage> createState() => _OTPPhoneInputPageState();
}

class _OTPPhoneInputPageState extends ConsumerState<OTPPhoneInputPage>
{
    final _phoneController = TextEditingController();
    late TapGestureRecognizer _termsRecognizer;
    late TapGestureRecognizer _privacyRecognizer;
    bool _isOtpLoading = false;

    @override
    void initState()
    {
        super.initState();

        _termsRecognizer = TapGestureRecognizer()
            ..onTap = ()
        {
            print('Navigating to Terms & Conditions...');
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const TermsAndConditionsPage(),
                ),
            );
        };

        _privacyRecognizer = TapGestureRecognizer()
            ..onTap = ()
        {
            print('Navigating to Privacy Policy...');
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const PrivacyPolicyPage(),
                ),
            );
        };
    }

    @override
    void dispose()
    {
        _phoneController.dispose();
        _termsRecognizer.dispose();
        _privacyRecognizer.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;

        ref.listen<GoogleSignInState>(googleSignInNotifierProvider, (previous, next)
            {
                if (next == GoogleSignInState.error)
                {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.googleSignInFailed)), // You'll need to add this to your l10n files
                    );
                }
            }
        );

        final googleSignInState = ref.watch(googleSignInNotifierProvider);
        final isGoogleLoading = googleSignInState == GoogleSignInState.loading;

        return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.white,
            ),
            body: Stack(
                fit: StackFit.expand,
                children: [
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                            'assets/str1.png',
                            width: double.infinity,
                            fit: BoxFit.fitWidth,
                        ),
                    ),
                    SafeArea(
                        child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    const SizedBox(height: 16),
                                    Text(l10n.otpVerification, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(l10n.enterYourPhoneNumber, style: const TextStyle(color: Colors.grey)),
                                    const SizedBox(height: 32),
                                    Row(
                                        children: [
                                            ClipOval(child: Image.asset('assets/flags/np.png', width: 32, height: 32, fit: BoxFit.cover)),
                                            const SizedBox(width: 12),
                                            const Text('+977', style: TextStyle(fontSize: 16)),
                                            const SizedBox(width: 12),
                                            Expanded(
                                                child: TextField(
                                                    controller: _phoneController,
                                                    keyboardType: TextInputType.phone,
                                                    autofocus: true,
                                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                                                    decoration: InputDecoration(hintText: l10n.mobileNumber, border: const UnderlineInputBorder()),
                                                ),
                                            ),
                                        ],
                                    ),
                                    const SizedBox(height: 32),
                                    PrimaryButton(
                                        text: l10n.getOtp,
                                        isLoading: _isOtpLoading,
                                        onPressed: () async
                                        {
                                            if (_isOtpLoading) return;

                                            final phoneNumber = _phoneController.text;
                                            if (phoneNumber.length == 10)
                                            {
                                                setState(() => _isOtpLoading = true);
                                                final success = await ref.read(authRepositoryProvider).requestOtp(phoneNumber);
                                                setState(() => _isOtpLoading = false);

                                                if (success && mounted)
                                                {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                            builder: (context) => OTPInputPage(phoneNumber: "+977$phoneNumber")));
                                                }
                                                else
                                                {
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                        SnackBar(content: Text(l10n.failedToSendOtp)));
                                                }
                                            }
                                            else
                                            {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text(l10n.enterValid10DigitNumber)));
                                            }
                                        },
                                    ),
                                    const SizedBox(height: 24),

                                    Row(
                                        children: [
                                            const Expanded(child: Divider()),
                                            Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                                child: Text(l10n.or, style: const TextStyle(color: Colors.grey)),
                                            ),
                                            const Expanded(child: Divider()),
                                        ],
                                    ),
                                    const SizedBox(height: 24),

                                    isGoogleLoading
                                        ? const CircularProgressIndicator()
                                        : OutlinedButton.icon(
                                            onPressed: ()
                                            {
                                                ref.read(googleSignInNotifierProvider.notifier).signInWithGoogle();
                                            },
                                            icon: Image.asset('assets/logos/googlelogo.png', height: 20.0),
                                            label: Text(l10n.signInWithGoogle, style: const TextStyle(color: Colors.black)),
                                            style: OutlinedButton.styleFrom(
                                                minimumSize: const Size(double.infinity, 50),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                side: BorderSide(color: Colors.grey.shade300),
                                            ),
                                        ),
                                    const SizedBox(height: 24),

                                    Text.rich(
                                        TextSpan(
                                            text: l10n.byLoggingInYouAgree,
                                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                                            children: [
                                                TextSpan(
                                                    text: '${l10n.termsAndConditions} ',
                                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                                    recognizer: _termsRecognizer),
                                                TextSpan(text: l10n.and),
                                                TextSpan(
                                                    text: l10n.privacyPolicyDot,
                                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                                                    recognizer: _privacyRecognizer),
                                            ],
                                        ),
                                        textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 150),
                                ],
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
}
