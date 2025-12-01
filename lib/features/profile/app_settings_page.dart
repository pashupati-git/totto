import 'package:flutter/material.dart';

import '../../common/appbar/common_app_bar.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';

class AppSettingsPage extends StatefulWidget
{
    const AppSettingsPage({super.key});

    @override
    State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage>
{
    late String _selectedLanguage;

    bool _orderUpdatesEnabled = false;
    bool _newMessagesEnabled = true;
    bool _groupActivityEnabled = false;
    bool _isLightMode = true;

    final List<String> _languageOptions = ['English', 'Nepali'];

    @override
    void didChangeDependencies()
    {
        final l10n = AppLocalizations.of(context)!;
        super.didChangeDependencies();
        final currentLocale = Localizations.localeOf(context);
        setState(()
            {
                _selectedLanguage = (currentLocale.languageCode == 'ne') ? 'Nepali' : 'English';
            }
        );
    }

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;

        return Scaffold(
            backgroundColor: const Color(0xFFF1F2F6),
            appBar: CommonAppBar(
                height: 60.0,
                backgroundColor: const Color(0xFFF1F2F6),
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                ),
                title: Text(
                    l10n.appSettings,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                actions: const[SizedBox(width: 56)],
            ),
            body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        _buildSectionHeader(l10n.changeLanguage), // Now this will work
                        DropdownButtonFormField<String>(
                            value: _selectedLanguage,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Colors.grey.shade300),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            items: _languageOptions.map((String language)
                                {
                                    return DropdownMenuItem<String>(
                                        value: language,
                                        child: Text(language),
                                    );
                                }
                            ).toList(),
                            onChanged: (newValue)
                            {
                                if (newValue != null)
                                {
                                    final newLocale = (newValue == 'Nepali')
                                        ? const Locale('ne')
                                        : const Locale('en');

                                    MyApp.setLocale(context, newLocale);
                                    setState(()
                                        {
                                            _selectedLanguage = newValue;
                                        }
                                    );
                                }
                            },
                        ),

                        _buildSectionHeader(l10n.notificationSettings),
                        _buildSwitchSetting(
                            title: l10n.orderUpdates,
                            value: _orderUpdatesEnabled,
                            onChanged: (newValue) => setState(() => _orderUpdatesEnabled = newValue),
                        ),
                        _buildSwitchSetting(
                            title: l10n.newMessages,
                            value: _newMessagesEnabled,
                            onChanged: (newValue) => setState(() => _newMessagesEnabled = newValue),
                        ),
                        _buildSwitchSetting(
                            title: l10n.groupActivity,
                            value: _groupActivityEnabled,
                            onChanged: (newValue) => setState(() => _groupActivityEnabled = newValue),
                        ),
                        _buildSectionHeader(l10n.notificationSound),
                        ListTile(
                            title: Text(l10n.defaultSound, style: TextStyle(fontSize: 15)),
                            contentPadding: EdgeInsets.zero,
                            onTap: ()
                            {
                            },
                        ),
                        _buildSectionHeader(l10n.appearance),
                        _buildSwitchSetting(
                            title: l10n.appearance,
                            subtitle: _isLightMode ? l10n.lightTheme : l10n.darkTheme,
                            value: _isLightMode,
                            onChanged: (newValue) => setState(() => _isLightMode = newValue),
                        ),
                    ],
                ),
            ),
        );
    }

    Widget _buildSectionHeader(String title)
    {
        return Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
            child: Text(
                title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
        );
    }

    Widget _buildSwitchSetting({
        required String title,
        String? subtitle,
        required bool value,
        required ValueChanged<bool> onChanged,
    })
    {
        return SwitchListTile(
            title: Text(title, style: const TextStyle(fontSize: 15)),
            subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Colors.grey)) : null,
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: Colors.red,
            contentPadding: EdgeInsets.zero,
        );
    }
}
