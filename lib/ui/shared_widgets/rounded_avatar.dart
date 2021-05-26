import 'package:flutter/material.dart';

class RoundedAvatar extends StatelessWidget {
  const RoundedAvatar({
    Key? key,
    this.image,
    this.text,
    this.textStyle,
    this.child,
    this.onTap,
    this.radius = 24,
    this.padding = const EdgeInsets.all(8),
    this.backgroundColor = Colors.white,
    this.textColor = Colors.white,
  }) : super(key: key);

  final ImageProvider? image;
  final String? text;
  final TextStyle? textStyle;
  final Widget? child;
  final VoidCallback? onTap;
  final double radius;
  final Color backgroundColor;
  final Color textColor;
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
            if (image != null)
              return Image(
                image: image!,
              );

            if (child != null) return child!;

            if (text != null)
              return Text(
                textToDisplay!,
                style: textStyle ??
                    TextStyle(
                      fontSize: 18,
                      color: textColor,
                      fontWeight: FontWeight.w500,
                    ),
              );

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
