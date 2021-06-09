import 'package:flutter/material.dart';
import 'package:telegram_clone_mobile/ui/shared_widgets/appbar_icon_button.dart';

class ClearButton extends AnimatedWidget {
  ClearButton({
    Key? key,
    required this.controller,
    required this.onTap,
  })   : _scale = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOutCubic,
          ),
        ),
        _rotation = Tween<double>(
          begin: 0.125,
          end: 0.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeInOutCubic,
          ),
        ),
        super(key: key, listenable: controller);

  final AnimationController controller;
  final VoidCallback onTap;

  final Animation<double> _scale;
  final Animation<double> _rotation;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ScaleTransition(
          scale: _scale,
          child: RotationTransition(
            turns: _rotation,
            child: AppBarIconButton(
              onTap: onTap,
              icon: Icons.close,
              iconSize: 24.0,
              iconColor: Theme.of(context).textTheme.headline1!.color!,
              splashEffect: false,
            ),
          ),
        ),
      ],
    );
  }
}
