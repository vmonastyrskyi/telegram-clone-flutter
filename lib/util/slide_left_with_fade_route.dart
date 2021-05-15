import 'package:flutter/material.dart';

class SlideLeftWithFadeRoute<T> extends MaterialPageRoute<T> {
  SlideLeftWithFadeRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
  }) : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => Duration(milliseconds: 225);

  @override
  Duration get reverseTransitionDuration => Duration(milliseconds: 225);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    var slideBegin = Offset(1.0, 0.0);
    var slideEnd = Offset.zero;
    var fadeBegin = 0.0;
    var fadeEnd = 1.0;
    var curve = Curves.easeInOutCubic;

    var slideTween = Tween<Offset>(begin: slideBegin, end: slideEnd)
        .chain(CurveTween(curve: curve));
    var fadeTween = Tween<double>(begin: fadeBegin, end: fadeEnd)
        .chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(slideTween),
      child: FadeTransition(
        opacity: animation.drive(fadeTween),
        child: child,
      ),
    );
  }
}
