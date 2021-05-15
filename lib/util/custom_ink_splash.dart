import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

const Duration _kCircleRadiusDuration = Duration(milliseconds: 750);
const Duration _kRectCircleFadeInDuration = Duration(milliseconds: 375);
const Duration _kRectCircleFadeOutDuration = Duration(milliseconds: 375);
const double _kSplashInitialSize = 0.0;

RectCallback? _getClipCallback(
    RenderBox referenceBox, bool containedInkWell, RectCallback? rectCallback) {
  if (rectCallback != null) {
    assert(containedInkWell);
    return rectCallback;
  }
  if (containedInkWell) return () => Offset.zero & referenceBox.size;
  return null;
}

double _getTargetRadius(RenderBox referenceBox, bool containedInkWell,
    RectCallback? rectCallback, Offset position) {
  if (containedInkWell) {
    final Size size =
        rectCallback != null ? rectCallback().size : referenceBox.size;
    return _getSplashRadiusForPositionInSize(size, position);
  }
  return Material.defaultSplashRadius;
}

double _getSplashRadiusForPositionInSize(Size bounds, Offset position) {
  final double d1 = (position - bounds.topLeft(Offset.zero)).distance;
  final double d2 = (position - bounds.topRight(Offset.zero)).distance;
  final double d3 = (position - bounds.bottomLeft(Offset.zero)).distance;
  final double d4 = (position - bounds.bottomRight(Offset.zero)).distance;
  return math.max(math.max(d1, d2), math.max(d3, d4)).ceilToDouble();
}

class _InkSplashFactory extends InteractiveInkFeatureFactory {
  const _InkSplashFactory();

  @override
  InteractiveInkFeature create({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required Offset position,
    required Color color,
    required TextDirection textDirection,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  }) {
    return CustomInkSplash(
      controller: controller,
      referenceBox: referenceBox,
      position: position,
      color: color,
      containedInkWell: containedInkWell,
      rectCallback: rectCallback,
      borderRadius: borderRadius,
      customBorder: customBorder,
      radius: radius,
      onRemoved: onRemoved,
      textDirection: textDirection,
    );
  }
}

class CustomInkSplash extends InteractiveInkFeature {
  final Offset? _position;
  final BorderRadius _borderRadius;
  final ShapeBorder? _customBorder;
  final RectCallback? _clipCallback;
  final TextDirection _textDirection;
  final double _targetRadius;
  final bool _repositionToReferenceBox;

  late AnimationController _circleRadiusController;
  late Animation<double> _radius;

  late AnimationController _rectFadeInController;
  late Animation<double> _rectFadeIn;

  late AnimationController _rectCircleFadeInOutController;
  late Animation<double> _rectCircleFadeOut;

  final CurveTween _easeCurveTween = CurveTween(curve: Curves.ease);

  static const InteractiveInkFeatureFactory splashFactory = _InkSplashFactory();

  CustomInkSplash({
    required MaterialInkController controller,
    required RenderBox referenceBox,
    required TextDirection textDirection,
    Offset? position,
    required Color color,
    bool containedInkWell = false,
    RectCallback? rectCallback,
    BorderRadius? borderRadius,
    ShapeBorder? customBorder,
    double? radius,
    VoidCallback? onRemoved,
  })  : _position = position,
        _borderRadius = borderRadius ?? BorderRadius.zero,
        _customBorder = customBorder,
        _targetRadius = radius ??
            _getTargetRadius(
                referenceBox, containedInkWell, rectCallback, position!),
        _clipCallback =
            _getClipCallback(referenceBox, containedInkWell, rectCallback),
        _repositionToReferenceBox = !containedInkWell,
        _textDirection = textDirection,
        super(
            controller: controller,
            referenceBox: referenceBox,
            color: color,
            onRemoved: onRemoved) {
    _circleRadiusController = AnimationController(
        duration: _kCircleRadiusDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint);
    _radius = _circleRadiusController.drive(Tween<double>(
      begin: _kSplashInitialSize,
      end: _targetRadius * 0.6,
    ).chain(_easeCurveTween));

    _rectFadeInController = AnimationController(
        duration: _kRectCircleFadeInDuration, vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..forward();
    _rectFadeIn = _rectFadeInController.drive(Tween<double>(
      begin: 0,
      end: color.opacity,
    ).chain(_easeCurveTween));

    _rectCircleFadeInOutController = AnimationController(
        duration: _kRectCircleFadeInDuration + _kRectCircleFadeOutDuration,
        vsync: controller.vsync)
      ..addListener(controller.markNeedsPaint)
      ..addStatusListener(_handleAlphaStatusChanged);
    _rectCircleFadeOut = _rectCircleFadeInOutController.drive(Tween<double>(
      begin: color.opacity,
      end: 0,
    ).chain(_easeCurveTween));

    controller.addInkFeature(this);
  }

  @override
  void confirm() {
    _circleRadiusController.forward();
    _rectCircleFadeInOutController.forward();
    _rectFadeInController.stop();
  }

  @override
  void cancel() {
    confirm();
  }

  void _handleAlphaStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) dispose();
  }

  @override
  void dispose() {
    _circleRadiusController.dispose();
    _rectFadeInController.dispose();
    _rectCircleFadeInOutController.dispose();
    super.dispose();
  }

  @override
  void paintFeature(Canvas canvas, Matrix4 transform) {
    double rectCircleOpacity = color.opacity;
    if (_rectFadeInController.isAnimating)
      rectCircleOpacity = _rectFadeIn.value;
    else if (_rectCircleFadeInOutController.isAnimating)
      rectCircleOpacity = _rectCircleFadeOut.value;

    final Paint rectPaint = Paint()
      ..color = Color.fromRGBO(
          color.red, color.green, color.blue, rectCircleOpacity / 2.0);

    final Paint circlePaint = Paint()
      ..color =
          Color.fromRGBO(color.red, color.green, color.blue, rectCircleOpacity);

    Offset? center = _position;
    if (_repositionToReferenceBox)
      center = Offset.lerp(center, referenceBox.size.center(Offset.zero),
          _circleRadiusController.value);

    _paintHighlightRect(
      canvas: canvas,
      transform: transform,
      paint: rectPaint,
      textDirection: _textDirection,
      customBorder: _customBorder,
      borderRadius: _borderRadius,
      clipCallback: _clipCallback,
    );

    paintInkCircle(
      canvas: canvas,
      transform: transform,
      paint: circlePaint,
      center: center!,
      textDirection: _textDirection,
      radius: _radius.value,
      customBorder: _customBorder,
      borderRadius: _borderRadius,
      clipCallback: _clipCallback,
    );
  }

  void _paintHighlightRect({
    required Canvas canvas,
    required Matrix4 transform,
    required Paint paint,
    TextDirection? textDirection,
    ShapeBorder? customBorder,
    BorderRadius borderRadius = BorderRadius.zero,
    RectCallback? clipCallback,
  }) {
    final Offset? originOffset = MatrixUtils.getAsTranslation(transform);
    canvas.save();
    if (originOffset == null) {
      canvas.transform(transform.storage);
    } else {
      canvas.translate(originOffset.dx, originOffset.dy);
    }
    if (clipCallback != null) {
      final Rect rect = clipCallback();
      if (customBorder != null) {
        canvas.clipPath(
            customBorder.getOuterPath(rect, textDirection: textDirection));
      } else if (borderRadius != BorderRadius.zero) {
        canvas.clipRRect(RRect.fromRectAndCorners(
          rect,
          topLeft: borderRadius.topLeft,
          topRight: borderRadius.topRight,
          bottomLeft: borderRadius.bottomLeft,
          bottomRight: borderRadius.bottomRight,
        ));
      } else {
        canvas.clipRect(rect);
      }
      canvas.drawRect(
        Rect.fromLTWH(0, 0, referenceBox.size.width, referenceBox.size.height),
        paint,
      );
    }
    canvas.restore();
  }
}
