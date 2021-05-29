import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/provider/theme_provider.dart';

import 'theme_manager.dart';
import 'theme_switcher_circle_clipper.dart';

class ThemeSwitcherArea extends StatefulWidget {
  final Widget child;

  ThemeSwitcherArea({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _ThemeSwitcherAreaState createState() => _ThemeSwitcherAreaState();
}

class _ThemeSwitcherAreaState extends State<ThemeSwitcherArea>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ThemeManagerState> _globalKey = GlobalKey();

  late final AnimationController _circularController;

  bool _themeChanging = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _currentTheme = ThemeManager.of(context).currentTheme;
      _circularController = AnimationController(
        duration: ThemeManager.of(context).duration,
        vsync: this,
      );
    });
  }

  @override
  void dispose() {
    _circularController.dispose();
    super.dispose();
  }

  AppTheme? _currentTheme;
  Offset? _switcherOffset;

  @override
  Widget build(BuildContext context) {
    final theme = ThemeManager.of(context).currentTheme;
    final child = Builder(
      key: _globalKey,
      builder: (_) => widget.child,
    );

    if (_currentTheme == null || _currentTheme == theme) {
      return child;
    } else {
      return Stack(
        children: [
          RawImage(image: ThemeManager.of(context).image),
          AnimatedBuilder(
            animation: _circularController,
            builder: (_, child) {
              return ClipPath(
                clipper: ThemeSwitcherCircleClipper(
                  offset: _switcherOffset,
                  sizeRate: _circularController.value,
                ),
                child: child,
              );
            },
            child: child,
          ),
        ],
      );
    }
  }

  void _getSwitcherCoordinates() {
    final renderObject = ThemeManager.of(context)
        .switcherGlobalKey!
        .currentContext!
        .findRenderObject() as RenderBox;
    final size = renderObject.size;

    _switcherOffset = renderObject
        .localToGlobal(Offset.zero)
        .translate(size.width / 2.0, size.height / 2.0);
  }

  @override
  void didUpdateWidget(ThemeSwitcherArea oldWidget) {
    super.didUpdateWidget(oldWidget);
    final theme = ThemeManager.of(context).currentTheme;
    if (!_themeChanging && theme != _currentTheme) {
      _themeChanging = true;
      _getSwitcherCoordinates();
      _runAnimation(theme);
    }
  }

  void _runAnimation(AppTheme? theme) async {
    await _circularController.forward(from: 0.0);

    setState(() {
      _currentTheme = theme;
      _themeChanging = false;
    });
  }
}
