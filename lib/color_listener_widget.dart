import 'dart:math';

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
  Color currentColor;
  Animation<Color> colorAnimation;

  @override
  void initState() {
    super.initState();
    currentColor = _getRandomColor();
    _animationController = AnimationController(
      value: 1,
      duration: Duration(seconds: 1),
      vsync: this,
    );
    widget.controller.addListener(() {
      if (widget.controller.shouldStartAnimation &&
          !widget.controller.isAnimating) {
        _startAnimation();
      }
    });
    colorAnimation = ColorTween(begin: currentColor, end: currentColor)
        .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _startAnimation() {
    Color nextColor = _getRandomColor();
    colorAnimation = ColorTween(begin: currentColor, end: nextColor)
        .animate(_animationController);
    widget.controller.isAnimating = true;
    widget.controller.shouldStartAnimation = false;

    _animationController.reset();
    _animationController.forward();

    colorAnimation.addListener(() {
      widget.controller.color = colorAnimation.value;
      widget.controller.setValue(_animationController.value);

      if (colorAnimation.isCompleted) {
        widget.controller.isAnimating = false;
      }
    });
  }

  Color _getRandomColor() =>
      Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: colorAnimation,
      builder: (BuildContext context, Widget widget) {
        return Container(
          height: 64,
          width: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: colorAnimation == null ? currentColor : colorAnimation.value,
          ),
        );
      },
    );
  }
}
