import 'package:flutter/material.dart';

class AppBarIconButton extends StatelessWidget {
  const AppBarIconButton({
    Key? key,
    required this.icon,
    required this.onPressed,
    this.iconColor = Colors.white,
    this.iconSize = 24,
    this.contentPadding = const EdgeInsets.all(8),
    this.margin = const EdgeInsets.symmetric(horizontal: 4),
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onPressed;
  final Color iconColor;
  final double iconSize;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Center(
        child: InkWell(
          customBorder: CircleBorder(),
          onTap: onPressed,
          child: Padding(
            padding: contentPadding,
            child: Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
