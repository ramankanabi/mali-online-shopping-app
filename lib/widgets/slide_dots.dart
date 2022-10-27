import 'package:flutter/material.dart';
import 'package:online_shopping/resources/color_manager.dart';
import 'package:online_shopping/resources/values_manager.dart';

class SlideDots extends StatelessWidget {
  bool isActive;
  SlideDots(this.isActive);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: isActive ? 8 : 6,
      width: isActive ? 8 : 6,
      decoration: BoxDecoration(
        color: isActive ? ColorManager.orange : Colors.grey,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
