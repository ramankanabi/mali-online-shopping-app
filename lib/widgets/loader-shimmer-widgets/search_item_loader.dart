import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../resources/color_manager.dart';

class SearchItemLoader extends StatelessWidget {
  const SearchItemLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: ColorManager.shimmerBaseColor,
          highlightColor: ColorManager.shimmerHighlightColor,
          child: Container(
            height: 80,
            width: 80,
            color: ColorManager.grey,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: ColorManager.shimmerBaseColor,
              highlightColor: ColorManager.shimmerHighlightColor,
              child: Container(
                height: 10,
                width: 50,
                decoration: BoxDecoration(
                    color: ColorManager.grey,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Shimmer.fromColors(
              baseColor: ColorManager.shimmerBaseColor,
              highlightColor: ColorManager.shimmerHighlightColor,
              child: Container(
                height: 10,
                width: 80,
                decoration: BoxDecoration(
                    color: ColorManager.grey,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Shimmer.fromColors(
              baseColor: ColorManager.shimmerBaseColor,
              highlightColor: ColorManager.shimmerHighlightColor,
              child: Container(
                height: 10,
                width: 40,
                decoration: BoxDecoration(
                    color: ColorManager.grey,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        )
      ],
    );
  }
}
