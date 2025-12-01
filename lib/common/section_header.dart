import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget
{
    const SectionHeader({super.key, required this.title});

    final String title;

    @override
    Widget build(BuildContext context)
    {
        return Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 24.0),
            child: Text(
                title,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                ),
            ),
        );
    }
}
