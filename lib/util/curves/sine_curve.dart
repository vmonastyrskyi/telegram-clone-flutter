import 'dart:math';

import 'package:flutter/material.dart';

class SineCurve extends Curve {
  SineCurve({this.waves = 3});

  final int waves;

  @override
  double transformInternal(double t) {
    return -sin(waves * 2 * pi * t);
  }
}
