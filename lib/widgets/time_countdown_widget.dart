// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:online_shopping/resources/color_manager.dart';
import 'package:online_shopping/resources/font_manager.dart';
import 'package:online_shopping/resources/style_manager.dart';

class TimeCouuntDown extends StatefulWidget {
  final int secondsToEnd;
  const TimeCouuntDown(this.secondsToEnd, {super.key});
  @override
  // ignore: library_private_types_in_public_api
  _TimeCouuntDownState createState() => _TimeCouuntDownState();
}

class _TimeCouuntDownState extends State<TimeCouuntDown>
    with AutomaticKeepAliveClientMixin {
  static const duration = Duration(seconds: 1);

  late int secondsPassed;
  int seconds = 59;
  int minutes = 59;
  int hours = 24;
  int days = 0;

  late Timer timer;
  void handleTick() {
    if (mounted) {
      setState(() {
        secondsPassed = secondsPassed - 1;
      });
      seconds = secondsPassed % 60;
      hours = secondsPassed ~/ (60 * 60);
      days = secondsPassed ~/ (24 * 60 * 60);
      if (hours < 0) {
        hours = 0;
        seconds = 0;
        minutes = 0;
        setState(() {});
        timer.cancel();
      } else {
        if (seconds == 0) {
          minutes--;
        }
        if (minutes < 0) {
          minutes = 59;
        }
      }
    }
  }

  @override
  void initState() {
    secondsPassed = widget.secondsToEnd;

    timer = Timer.periodic(duration, (_) {
      handleTick();
    });

    setState(() {
      hours = 0;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                    label: 'Sec', value: seconds.toString().padLeft(2, '0')),
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
      width: 45,
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: ColorManager.white,
          border: Border.all(width: 0.1)),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            hours == null && minutes == null && seconds == null ? "" : value,
            style: getBoldStyle(
                color: ColorManager.primary, fontSize: FontSize.s16),
          ),
          Text(
            label,
            style:
                TextStyle(color: ColorManager.primary, fontSize: FontSize.s10),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
