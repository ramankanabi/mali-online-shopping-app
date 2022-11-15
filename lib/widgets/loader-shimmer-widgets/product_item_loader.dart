import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

import '../../resources/color_manager.dart';
import '../../resources/values_manager.dart';

class ProductItemLoader extends StatelessWidget {
  const ProductItemLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, bxct) => ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.r12),
        child: SizedBox(
          height: bxct.maxHeight,
          child: Stack(
            children: [
              const Icon(CupertinoIcons.heart_circle_fill),
              Shimmer.fromColors(
                  baseColor: ColorManager.shimmerBaseColor,
                  highlightColor: ColorManager.shimmerHighlightColor,
                  child: Container(
                    color: ColorManager.white,
                    height: bxct.maxHeight * 0.75,
                    width: bxct.maxWidth,
                  )),
              Positioned(
                bottom: 0,
                child: Container(
                  height: bxct.maxHeight * 0.25,
                  width: bxct.maxWidth,
                  color: ColorManager.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Shimmer.fromColors(
                            baseColor: ColorManager.shimmerBaseColor,
                            highlightColor: ColorManager.shimmerHighlightColor,
                            child: Container(
                              height: 10,
                              width: 40,
                              decoration: BoxDecoration(
                                  color: ColorManager.orange,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Shimmer.fromColors(
                            baseColor: ColorManager.shimmerBaseColor,
                            highlightColor: ColorManager.shimmerHighlightColor,
                            child: Container(
                              height: 10,
                              width: 90,
                              decoration: BoxDecoration(
                                  color: ColorManager.orange,
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: Shimmer.fromColors(
                            baseColor: ColorManager.shimmerBaseColor,
                            highlightColor: ColorManager.shimmerHighlightColor,
                            child: Container(
                              height: 10,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: ColorManager.orange,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.r5)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
