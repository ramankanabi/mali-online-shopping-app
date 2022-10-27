import 'package:flutter/material.dart';
import 'dart:async';

import 'package:online_shopping/resources/color_manager.dart';
import 'package:online_shopping/resources/style_manager.dart';

void main() => runApp(TimeCouuntDown());

class TimeCouuntDown extends StatefulWidget {
  @override
  _TimeCouuntDownState createState() => _TimeCouuntDownState();
}

class _TimeCouuntDownState extends State<TimeCouuntDown> {
  static const duration = const Duration(seconds: 1);

  int secondsPassed = 86400;
  bool isActive = false;
  int? seconds;
  int minutes = 59;
  int? hours;
  int? days;

  late Timer timer;
  void handleTick() {
    if (mounted) {
      setState(() {
        secondsPassed = secondsPassed - 1;
      });
      seconds = secondsPassed % 60;
      hours = secondsPassed ~/ (60 * 60);
      days = secondsPassed ~/ (24 * 60 * 60);

      if (seconds == 0) {
        minutes--;
      }
      if (minutes < 0) {
        minutes = 59;
      }
    }
  }

  bool isInit = true;
  @override
  void didChangeDependencies() {
    if (isInit) {
      timer = Timer.periodic(duration, (_) {
        handleTick();
      });
    }
    setState(() {
      isInit = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LabelText(
                    label: 'Hours', value: hours.toString().padLeft(2, '0')),
                LabelText(
                    label: 'Min', value: minutes.toString().padLeft(2, '0')),
                LabelText(
                    label: 'SEC', value: seconds.toString().padLeft(2, '0')),
              ],
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget LabelText({required String label, required String value}) {
    return Container(
      alignment: Alignment.center,
      width: 40,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: ColorManager.white,
          border: Border.all(width: 0.1)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            style: getBoldStyle(
              color: ColorManager.primary,
            ),
          ),
          // Text(
          //   label,
          //   style: TextStyle(color: ColorManager.primary, fontSize: 10),
          // ),
        ],
      ),
    );
  }
}
