import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget
{
    const PrimaryButton({
        super.key,
        required this.text,
        this.onPressed,
        this.isLoading = false,
        this.borderRadius = 30.0,
        this.icon,
    });

    final String text;
    final VoidCallback? onPressed;
    final bool isLoading;
    final double borderRadius;
    final Widget? icon;

    ButtonStyle _buttonStyle()
    {
        return ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFdc153c),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
            ),
        );
    }

    @override
    Widget build(BuildContext context)
    {
        return SizedBox(
            width: double.infinity,
            child: isLoading
                ? ElevatedButton(
                    onPressed: null,
                    style: _buttonStyle(),
                    child: const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                        ),
                    ),
                )
                : (icon != null
                    ? ElevatedButton.icon(
                        icon: icon!,
                        label: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
                        onPressed: onPressed,
                        style: _buttonStyle(),
                    )
                    : ElevatedButton(
                        onPressed: onPressed,
                        style: _buttonStyle(),
                        child: Text(text, style: const TextStyle(fontSize: 16, color: Colors.white)),
                    )),
        );
    }
}
