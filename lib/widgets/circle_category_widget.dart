import "package:flutter/material.dart";

import '../resources/color_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/style_manager.dart';
import '../resources/values_manager.dart';

class CircleCategoryWidget extends StatelessWidget {
  const CircleCategoryWidget(
      {Key? key, required this.category, required this.image})
      : super(key: key);

  final String category;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.categorySceen,
            arguments: [category],
          );
        },
        child: Column(
          children: [
            Card(
              elevation: 5,
              borderOnForeground: false,
              shape: const CircleBorder(),
              child: Container(
                height: AppSize.s60,
                width: AppSize.s60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(
                      image,
                    ),
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: AppSize.s12,
            ),
            Text(
              category,
              style: getRegularStyle(
                color: ColorManager.darkGrey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
