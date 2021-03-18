import 'package:flutter/material.dart';

import 'color_change_controller.dart';
import 'color_listener_widget.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ColorChangeController colorCtrl;

  void _colorChangeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    colorCtrl = ColorChangeController(initialColor: Colors.red);
    colorCtrl.addListener(_colorChangeListener);
  }

  @override
  void dispose() {
    colorCtrl.removeListener(_colorChangeListener);
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
              ColorListenerWidget(
                controller: colorCtrl,
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 64,
                child: LinearProgressIndicator(
                  value: colorCtrl.progress,
                  valueColor: AlwaysStoppedAnimation(colorCtrl.value),
                  backgroundColor: colorCtrl.value.withOpacity(.3),
                ),
              ),
              SizedBox(height: 20),
              Text(
                (1.0 - colorCtrl.progress < 1e-5)
                    ? 'Done'
                    : '${(colorCtrl.progress * 100).toInt()} %',
                style: TextStyle(
                  color: colorCtrl.value,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 20),
              FlatButton(
                child: Text(
                  'Change color',
                ),
                color: colorCtrl.value.withOpacity(0.4),
                onPressed: colorCtrl.animate,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
