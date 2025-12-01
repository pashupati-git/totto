import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:totto/common/primary_button.dart';
import 'package:totto/features/auth/providers/auth_providers.dart';
import 'package:totto/features/home/home_screen.dart';
import 'package:totto/features/onboarding/profile_setup_page.dart';
import 'package:totto/l10n/app_localizations.dart';

class OTPInputPage extends ConsumerStatefulWidget
{
    final String phoneNumber;

    const OTPInputPage({
        super.key,
        required this.phoneNumber,
    });

    @override
    ConsumerState<OTPInputPage> createState() => _OTPInputPageState();
}

class _OTPInputPageState extends ConsumerState<OTPInputPage>
{
    final pinController = TextEditingController();
    final focusNode = FocusNode();

    late Timer _timer;
    int _countdown = 30;
    bool _isResendEnabled = false;
    bool _isLoading = false;

    @override
    void initState()
    {
        super.initState();
        startTimer();
    }

    void startTimer()
    {
        _isResendEnabled = false;
        _countdown = 30;
        _timer = Timer.periodic(const Duration(seconds: 1), (timer)
            {
                if (!mounted) return;
                if (_countdown > 0)
                {
                    setState(() => _countdown--);
                }
                else
                {
                    setState(() => _isResendEnabled = true);
                    _timer.cancel();
                }
            }
        );
    }

    void _resendOtp() async
    {
        final l10n = AppLocalizations.of(context)!;
        if (!_isResendEnabled || _isLoading) return;
        print('Resending OTP to ${widget.phoneNumber}...');
        setState(()
            {
                _isLoading = true;
                _isResendEnabled = false;
            }
        );

        final phoneWithoutCountryCode = widget.phoneNumber.replaceAll('+977', '').trim();
        final success = await ref.read(authRepositoryProvider).requestOtp(phoneWithoutCountryCode);

        if (!success && mounted)
        {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.failedToResendOtp)),
            );
        }

        if (mounted)
        {
            setState(() => _isLoading = false);
            startTimer();
        }
    }

    void _verifyOtp(String pin) async
    {
        final l10n = AppLocalizations.of(context)!;
        if (pin.length < 6 || _isLoading) return;
        print('Verifying API with OTP: $pin');
        setState(() => _isLoading = true);

        final userProfile = await ref.read(authRepositoryProvider).verifyOtpAndLogin(pin);

        if (mounted) setState(() => _isLoading = false);

        if (userProfile != null && mounted)
        {
            if (userProfile.isProfileComplete)
            {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (route) => false,
                );
            }
            else
            {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const ProfileSetupPage()),
                );
            }
        }
        else if (mounted)
        {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(l10n.invalidOtp),
                    backgroundColor: Colors.red,
                ),
            );
            pinController.clear();
            focusNode.requestFocus();
        }
    }

    @override
    void dispose()
    {
        pinController.dispose();
        focusNode.dispose();
        _timer.cancel();
        super.dispose();
    }

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        final defaultPinTheme = PinTheme(
            width: 56,
            height: 60,
            textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.transparent),
            ),
        );

        return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                elevation: 0,
                backgroundColor: Colors.white,
            ),
            body: Stack(
                fit: StackFit.expand,
                children: [
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset('assets/str1.png', width: double.infinity, fit: BoxFit.fill),
                    ),
                    SafeArea(
                        child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                    const SizedBox(height: 16),
                                    Text(l10n.verificationCode, textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 10),
                                    Text(l10n.enterCodeSentTo(widget.phoneNumber), textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                                    const SizedBox(height: 48),
                                    Pinput(
                                        length: 6,
                                        controller: pinController,
                                        focusNode: focusNode,
                                        autofocus: true,
                                        defaultPinTheme: defaultPinTheme,
                                        focusedPinTheme: defaultPinTheme.copyWith(
                                            decoration: defaultPinTheme.decoration!.copyWith(border: Border.all(color: Colors.red)),
                                        ),
                                        onCompleted: (pin) => _verifyOtp(pin),
                                    ),
                                    const SizedBox(height: 32),
                                    PrimaryButton(
                                        text: l10n.verify,
                                        isLoading: _isLoading,
                                        onPressed: () => _verifyOtp(pinController.text),
                                    ),
                                    const SizedBox(height: 10),

                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            Text("${l10n.didNotReceiveCode} ", style: const TextStyle(color: Colors.grey)),
                                            _isResendEnabled
                                                ? TextButton(onPressed: _resendOtp, child: Text(l10n.resendOtp, style: const TextStyle(color: Colors.red)))
                                                : Text(l10n.resendOtpIn(_countdown.toString()), style: const TextStyle(color: Colors.grey)),
                                        ],
                                    ),
                                ],
                            ),
                        ),
                    ),
                ],
            ),
        );
    }
}
