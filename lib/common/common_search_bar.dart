import 'package:flutter/material.dart';

// A reusable search bar that can be used as a text input or a tappable button.
class CommonSearchBar extends StatelessWidget
{
    const CommonSearchBar({
        super.key,
        this.controller,
        this.onChanged,
        this.onSubmitted,
        this.hintText = 'Search',
        this.readOnly = false,
        this.onTap,
    });

    final TextEditingController? controller;
    final ValueChanged<String>? onChanged;
    final ValueChanged<String>? onSubmitted;
    final String hintText;
    final bool readOnly;
    final VoidCallback? onTap;

    @override
    Widget build(BuildContext context)
    {
        const outlineInputBorder = OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            borderSide: BorderSide(color: Color(0xFFDC143C)),
        );

        return Material(
          color:Colors.transparent,
          child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              readOnly: readOnly, // 3. Pass properties to the TextField
              onTap: onTap,
              decoration: InputDecoration(
                  hintText: hintText,
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  enabledBorder: outlineInputBorder,
                  focusedBorder: outlineInputBorder,
                  fillColor: Colors.white,
                  filled: true,
              ),
          ),
        );
    }
}
