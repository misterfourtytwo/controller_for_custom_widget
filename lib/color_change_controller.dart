import 'package:controller_for_custom_widget/utils.dart';
import 'package:flutter/material.dart';

class ColorChangeController extends ChangeNotifier {
  Color value;
  double progress;
  ColorTween tween;
  Color _customTargetColor;
  bool isAnimating = false;
  bool shouldStartAnimation = false;

  ColorChangeController({Color initialColor})
      : value = initialColor ?? getRandomColor(),
        tween = ColorTween(begin: initialColor, end: initialColor),
        progress = 1;

  void animate({Color customTargetColor}) {
    _customTargetColor = customTargetColor;

    if (!this.shouldStartAnimation) {
      this.shouldStartAnimation = true;
      notifyListeners();
    }
  }

  void onStart() {
    if (!this.isAnimating) {
      this.shouldStartAnimation = false;
      this.isAnimating = true;

      tween = ColorTween(
        begin: value,
        end: _customTargetColor ?? getRandomColor(),
      );
      notifyListeners();
    }
  }

  void onTick(double newProgress, Color newValue) {
    value = newValue;
    progress = newProgress;

    notifyListeners();
  }

  void onFinish() {
    progress = 1;
    isAnimating = false;

    tween = ColorTween(begin: value, end: value);
    notifyListeners();
  }
}
