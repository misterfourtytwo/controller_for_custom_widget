import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'custom widget controller',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ColorChangeController colorCtrl;
  int value = 0;
  Color color = Colors.transparent;

  @override
  void initState() {
    super.initState();
    colorCtrl = ColorChangeController();
    colorCtrl.addListener(() {
      setState(() {
        value = (colorCtrl.value * 100).round();
        // color = colorCtrl.;
      });
    });
  }

  @override
  void dispose() {
    colorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ColorChanger(
                controller: colorCtrl,
              ),
              SizedBox(height: 20),
              Container(
                height: 64,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: LinearProgressIndicator(value: value.toDouble() / 100),
              ),
              SizedBox(height: 20),
              Text(
                value == 100 ? 'done' : '$value %',
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 20),
              FlatButton(
                child: Text(
                  'Change color',
                ),
                color: Colors.blue,
                onPressed: colorCtrl.changeColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ColorChanger extends StatefulWidget {
  final ColorChangeController controller;
  ColorChanger({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  _ColorChangerState createState() => _ColorChangerState();
}

class _ColorChangerState extends State<ColorChanger>
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
    // should be called not here but where we instantiate it
    // widget.controller.dispose();
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

class ColorChangeController extends ChangeNotifier {
  double value = 0.0;
  bool isAnimating = false;
  bool shouldStartAnimation = false;

  void setValue(double value) {
    this.value = value;
    notifyListeners();
  }

  void changeColor() {
    this.shouldStartAnimation = true;
    notifyListeners();
  }
}
