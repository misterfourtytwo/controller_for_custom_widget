import 'package:flutter/material.dart';

import 'color_change_controller.dart';

class ColorListenerWidget extends StatefulWidget {
  final ColorChangeController controller;
  ColorListenerWidget({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  _ColorChangerState createState() => _ColorChangerState();
}

class _ColorChangerState extends State<ColorListenerWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      value: 1,
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _colorAnimation = widget.controller.tween.animate(_animationController);
    _colorAnimation.addListener(_animationListener);

    widget.controller.addListener(_colorChangeListener);
  }

  void _colorChangeListener() {
    if (widget.controller.shouldStartAnimation) {
      if (widget.controller.isAnimating) {
        _finishAnimation();
      }
      // preset animation object
      _colorAnimation = widget.controller.tween.animate(_animationController);
      _colorAnimation.addListener(_animationListener);
      // start animation
      widget.controller.onStart();
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _animationListener() {
    widget.controller.onTick(_animationController.value, _colorAnimation.value);
    if (_animationController.isCompleted) {
      _finishAnimation();
    }
  }

  void _finishAnimation() {
    widget.controller.onFinish();
    _colorAnimation.removeListener(_animationListener);
  }

  @override
  void dispose() {
    _colorAnimation.removeListener(_animationListener);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (BuildContext context, Widget widget) {
        return Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _colorAnimation.value,
          ),
        );
      },
    );
  }
}
