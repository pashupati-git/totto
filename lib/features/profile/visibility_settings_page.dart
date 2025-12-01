import 'package:flutter/material.dart';

import '../../common/appbar/common_app_bar.dart';
import '../../l10n/app_localizations.dart';

class ProfileVisibilityPage extends StatefulWidget
{
    const ProfileVisibilityPage({super.key});

    @override
    State<ProfileVisibilityPage> createState() => _ProfileVisibilityPageState();
}

class _ProfileVisibilityPageState extends State<ProfileVisibilityPage>
{
    String _selectedVisibility = 'Private Account';
    String _selectedPublicOption = 'All Users';

    late List<String> _visibilityOptions;
    late List<String> _publicOptions;
    late Map<String, String> _visibilityKeys;
    late Map<String, String> _publicOptionKeys;

    @override
    void didChangeDependencies()
    {
        super.didChangeDependencies();
        final l10n = AppLocalizations.of(context)!;

        _visibilityOptions = [l10n.privateAccount, l10n.publicAccount];
        _publicOptions = [l10n.allUsers, l10n.verifiedVendorsOnly, l10n.myGroupsOnly];

        _visibilityKeys =
        {
            l10n.privateAccount: 'Private Account',
            l10n.publicAccount: 'Public Account',
        };
        _publicOptionKeys =
        {
            l10n.allUsers: 'All Users',
            l10n.verifiedVendorsOnly: 'Verified Vendors Only',
            l10n.myGroupsOnly: 'My Groups Only',
        };
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
                    l10n.profileVisibilityTitle,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                actions: const[SizedBox(width: 56)],
            ),

            body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(
                            l10n.accountVisibility,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),

                        DropdownButtonFormField<String>(
                            value: _visibilityOptions[_visibilityKeys.values.toList().indexOf(_selectedVisibility)],
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
                            items: _visibilityOptions.map((String value)
                                {
                                    return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                    );
                                }
                            ).toList(),
                            onChanged: (newValue)
                            {
                                if (newValue != null)
                                {
                                    setState(()
                                        {
                                            _selectedVisibility = _visibilityKeys[newValue]!;
                                        }
                                    );
                                }
                            },
                        ),
                        const SizedBox(height: 24),

                        AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: _selectedVisibility == 'Private Account'
                                ? _buildPrivateView()
                                : _buildPublicView(),
                        ),
                    ],
                ),
            ),
        );
    }

    Widget _buildPrivateView()
    {
        final l10n = AppLocalizations.of(context)!;
        return KeyedSubtree(
            key: const ValueKey('privateView'),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        l10n.privateAccountInfo,
                        style: const TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Text(
                        l10n.privateAccountSuggestion,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                ],
            ),
        );
    }

    Widget _buildPublicView()
    {
        final l10n = AppLocalizations.of(context)!;
        return KeyedSubtree(
            key: const ValueKey('publicView'),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(
                        l10n.publicAccountInfo,
                        style: const TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    ..._publicOptions.map((option) => _buildRadioOption(option)),
                ],
            ),
        );
    }

    Widget _buildRadioOption(String title)
    {
        return RadioListTile<String>(
            title: Text(title, style: const TextStyle(fontSize: 15)),
            value: _publicOptionKeys[title]!,
            groupValue: _selectedPublicOption,
            onChanged: (newValue)
            {
                if (newValue != null)
                {
                    setState(()
                        {
                            _selectedPublicOption = newValue;
                        }
                    );
                }
            },
            activeColor: Colors.red,
            contentPadding: EdgeInsets.zero,
        );
    }
}
