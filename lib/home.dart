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
  int value = 0;
  Color color = Colors.transparent;

  @override
  void initState() {
    super.initState();
    colorCtrl = ColorChangeController(color: color);
    colorCtrl.addListener(() {
      if (mounted) {
        setState(() {
          value = (colorCtrl.value * 100).round();
          color = colorCtrl.color;
        });
      }
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
              ColorListenerWidget(
                controller: colorCtrl,
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                height: 64,
                color: color.withOpacity(.3),
                child: LinearProgressIndicator(
                  value: value.toDouble() / 100,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
              SizedBox(height: 20),
              Text(
                value == 100 ? 'Done' : '$value %',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 20),
              FlatButton(
                child: Text(
                  'Change color',
                ),
                color: color.withOpacity(0.4),
                onPressed: colorCtrl.changeColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
