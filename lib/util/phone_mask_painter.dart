import 'package:flutter/material.dart';

class PhoneMaskPainter extends CustomPainter {
  static const double _kCharGap = 2.0;
  static const double _kCharWidth = 8.0;
  static const double _kCharHeight = 2.0;
  static const double _kSpaceWidth = 3.0;

  String mask = '';
  String text = '';

  void changeMask(String mask) {
    this.mask = mask;
  }

  void fill(String text) {
    this.text = text;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color.fromARGB(255, 125, 138, 147)
      ..style = PaintingStyle.fill;

    double charPositionX = 1.0;

    charPositionX += _kCharGap * text.replaceAll(' ', '').length -
        (_kSpaceWidth * ' '.allMatches(text).length);

    for (int i = text.length; i < mask.length; i++) {
      if (mask[i] != ' ') {
        Path path = Path();
        path.moveTo(charPositionX + (i * _kCharWidth), 0.0);
        path.lineTo(charPositionX + (i * _kCharWidth) + _kCharWidth, 0.0);
        path.lineTo(
            charPositionX + (i * _kCharWidth) + _kCharWidth, _kCharHeight);
        path.lineTo(charPositionX + (i * _kCharWidth), _kCharHeight);
        path.close();

        canvas.drawPath(path, paint);

        charPositionX += _kCharGap;
      } else {
        charPositionX -= _kSpaceWidth;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
