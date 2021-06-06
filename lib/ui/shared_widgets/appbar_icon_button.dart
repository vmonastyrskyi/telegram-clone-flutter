import 'package:flutter/material.dart';

class AppBarIconButton extends StatelessWidget {
  const AppBarIconButton({
    Key? key,
    required this.icon,
    required this.onTap,
    this.iconColor = Colors.white,
    this.iconSize = 24,
    this.contentPadding = const EdgeInsets.all(8),
    this.margin = const EdgeInsets.symmetric(horizontal: 4),
    this.splashEffect = true,
  }) : super(key: key);

  final IconData icon;
  final VoidCallback onTap;
  final Color iconColor;
  final double iconSize;
  final EdgeInsetsGeometry contentPadding;
  final EdgeInsetsGeometry margin;
  final bool splashEffect;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Center(
        child: splashEffect
            ? InkWell(
                customBorder: CircleBorder(),
                onTap: onTap,
                child: Padding(
                  padding: contentPadding,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: iconSize,
                  ),
                ),
              )
            : GestureDetector(
                onTap: onTap,
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
