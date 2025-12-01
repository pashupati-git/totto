import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:totto/l10n/app_localizations.dart';
import 'package:totto/main.dart';

import '../../../common/primary_button.dart';
import 'onboarding_screen.dart';

class LanguageSelectionScreen extends StatefulWidget
{
    const LanguageSelectionScreen({super.key});

    @override
    State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
{
    String _selectedLanguageCode = 'en';

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;

        final List<Map<String, dynamic>> languages = [
        {'code': 'en', 'flagPath': 'assets/flags/us.png', 'title': l10n.englishLanguage, 'subtitle': l10n.englishSubtitle, 'isSelectable': true},
        {'code': 'ne', 'flagPath': 'assets/flags/np.png', 'title': l10n.nepaliLanguage, 'subtitle': l10n.nepaliSubtitle, 'isSelectable': true},
        {'code': 'en_NE', 'flagPath': 'assets/flags/mixed.png', 'title': l10n.englishAndNepali, 'subtitle': l10n.languageMixedSubtitle, 'isSelectable': false},
        ];

        return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
                fit: StackFit.expand,
                children: [
                    Positioned(
                        bottom: 170,
                        left: 0,
                        right: 0,
                        child: Image.asset('assets/str1.png', fit: BoxFit.fitWidth),
                    ),
                    SafeArea(
                        child: Column(
                            children: [
                                const SizedBox(height: 24),
                                Text(l10n.language, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(
                                    l10n.chooseLanguage,
                                    style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
                                const SizedBox(height: 32),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                            child: Column(
                                                children: languages.map((language)
                                                    {
                                                        final bool isSelectable = language['isSelectable'];
                                                        return Padding(
                                                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                                                            child: GestureDetector(
                                                                onTap: isSelectable
                                                                    ? ()
                                                                    {
                                                                        setState(()
                                                                            {
                                                                                _selectedLanguageCode = language['code']!;
                                                                            }
                                                                        );
                                                                    }
                                                                    : null,
                                                                child: Opacity(
                                                                    opacity: isSelectable ? 1.0 : 0.5,
                                                                    child: LanguageOption(
                                                                        flagPath: language['flagPath']!,
                                                                        title: language['title']!,
                                                                        subtitle: language['subtitle'],
                                                                        selected: isSelectable && _selectedLanguageCode == language['code'],
                                                                    ),
                                                                ),
                                                            ),
                                                        );
                                                    }
                                                ).toList(),
                                            ),
                                        ),
                                    ),
                                ),
                                const SizedBox(height: 100),
                            ],
                        ),
                    ),
                    Positioned(
                        bottom: 95,
                        left: 30,
                        right: 30,
                        child: PrimaryButton(
                            text: l10n.continueButton,
                            onPressed: () async
                            {
                                print('Continuing with language: $_selectedLanguageCode');

                                final prefs = await SharedPreferences.getInstance();
                                await prefs.setString('languageCode', _selectedLanguageCode);

                                final newLocale = Locale(_selectedLanguageCode);
                                MyApp.setLocale(context, newLocale);

                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                                );
                            },
                        ),
                    ),
                ],
            ),
        );
    }
}

class LanguageOption extends StatelessWidget
{
    final String flagPath;
    final String title;
    final String? subtitle;
    final bool selected;

    const LanguageOption({
        super.key,
        required this.flagPath,
        required this.title,
        this.subtitle,
        this.selected = false,
    });

    @override
    Widget build(BuildContext context)
    {
        return Container(
            decoration: BoxDecoration(
                border: Border.all(
                    color: selected ? Colors.red : Colors.grey.shade300,
                    width: selected ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                color: selected ? Colors.red.withOpacity(0.05) : Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Row(
                        children: [
                            ClipOval(
                                child: Image.asset(
                                    flagPath,
                                    width: 24,
                                    height: 24,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace)
                                    {
                                        return const Icon(Icons.error, color: Colors.red);
                                    },
                                ),
                            ),
                            const SizedBox(width: 12),
                            Text(title, style: const TextStyle(fontSize: 16)),
                        ],
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty)
                    Text(subtitle!, style: const TextStyle(color: Colors.grey)),
                ],
            ),
        );
    }
}
