import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:totto/l10n/app_localizations.dart';

import 'features/onboarding/loading_screens/splash_screen.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) => throw UnimplementedError());

void main() async
{
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();

    final languageCode = prefs.getString('languageCode') ?? 'en';

    runApp(
        ProviderScope(
            overrides: [
                sharedPreferencesProvider.overrideWithValue(prefs),
            ],
            child: MyApp(initialLocale: Locale(languageCode)),
        ),
    );
}

class MyApp extends ConsumerStatefulWidget
{
    final Locale initialLocale;
    const MyApp({super.key, required this.initialLocale});

    static void setLocale(BuildContext context, Locale newLocale)
    {
        final state = context.findAncestorStateOfType<_MyAppState>();
        state?.setLocale(newLocale);
    }

    @override
    ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp>
{
    late Locale _locale;

    @override
    void initState()
    {
        super.initState();
        _locale = widget.initialLocale;
    }

    void setLocale(Locale newLocale)
    {
        final prefs = ref.read(sharedPreferencesProvider);
        prefs.setString('languageCode', newLocale.languageCode);

        setState(()
            {
                _locale = newLocale;
            }
        );
    }

    @override
    Widget build(BuildContext context)
    {
        return MaterialApp(
            title: 'Totto',
            theme: ThemeData(
                useMaterial3: true,
            ),
            builder: (context, child)
            {
                return GestureDetector(
                    onTap: ()
                    {
                        FocusScope.of(context).unfocus();
                    },
                    child: child,
                );
            },
            locale: _locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SplashScreen(),

            debugShowCheckedModeBanner: false,
        );
    }
}
