import 'package:flutter/material.dart';

class RoundedAvatar extends StatelessWidget {
  const RoundedAvatar({
    Key? key,
    this.icon,
    this.image,
    this.text,
    this.textStyle,
    this.child,
    this.onTap,
    this.radius = 24.0,
    this.padding = const EdgeInsets.all(8.0),
    this.backgroundColor = Colors.white,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.iconSize = 24.0,
  }) : super(key: key);

  final IconData? icon;
  final ImageProvider? image;
  final String? text;
  final TextStyle? textStyle;
  final Widget? child;
  final VoidCallback? onTap;
  final double radius;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final double iconSize;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final textToDisplay = text?.trim()[0];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: padding,
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Builder(
          builder: (_) {
            if (image != null) {
              return Image(image: image!);
            }

            if (icon != null) {
              return Icon(
                icon,
                color: iconColor,
                size: iconSize,
              );
            }

            if (child != null) {
              return child!;
            }

            if (text != null) {
              return Text(
                textToDisplay!,
                style: textStyle ??
                    TextStyle(
                      fontSize: 18,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
              );
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
