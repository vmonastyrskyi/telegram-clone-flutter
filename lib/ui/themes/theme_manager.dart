// import 'dart:async';
// import 'dart:math';
// import 'dart:ui' as ui;
//
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:provider/provider.dart';
// import 'package:telegram_clone_mobile/business_logic/view_models/theme_provider.dart';
// import 'package:telegram_clone_mobile/ui/icons/app_icons.dart';
// import 'package:telegram_clone_mobile/ui/screens/home/components/nav_drawer.dart';
// import 'package:telegram_clone_mobile/util/rendering/render_object_wrapper.dart';
//
// typedef ThemeBuilder = Widget Function(BuildContext context, ThemeData data);
//
// class ThemeManager extends StatefulWidget {
//   const ThemeManager({
//     Key? key,
//     required this.builder,
//     this.duration = const Duration(milliseconds: 350),
//   }) : super(key: key);
//
//   final ThemeBuilder builder;
//   final Duration duration;
//
//   @override
//   ThemeManagerState createState() => ThemeManagerState();
//
//   static ThemeManagerState of(BuildContext context) {
//     final ThemeManagerState? result =
//         context.findAncestorStateOfType<ThemeManagerState>();
//     if (result != null) {
//       return result;
//     }
//
//     throw FlutterError.fromParts(
//       <DiagnosticsNode>[
//         ErrorSummary(
//             'ThemeProvider.of() called with a context that does not contain a ThemeProvider.'),
//       ],
//     );
//   }
// }
//
// class ThemeManagerState extends State<ThemeManager> {
//   final GlobalKey _repaintBoundaryKey = GlobalKey();
//   final RenderManager<String> _renderManager = RenderManager();
//
//   bool _changing = false;
//   ui.Image? _image;
//   RenderData? _switcherRenderData;
//   GlobalKey<ThemeSwitchState>? _switcherKey;
//
//   bool reverseAnimation = false;
//
//   RenderManager get renderManager => _renderManager;
//
//   Duration get duration => widget.duration;
//
//   ui.Image? get image => _image;
//
//   GlobalKey<ThemeSwitchState>? get switcherKey => _switcherKey;
//
//   void getSwitcherCoordinates(String id) {
//     _switcherRenderData = renderManager.getRenderData(id);
//   }
//
//   void setSwitcherKey(GlobalKey<ThemeSwitchState> key) {
//     _switcherKey = key;
//   }
//
//   Future<void> changeTheme({bool reverse = false}) async {
//     reverseAnimation = reverse;
//
//     if (_changing) {
//       return;
//     }
//     _changing = true;
//
//     await _captureScreen();
//
//     context.read<ThemeProvider>().toggleBrightness();
//
//     Timer(duration, () => _changing = false);
//   }
//
//   Future<void> _captureScreen() async {
//     final boundary = _repaintBoundaryKey.currentContext!.findRenderObject()
//         as RenderRepaintBoundary;
//     _image = await boundary.toImage(pixelRatio: ui.window.devicePixelRatio);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Selector<ThemeProvider, ThemeData>(
//       selector: (_, provider) => provider.themeData,
//       builder: (context, themeData, _) => RepaintBoundary(
//         key: _repaintBoundaryKey,
//         child: widget.builder(context, themeData),
//       ),
//     );
//   }
// }
//
// class ThemeManagerArea extends StatefulWidget {
//   final Widget child;
//
//   ThemeManagerArea({
//     Key? key,
//     required this.child,
//   }) : super(key: key);
//
//   @override
//   _ThemeManagerAreaState createState() => _ThemeManagerAreaState();
// }
//
// class _ThemeManagerAreaState extends State<ThemeManagerArea>
//     with SingleTickerProviderStateMixin {
//   final GlobalKey<ThemeManagerState> _globalKey = GlobalKey();
//
//   late final AnimationController _circularController;
//
//   ThemeData? _currentTheme;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       _currentTheme = ThemeManager.of(context).themeData;
//       _circularController = AnimationController(
//         duration: ThemeManager.of(context).duration,
//         vsync: this,
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _circularController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = ThemeManager.of(context).themeData;
//
//     final child = Builder(
//       key: _globalKey,
//       builder: (context) {
//         return widget.child;
//       },
//     );
//
//     if (_currentTheme == null || _currentTheme == theme) {
//       return child;
//     } else {
//       Widget currentWidget;
//       Widget targetWidget;
//
//       if (ThemeManager.of(context).reverseAnimation) {
//         currentWidget = child;
//         targetWidget = RawImage(image: ThemeManager.of(context).image);
//       } else {
//         currentWidget = RawImage(image: ThemeManager.of(context).image);
//         targetWidget = child;
//       }
//
//       return Stack(
//         children: <Widget>[
//           currentWidget,
//           AnimatedBuilder(
//             animation: _circularController,
//             builder: (_, child) {
//               return ClipPath(
//                   clipper: CircularClipper(
//                       sizeRate: _circularController.value,
//                       offset: _switcherOffset!),
//                   child: child);
//             },
//             child: targetWidget,
//           ),
//           // if (ThemeManager.of(context).switcherRenderData != null)
//           //   Positioned(
//           //       top: ThemeManager.of(context).switcherRenderData!.yTop,
//           //       left: ThemeManager.of(context).switcherRenderData!.xLeft,
//           //       child: Icon(
//           //         AppIcons.light_theme,
//           //         color: Colors.white,
//           //       ))
//         ],
//       );
//     }
//   }
//
//   Offset? _switcherOffset;
//
//   @override
//   void didUpdateWidget(ThemeManagerArea oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     final theme = ThemeManager.of(context).themeData;
//     if (theme != _currentTheme) {
//       _getSwitcherCoordinates();
//       _runAnimation(theme);
//     }
//   }
//
//   void _getSwitcherCoordinates() {
//     final renderObject =
//     ThemeManager.of(context).switcherKey!.currentContext!.findRenderObject() as RenderBox;
//     final size = renderObject.size;
//     _switcherOffset = renderObject
//         .localToGlobal(Offset.zero)
//         .translate(size.width / 2, size.height / 2);
//   }
//
//   void _runAnimation(ThemeData? theme) async {
//     if (ThemeManager.of(context).reverseAnimation)
//       await _circularController.reverse(from: 1.0);
//     else
//       await _circularController.forward(from: 0.0);
//
//     setState(() {
//       _currentTheme = theme;
//     });
//
//     // ThemeManager.of(context).switcherKey!.currentState!.show = true;
//   }
// }
//
// class CircularClipper extends CustomClipper<Path> {
//   CircularClipper({
//     required this.sizeRate,
//     required this.offset,
//   });
//
//   double sizeRate;
//   Offset offset;
//
//   @override
//   Path getClip(Size size) {
//     return Path()
//       ..addOval(
//         Rect.fromCircle(
//           center: offset,
//           radius: ui.lerpDouble(
//             0,
//             _calcMaxRadius(size, offset),
//             sizeRate,
//           )!,
//         ),
//       );
//   }
//
//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     return true;
//   }
//
//   double _calcMaxRadius(Size size, Offset center) {
//     final w = max(center.dx, size.width - center.dx);
//     final h = max(center.dy, size.height - center.dy);
//     return sqrt(w * w + h * h);
//   }
// }
