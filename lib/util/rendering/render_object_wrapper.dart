import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class RenderManager<T> {
  final _renderObjects = <T, RenderBoxWrapper>{};

  RenderBoxWrapper? operator [](T id) {
    return _renderObjects[id];
  }

  void addRenderObject(T id, RenderObject renderObject) {
    _renderObjects[id] = renderObject as RenderBoxWrapper;
  }

  void updateRenderObject(T id, RenderObject renderObject) {
    _renderObjects[id] = renderObject as RenderBoxWrapper;
  }

  RenderBoxWrapper? getRenderObject(T id) {
    return _renderObjects[id];
  }

  RenderData? getRenderData(T id) {
    return getRenderObject(id)?.data;
  }

  void removeRenderObject(T id) {
    _renderObjects.remove(id);
  }
}

typedef MountCallback<T> = void Function(T id, RenderBoxWrapper renderBox);
typedef UnmountCallback<T> = void Function(T id);

class RenderObjectWrapper<T> extends SingleChildRenderObjectWidget {
  const RenderObjectWrapper({
    required this.id,
    required this.manager,
    this.onMount,
    this.onUnmount,
    Key? key,
    Widget? child,
  }) : super(key: key, child: child);

  final T id;
  final RenderManager manager;
  final MountCallback<T>? onMount;
  final UnmountCallback<T>? onUnmount;

  @override
  RenderBoxWrapper createRenderObject(BuildContext context) {
    final renderBox = RenderBoxWrapper();
    manager.addRenderObject(id, renderBox);
    onMount?.call(id, renderBox);
    return renderBox;
  }

  @override
  void didUnmountRenderObject(covariant RenderObject renderObject) {
    manager.removeRenderObject(id);
    onUnmount?.call(id);
  }
}

class RenderBoxWrapper extends RenderProxyBox {
  RenderBoxWrapper({RenderBox? child}) : super(child);

  RenderData get data {
    final Size size = this.size;
    final double width = size.width;
    final double height = size.height;
    final Offset globalOffset = localToGlobal(Offset(width, height));
    final double dy = globalOffset.dy;
    final double dx = globalOffset.dx;

    return RenderData(
      yTop: dy - height,
      yBottom: dy,
      yCenter: dy - height / 2,
      xLeft: dx - width,
      xRight: dx,
      xCenter: dx - width / 2,
      width: width,
      height: height,
    );
  }
}

/// Widget metric data class
/// [yTop] - top Y position relative to the screen
/// [yBottom] - lower Y position relative to the screen
/// [yCenter] - center Y position relative to the screen
/// [xLeft] - left X position relative to the screen
/// [xRight] - right X position relative to the screen
/// [xCenter] - center X position relative to the screen
/// [width] - element width
/// [height] - element height
/// [topLeft] - upper left coordinate
/// [topRight] - upper right coordinate
/// [bottomLeft] - lower left coordinate
/// [bottomRight] - lower right coordinate
/// [center] - central coordinate
/// [topCenter] - upper center coordinate
/// [bottomCenter] - lower central coordinate
/// [centerLeft] - center left coordinate
/// [centerRight] - center right coordinate
@immutable
class RenderData {
  const RenderData({
    required this.yTop,
    required this.yBottom,
    required this.yCenter,
    required this.xLeft,
    required this.xRight,
    required this.xCenter,
    required this.width,
    required this.height,
  });

  final double yTop;
  final double yBottom;
  final double yCenter;
  final double xLeft;
  final double xRight;
  final double xCenter;
  final double width;
  final double height;

  CoordsMetrics get topLeft => CoordsMetrics(y: yTop, x: xLeft);

  CoordsMetrics get topRight => CoordsMetrics(y: yTop, x: xRight);

  CoordsMetrics get bottomLeft => CoordsMetrics(y: yBottom, x: xLeft);

  CoordsMetrics get bottomRight => CoordsMetrics(y: yBottom, x: xRight);

  CoordsMetrics get center => CoordsMetrics(y: yCenter, x: xCenter);

  CoordsMetrics get topCenter => CoordsMetrics(y: yTop, x: xCenter);

  CoordsMetrics get bottomCenter => CoordsMetrics(y: yBottom, x: xCenter);

  CoordsMetrics get centerLeft => CoordsMetrics(y: yCenter, x: xLeft);

  CoordsMetrics get centerRight => CoordsMetrics(y: yCenter, x: xRight);

  @override
  String toString() {
    return 'RenderData(\n'
        '    yTop = $yTop;\n'
        '    yBottom = $yBottom;\n'
        '    yCenter = $yCenter;\n'
        '    xLeft = $xLeft;\n'
        '    xRight = $xRight;\n'
        '    xCenter = $xCenter;\n'
        '    width = $width;\n'
        '    height = $height;\n'
        ')';
  }
}

@immutable
class CoordsMetrics {
  const CoordsMetrics({
    required this.x,
    required this.y,
  });

  final double x;
  final double y;
}
