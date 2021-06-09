import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:telegram_clone_mobile/util/rendering/render_sticky_list_item.dart';
import 'package:telegram_clone_mobile/util/value_layout_builder.dart';

typedef Widget StickySliverWidgetBuilder(
  BuildContext context,
  StickySliverState state,
);

class StickySliverController with ChangeNotifier {
  double get stickyHeaderScrollOffset => _stickyHeaderScrollOffset;
  double _stickyHeaderScrollOffset = 0;

  set stickyHeaderScrollOffset(double value) {
    if (_stickyHeaderScrollOffset != value) {
      _stickyHeaderScrollOffset = value;
      notifyListeners();
    }
  }
}

class DefaultStickySliverController extends StatefulWidget {
  const DefaultStickySliverController({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  static StickySliverController? of(BuildContext context) {
    final _StickySliverControllerScope? scope = context
        .dependOnInheritedWidgetOfExactType<_StickySliverControllerScope>();
    return scope?.controller;
  }

  @override
  _DefaultStickySliverControllerState createState() =>
      _DefaultStickySliverControllerState();
}

class _DefaultStickySliverControllerState
    extends State<DefaultStickySliverController> {
  StickySliverController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = StickySliverController();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _StickySliverControllerScope(
      controller: _controller,
      child: widget.child,
    );
  }
}

class _StickySliverControllerScope extends InheritedWidget {
  const _StickySliverControllerScope({
    Key? key,
    this.controller,
    required Widget child,
  }) : super(key: key, child: child);

  final StickySliverController? controller;

  @override
  bool updateShouldNotify(_StickySliverControllerScope old) {
    return controller != old.controller;
  }
}

@immutable
class StickySliverState {
  const StickySliverState(
    this.scrollPercentage,
    this.isPinned,
  );

  final double scrollPercentage;

  final bool isPinned;

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (other is! StickySliverState) return false;
    final StickySliverState typedOther = other;
    return scrollPercentage == typedOther.scrollPercentage &&
        isPinned == typedOther.isPinned;
  }

  @override
  int get hashCode {
    return hashValues(scrollPercentage, isPinned);
  }
}

class StickySliver extends RenderObjectWidget {
  StickySliver({
    Key? key,
    this.leading,
    this.content,
    this.overlapsContent: false,
    this.sticky = true,
    this.controller,
  }) : super(key: key);

  StickySliver.builder({
    Key? key,
    required StickySliverWidgetBuilder builder,
    Widget? sliver,
    bool overlapsContent: false,
    bool sticky = true,
    StickySliverController? controller,
  }) : this(
          key: key,
          leading: ValueLayoutBuilder<StickySliverState>(
            builder: (context, constraints) =>
                builder(context, constraints.value),
          ),
          content: sliver,
          overlapsContent: overlapsContent,
          sticky: sticky,
          controller: controller,
        );

  final Widget? leading;
  final Widget? content;
  final bool overlapsContent;
  final bool sticky;
  final StickySliverController? controller;

  @override
  RenderStickySliver createRenderObject(BuildContext context) {
    return RenderStickySliver(
      overlapsContent: overlapsContent,
      sticky: sticky,
      controller: controller ?? DefaultStickySliverController.of(context),
    );
  }

  @override
  SliverStickyHeaderRenderObjectElement createElement() =>
      SliverStickyHeaderRenderObjectElement(this);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderStickySliver renderObject,
  ) {
    renderObject
      ..overlapsContent = overlapsContent
      ..sticky = sticky
      ..controller = controller ?? DefaultStickySliverController.of(context);
  }
}

class SliverStickyHeaderRenderObjectElement extends RenderObjectElement {
  SliverStickyHeaderRenderObjectElement(StickySliver widget) : super(widget);

  @override
  StickySliver get widget => super.widget as StickySliver;

  Element? _leading;
  Element? _content;

  @override
  void visitChildren(ElementVisitor visitor) {
    if (_leading != null) visitor(_leading!);
    if (_content != null) visitor(_content!);
  }

  @override
  void forgetChild(Element child) {
    super.forgetChild(child);
    if (child == _leading) _leading = null;
    if (child == _content) _content = null;
  }

  @override
  void mount(Element? parent, dynamic newSlot) {
    super.mount(parent, newSlot);
    _leading = updateChild(_leading, widget.leading, 0);
    _content = updateChild(_content, widget.content, 1);
  }

  @override
  void update(StickySliver newWidget) {
    super.update(newWidget);
    assert(widget == newWidget);
    _leading = updateChild(_leading, widget.leading, 0);
    _content = updateChild(_content, widget.content, 1);
  }

  @override
  void insertRenderObjectChild(RenderObject child, int? slot) {
    final RenderStickySliver renderObject =
        this.renderObject as RenderStickySliver;
    if (slot == 0) renderObject.header = child as RenderBox?;
    if (slot == 1) renderObject.child = child as RenderSliver?;
    assert(renderObject == this.renderObject);
  }

  @override
  void moveRenderObjectChild(RenderObject child, slot, newSlot) {
    assert(false);
  }

  @override
  void removeRenderObjectChild(RenderObject child, slot) {
    final RenderStickySliver renderObject =
        this.renderObject as RenderStickySliver;
    if (renderObject.header == child) renderObject.header = null;
    if (renderObject.child == child) renderObject.child = null;
    assert(renderObject == this.renderObject);
  }
}
