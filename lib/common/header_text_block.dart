import 'package:flutter/material.dart';
import 'package:totto/l10n/app_localizations.dart';

class HeaderTextBlock extends StatelessWidget
{
    const HeaderTextBlock({super.key});

    @override
    Widget build(BuildContext context)
    {
        final l10n = AppLocalizations.of(context)!;
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
                children: [
                    Text.rich(
                        TextSpan(
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                            children: <TextSpan>[
                                TextSpan(text: l10n.homeHeaderTitlePart1),
                                TextSpan(text: l10n.homeHeaderTitlePart2, style: const TextStyle(color: Color(0xFFdc153c))),
                            ],
                        ),
                        textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                        l10n.homeHeaderSubtitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                ],
            ),
        );
    }
}
