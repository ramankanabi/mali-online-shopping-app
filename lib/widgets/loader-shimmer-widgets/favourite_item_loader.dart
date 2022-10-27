import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../resources/color_manager.dart';
import '../../resources/values_manager.dart';

class FavouriteItemLoader extends StatelessWidget {
  const FavouriteItemLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          height: AppSize.s100,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: ColorManager.shimmerBaseColor,
                    highlightColor: ColorManager.shimmerHighlightColor,
                    child: Container(
                      width: 80,
                      height: 100,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: ColorManager.shimmerBaseColor,
                            highlightColor: ColorManager.shimmerHighlightColor,
                            child: Container(
                              height: 10,
                              width: 60,
                              decoration: BoxDecoration(
                                  color: ColorManager.grey,
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.r10)),
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
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.r10)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Shimmer.fromColors(
                        baseColor: ColorManager.shimmerBaseColor,
                        highlightColor: ColorManager.shimmerHighlightColor,
                        child: Icon(CupertinoIcons.heart_fill,
                            color: ColorManager.grey)),
                    Shimmer.fromColors(
                      baseColor: ColorManager.shimmerBaseColor,
                      highlightColor: ColorManager.shimmerHighlightColor,
                      child: Container(
                        height: 30,
                        width: 100,
                        color: ColorManager.grey,
                      ),
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
