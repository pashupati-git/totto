import 'package:flutter/material.dart';

// A reusable, custom-styled AppBar for standard screens.
// It has been made flexible to handle different styles across the app.
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.height = 100.0,
    // 1. Added new optional parameters for customization
    this.backgroundColor = Colors.white,
    this.elevation = 5,
    this.shape,
  });

  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final double height;
  final Color backgroundColor;
  final double elevation;
  final ShapeBorder? shape; // Making shape optional

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: height,
      // 2. Use the new flexible properties here
      backgroundColor: backgroundColor,
      elevation: elevation,
      shadowColor: elevation > 0 ? Colors.black.withOpacity(0.05) : null,
      // Use the provided shape, or default to the rounded one
      shape:
          shape ??
          const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
          ),

      title: title,
      leading: leading,
      actions: actions,
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}
