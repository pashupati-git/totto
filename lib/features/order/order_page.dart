
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:totto/features/chat/chat_page.dart';
import 'package:totto/l10n/app_localizations.dart';
import 'package:totto/common/appbar/common_app_bar.dart';

class OrderPage extends ConsumerWidget {
    const OrderPage({super.key});

    @override
    Widget build(BuildContext context, WidgetRef ref) {
        final l10n = AppLocalizations.of(context)!;

        return Scaffold(
            backgroundColor: const Color(0xFFF1F2F6),
            appBar: CommonAppBar(
                height: 60.0,
                backgroundColor: const Color(0xFFF1F2F6),
                elevation: 0,
                leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => const ChatPage()),
                    ),
                ),
                title: Text(l10n.myOrderTitle,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            body: const Center(
                child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                            Icon(
                                Icons.forum_outlined,
                                size: 80,
                                color: Colors.grey,
                            ),
                            SizedBox(height: 24),
                            Text(
                                "All orders are now shown inside their relative groups.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    height: 1.5,
                                ),
                            ),
                        ],
                    ),
                ),
            ),
        );
    }
}