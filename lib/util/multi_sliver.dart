import 'package:flutter/widgets.dart';
import 'package:telegram_clone_mobile/util/rendering/render_multi_sliver.dart';

class MultiSliver extends MultiChildRenderObjectWidget {
  MultiSliver({
    Key? key,
    required List<Widget> children,
    this.pushPinnedChildren = false,
  }) : super(key: key, children: children);

  final bool pushPinnedChildren;

  @override
  RenderMultiSliver createRenderObject(BuildContext context) =>
      RenderMultiSliver(containing: pushPinnedChildren);

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderMultiSliver renderObject) {
    renderObject.containing = pushPinnedChildren;
  }
}
