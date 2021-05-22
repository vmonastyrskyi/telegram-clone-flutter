import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:telegram_clone_mobile/util/sticky_sliver.dart';
import 'package:telegram_clone_mobile/util/value_layout_builder.dart';

class RenderStickySliver extends RenderSliver with RenderSliverHelpers {
  RenderStickySliver({
    RenderObject? header,
    RenderSliver? child,
    bool overlapsContent: false,
    bool sticky: true,
    StickySliverController? controller,
  })  : _overlapsContent = overlapsContent,
        _sticky = sticky,
        _controller = controller {
    this.header = header as RenderBox?;
    this.child = child;
  }

  StickySliverState? _oldState;
  double? _headerExtent;
  late bool _isPinned;

  bool get overlapsContent => _overlapsContent;
  bool _overlapsContent;

  set overlapsContent(bool value) {
    if (_overlapsContent == value) return;
    _overlapsContent = value;
    markNeedsLayout();
  }

  bool get sticky => _sticky;
  bool _sticky;

  set sticky(bool value) {
    if (_sticky == value) return;
    _sticky = value;
    markNeedsLayout();
  }

  StickySliverController? get controller => _controller;
  StickySliverController? _controller;

  set controller(StickySliverController? value) {
    if (_controller == value) return;
    if (_controller != null && value != null) {
      value.stickyHeaderScrollOffset = _controller!.stickyHeaderScrollOffset;
    }
    _controller = value;
  }

  RenderBox? get header => _header;
  RenderBox? _header;

  set header(RenderBox? value) {
    if (_header != null) dropChild(_header!);
    _header = value;
    if (_header != null) adoptChild(_header!);
  }

  RenderSliver? get child => _child;
  RenderSliver? _child;

  set child(RenderSliver? value) {
    if (_child != null) dropChild(_child!);
    _child = value;
    if (_child != null) adoptChild(_child!);
  }

  @override
  void setupParentData(RenderObject child) {
    if (child.parentData is! SliverPhysicalParentData)
      child.parentData = SliverPhysicalParentData();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    if (_header != null) _header!.attach(owner);
    if (_child != null) _child!.attach(owner);
  }

  @override
  void detach() {
    super.detach();
    if (_header != null) _header!.detach();
    if (_child != null) _child!.detach();
  }

  @override
  void redepthChildren() {
    if (_header != null) redepthChild(_header!);
    if (_child != null) redepthChild(_child!);
  }

  @override
  void visitChildren(RenderObjectVisitor visitor) {
    if (_header != null) visitor(_header!);
    if (_child != null) visitor(_child!);
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    List<DiagnosticsNode> result = <DiagnosticsNode>[];
    if (header != null) {
      result.add(header!.toDiagnosticsNode(name: 'header'));
    }
    if (child != null) {
      result.add(child!.toDiagnosticsNode(name: 'child'));
    }
    return result;
  }

  double computeHeaderExtent() {
    if (header == null) return 0.0;
    assert(header!.hasSize);
    switch (constraints.axis) {
      case Axis.vertical:
        return header!.size.height;
      case Axis.horizontal:
        return header!.size.width;
    }
  }

  double? get headerLogicalExtent => overlapsContent ? 0.0 : _headerExtent;

  @override
  void performLayout() {
    if (header == null && child == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    AxisDirection axisDirection = applyGrowthDirectionToAxisDirection(
        constraints.axisDirection, constraints.growthDirection);

    if (header != null) {
      header!.layout(
        BoxValueConstraints<StickySliverState>(
          value: _oldState ?? StickySliverState(0.0, false),
          constraints: constraints.asBoxConstraints(),
        ),
        parentUsesSize: true,
      );
      _headerExtent = computeHeaderExtent();
    }

    double headerExtent = headerLogicalExtent!;
    final double headerPaintExtent =
        calculatePaintOffset(constraints, from: 0.0, to: headerExtent);
    final double headerCacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: headerExtent);

    if (child == null) {
      geometry = SliverGeometry(
          scrollExtent: headerExtent,
          maxPaintExtent: headerExtent,
          paintExtent: headerPaintExtent,
          cacheExtent: headerCacheExtent,
          hitTestExtent: headerPaintExtent,
          hasVisualOverflow: headerExtent > constraints.remainingPaintExtent ||
              constraints.scrollOffset > 0.0);
    } else {
      child!.layout(
        constraints.copyWith(
          scrollOffset: math.max(0.0, constraints.scrollOffset - headerExtent),
          cacheOrigin: math.min(0.0, constraints.cacheOrigin + headerExtent),
          overlap: 0.0,
          remainingPaintExtent:
              constraints.remainingPaintExtent - headerPaintExtent,
          remainingCacheExtent:
              constraints.remainingCacheExtent - headerCacheExtent,
        ),
        parentUsesSize: true,
      );
      final SliverGeometry childLayoutGeometry = child!.geometry!;
      if (childLayoutGeometry.scrollOffsetCorrection != null) {
        geometry = SliverGeometry(
          scrollOffsetCorrection: childLayoutGeometry.scrollOffsetCorrection,
        );
        return;
      }

      final double paintExtent = math.min(
        headerPaintExtent +
            math.max(childLayoutGeometry.paintExtent,
                childLayoutGeometry.layoutExtent),
        constraints.remainingPaintExtent,
      );

      geometry = SliverGeometry(
        scrollExtent: headerExtent + childLayoutGeometry.scrollExtent,
        paintExtent: paintExtent,
        layoutExtent: math.min(
            headerPaintExtent + childLayoutGeometry.layoutExtent, paintExtent),
        cacheExtent: math.min(
            headerCacheExtent + childLayoutGeometry.cacheExtent,
            constraints.remainingCacheExtent),
        maxPaintExtent: headerExtent + childLayoutGeometry.maxPaintExtent,
        hitTestExtent: math.max(
            headerPaintExtent + childLayoutGeometry.paintExtent,
            headerPaintExtent + childLayoutGeometry.hitTestExtent),
        hasVisualOverflow: childLayoutGeometry.hasVisualOverflow,
      );

      final SliverPhysicalParentData? childParentData =
          child!.parentData as SliverPhysicalParentData?;
      switch (axisDirection) {
        case AxisDirection.up:
          childParentData!.paintOffset = Offset.zero;
          break;
        case AxisDirection.right:
          childParentData!.paintOffset = Offset(
              calculatePaintOffset(constraints, from: 0.0, to: headerExtent),
              0.0);
          break;
        case AxisDirection.down:
          childParentData!.paintOffset = Offset(0.0,
              calculatePaintOffset(constraints, from: 0.0, to: headerExtent));
          break;
        case AxisDirection.left:
          childParentData!.paintOffset = Offset.zero;
          break;
      }
    }

    if (header != null) {
      final SliverPhysicalParentData? headerParentData =
          header!.parentData as SliverPhysicalParentData?;
      final double childScrollExtent = child?.geometry?.scrollExtent ?? 0.0;
      final double headerPosition = sticky
          ? math.min(
              constraints.overlap,
              childScrollExtent -
                  constraints.scrollOffset -
                  (overlapsContent ? _headerExtent! : 0.0))
          : -constraints.scrollOffset;

      _isPinned = sticky &&
          ((constraints.scrollOffset + constraints.overlap) > 0.0 ||
              constraints.remainingPaintExtent ==
                  constraints.viewportMainAxisExtent);

      final double headerScrollRatio =
          ((headerPosition - constraints.overlap).abs() / _headerExtent!);
      if (_isPinned && headerScrollRatio <= 1) {
        controller?.stickyHeaderScrollOffset =
            constraints.precedingScrollExtent;
      }

      if (header is RenderConstrainedLayoutBuilder<
          BoxValueConstraints<StickySliverState>, RenderBox>) {
        double headerScrollRatioClamped = headerScrollRatio.clamp(0.0, 1.0);

        StickySliverState state =
            StickySliverState(headerScrollRatioClamped, _isPinned);
        if (_oldState != state) {
          _oldState = state;
          header!.layout(
            BoxValueConstraints<StickySliverState?>(
              value: _oldState,
              constraints: constraints.asBoxConstraints(),
            ),
            parentUsesSize: true,
          );
        }
      }

      switch (axisDirection) {
        case AxisDirection.up:
          headerParentData!.paintOffset = Offset(
              0.0, geometry!.paintExtent - headerPosition - _headerExtent!);
          break;
        case AxisDirection.down:
          headerParentData!.paintOffset = Offset(0.0, headerPosition);
          break;
        case AxisDirection.left:
          headerParentData!.paintOffset = Offset(
              geometry!.paintExtent - headerPosition - _headerExtent!, 0.0);
          break;
        case AxisDirection.right:
          headerParentData!.paintOffset = Offset(headerPosition, 0.0);
          break;
      }
    }
  }

  @override
  bool hitTestChildren(SliverHitTestResult result,
      {required double mainAxisPosition, required double crossAxisPosition}) {
    assert(geometry!.hitTestExtent > 0.0);
    if (header != null &&
        mainAxisPosition - constraints.overlap <= _headerExtent!) {
      return hitTestBoxChild(
            BoxHitTestResult.wrap(SliverHitTestResult.wrap(result)),
            header!,
            mainAxisPosition: mainAxisPosition - constraints.overlap,
            crossAxisPosition: crossAxisPosition,
          ) ||
          (_overlapsContent &&
              child != null &&
              child!.geometry!.hitTestExtent > 0.0 &&
              child!.hitTest(result,
                  mainAxisPosition:
                      mainAxisPosition - childMainAxisPosition(child),
                  crossAxisPosition: crossAxisPosition));
    } else if (child != null && child!.geometry!.hitTestExtent > 0.0) {
      return child!.hitTest(result,
          mainAxisPosition: mainAxisPosition - childMainAxisPosition(child),
          crossAxisPosition: crossAxisPosition);
    }
    return false;
  }

  @override
  double childMainAxisPosition(RenderObject? child) {
    if (child == header)
      return _isPinned
          ? 0.0
          : -(constraints.scrollOffset + constraints.overlap);
    if (child == this.child)
      return calculatePaintOffset(constraints,
          from: 0.0, to: headerLogicalExtent!);
    return 0;
  }

  @override
  double? childScrollOffset(RenderObject child) {
    assert(child.parent == this);
    if (child == this.child) {
      return _headerExtent;
    } else {
      return super.childScrollOffset(child);
    }
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    final SliverPhysicalParentData childParentData =
        child.parentData as SliverPhysicalParentData;
    childParentData.applyPaintTransform(transform);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (geometry!.visible) {
      if (child != null && child!.geometry!.visible) {
        final SliverPhysicalParentData childParentData =
            child!.parentData as SliverPhysicalParentData;
        context.paintChild(child!, offset + childParentData.paintOffset);
      }

      if (header != null) {
        final SliverPhysicalParentData headerParentData =
            header!.parentData as SliverPhysicalParentData;
        context.paintChild(header!, offset + headerParentData.paintOffset);
      }
    }
  }
}
