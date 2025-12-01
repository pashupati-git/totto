import 'package:flutter/material.dart';

class FloatingAppBar extends StatelessWidget
{
    const FloatingAppBar({
        super.key,
        this.title,
        this.leading,
        this.actions,
        this.height = 100.0, // Default height to match your design
    });

    final Widget? title;
    final Widget? leading;
    final List<Widget>? actions;
    final double height;

    @override
    Widget build(BuildContext context)
    {
        // The main container that provides the styling
        return Container(
            height: height,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                    ),
                ],
            ),
            // SafeArea ensures the content is below the device's status bar
            child: SafeArea(
                // We use a Row to manually position the leading, title, and actions
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                        // If a leading widget is provided, display it
                        if (leading != null) leading!,

                        // The title takes up the remaining space
                        if (title != null)
                        Expanded(
                            child: Center(
                                // By wrapping the title in Center inside an Expanded widget,
                                // it will correctly center itself in the available space.
                                child: title!,
                            ),
                        ),

                        // If actions are provided, display them
                        if (actions != null) Row(children: actions!),
                    ],
                ),
            ),
        );
    }
}
