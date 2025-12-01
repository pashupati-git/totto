import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/features/auth/auth_gate.dart';
import 'package:totto/l10n/app_localizations.dart';
import 'package:totto/main.dart';

class OnboardingItem
{
    final String imagePath;
    final String title;
    final String subtitle;

    OnboardingItem({
        required this.imagePath,
        required this.title,
        required this.subtitle,
    });
}

class OnboardingScreen extends ConsumerStatefulWidget
{
    const OnboardingScreen({super.key});

    @override
    ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
{
    final PageController _pageController = PageController();
    int _currentPage = 0;

    @override
    void dispose()
    {
        _pageController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;

        final List<OnboardingItem> onboardingData = [
            OnboardingItem(
                imagePath: 'assets/splash/nxtscn1.png',
                title: l10n.onboarding1Title,
                subtitle: l10n.onboarding1Subtitle,
            ),
            OnboardingItem(
                imagePath: 'assets/splash/nxtscn2.png',
                title: l10n.onboarding2Title,
                subtitle: l10n.onboarding2Subtitle,
            ),
            OnboardingItem(
                imagePath: 'assets/splash/nxtscn3.png',
                title: l10n.onboarding3Title,
                subtitle: l10n.onboarding3Subtitle,
            ),
        ];

        return Scaffold(
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Column(
                        children: [
                            Expanded(
                                child: PageView.builder(
                                    controller: _pageController,
                                    itemCount: onboardingData.length,
                                    onPageChanged: (int page)
                                    {
                                        setState(()
                                            {
                                                _currentPage = page;
                                            }
                                        );
                                    },
                                    itemBuilder: (context, index)
                                    {
                                        return OnboardingPageItem(item: onboardingData[index]);
                                    },
                                ),
                            ),

                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                    onboardingData.length,
                                    (index) => _buildPageIndicator(index == _currentPage),
                                ),
                            ),

                            const SizedBox(height: 40),

                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFD80015),
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                            ),
                                        ),
                                        onPressed: () async
                                        {
                                            if (_currentPage < onboardingData.length - 1)
                                            {
                                                _pageController.nextPage(
                                                    duration: const Duration(milliseconds: 400),
                                                    curve: Curves.easeInOut,
                                                );
                                            }
                                            else
                                            {
                                                final prefs = ref.read(sharedPreferencesProvider);
                                                await prefs.setBool('hasSeenOnboarding', true);

                                                if (context.mounted)
                                                {
                                                    Navigator.of(context).pushReplacement(
                                                        MaterialPageRoute(builder: (context) => const AuthGate()),
                                                    );
                                                }
                                                print('Onboarding complete. Navigating to AuthGate...');
                                            }
                                        },
                                        child: Text(
                                            _currentPage < onboardingData.length - 1 ? l10n.nextButton : l10n.getStartedButton,
                                            style: const TextStyle(fontSize: 16, color: Colors.white),
                                        ),
                                    ),
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }

    Widget _buildPageIndicator(bool isActive)
    {
        return AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            height: 8,
            width: isActive ? 24 : 8,
            decoration: BoxDecoration(
                color: isActive ? Colors.red : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
            ),
        );
    }
}

class OnboardingPageItem extends StatelessWidget
{
    final OnboardingItem item;

    const OnboardingPageItem({super.key, required this.item});

    @override
    Widget build(BuildContext context)
    {
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Image.asset(
                        item.imagePath,
                        height: MediaQuery.of(context).size.height * 0.35,
                        errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image, size: 100, color: Colors.grey.shade300
                        ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Text(
                        item.subtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                ],
            ),
        );
    }
}
