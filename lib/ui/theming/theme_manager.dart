import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:telegram_clone_mobile/ui/theming/theme_provider.dart';

import 'theme_switcher.dart';

typedef ThemeBuilder = Widget Function(BuildContext, ThemeData? theme);

class ThemeManager extends StatefulWidget {
  ThemeManager({
    Key? key,
    required this.builder,
    this.duration = const Duration(milliseconds: 350),
  }) : super(key: key);

  final ThemeBuilder builder;
  final Duration duration;

  @override
  ThemeManagerState createState() => ThemeManagerState();

  static ThemeManagerState of(BuildContext context) {
    final ThemeManagerState? result =
        context.findAncestorStateOfType<ThemeManagerState>();
    if (result != null) {
      return result;
    }

    throw FlutterError.fromParts(
      <DiagnosticsNode>[
        ErrorSummary(
            'ThemeProvider.of() called with a context that does not contain a ThemeProvider.'),
      ],
    );
  }
}

class ThemeManagerState extends State<ThemeManager> {
  GlobalKey<ThemeManagerState> _repaintBoundaryKey = GlobalKey();
  GlobalKey<ThemeSwitcherState>? switcherGlobalKey;

  bool isBusy = false;
  ui.Image? image;

  Duration get duration => widget.duration;

  AppTheme get currentTheme => context.read<ThemeProvider>().theme;

  Future<void> _captureScreen() async {
    final boundary = _repaintBoundaryKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary;
    image = await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);
  }

  void toggleBrightness({
    required GlobalKey<ThemeSwitcherState> key,
  }) async {
    if (isBusy) {
      return;
    }

    isBusy = true;
    switcherGlobalKey = key;

    await _captureScreen();

    context.read<ThemeProvider>().toggleBrightness();

    Timer(duration, () {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        return RepaintBoundary(
          key: _repaintBoundaryKey,
          child: widget.builder(context, provider.theme.data),
        );
      },
    );
  }
}
