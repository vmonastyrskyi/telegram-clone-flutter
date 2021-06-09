import 'package:flutter/material.dart';

import 'theme_manager.dart';

class ThemeSwitcher extends StatefulWidget {
  final Widget Function(BuildContext) builder;
  final Widget? child;

  ThemeSwitcher({
    Key? key,
    required this.builder,
    this.child,
  }) : super(key: key);

  @override
  ThemeSwitcherState createState() => ThemeSwitcherState();

  static ThemeSwitcherState of(BuildContext context) {
    final ThemeSwitcherState? result =
        context.findAncestorStateOfType<ThemeSwitcherState>();
    if (result != null) {
      return result;
    }

    throw FlutterError.fromParts(
      <DiagnosticsNode>[
        ErrorSummary(
            'ThemeSwitcher.of() called with a context that does not contain a ThemeSwitcher.'),
      ],
    );
  }
}

class ThemeSwitcherState extends State<ThemeSwitcher> {
  final GlobalKey<ThemeSwitcherState> _themeSwitcherKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Builder(
      key: _themeSwitcherKey,
      builder: widget.builder,
    );
  }

  void toggleBrightness() {
    ThemeManager.of(context).toggleBrightness(
      key: _themeSwitcherKey,
    );
  }
}
