import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget
{
    const CustomTextField({
        super.key,
        this.controller,
        required this.hintText,
        this.keyboardType,
        this.inputFormatters,
        this.onChanged,
        this.suffixIcon, // 1. Added new optional property
    });

    final TextEditingController? controller;
    final String hintText;
    final TextInputType? keyboardType;
    final List<TextInputFormatter>? inputFormatters;
    final ValueChanged<String>? onChanged;
    final Widget? suffixIcon; // 2. Defined the property

    @override
    Widget build(BuildContext context)
    {
        return TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            decoration: InputDecoration(
                hintText: hintText,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                suffixIcon: suffixIcon, // 3. Used the property here
            ),
        );
    }
}
