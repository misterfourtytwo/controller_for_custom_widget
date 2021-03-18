import 'package:flutter/material.dart';

class ColorChangeController extends ChangeNotifier {
  double value = 0.0;
  bool isAnimating = false;
  bool shouldStartAnimation = false;
  Color color;

  ColorChangeController({@required this.color});

  void setValue(double value) {
    this.value = value;
    notifyListeners();
  }

  void changeColor() {
    this.shouldStartAnimation = true;
    notifyListeners();
  }
}
