// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/resources/color_manager.dart';
import 'package:online_shopping/resources/font_manager.dart';
import 'package:online_shopping/resources/style_manager.dart';
import 'package:online_shopping/resources/values_manager.dart';
import 'package:shimmer/shimmer.dart';

class ProductViewPageLoader extends StatelessWidget {
  bool isInit = true;
  bool isLoading = false;
  int pageIndex = 0;
  // late Future _future;
  bool isFav = false;
  int productFavCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImageCover(),
                NamePriceFav(),
                SizedBox(
                  height: AppSize.s70,
                  width: double.infinity,
                  child: SizeView(
                    context,
                  ),
                ),
                SizedBox(
                  height: AppSize.s100,
                  width: double.infinity,
                  child: ColorView(
                    context,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                DescriptionView(
                  context,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget NamePriceFav() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Shimmer.fromColors(
              baseColor: ColorManager.shimmerBaseColor,
              highlightColor: ColorManager.shimmerHighlightColor,
              child: Container(
                height: 10,
                width: 40,
                decoration: BoxDecoration(
                    color: ColorManager.grey,
                    borderRadius: BorderRadius.circular(AppRadius.r10)),
              ),
            ),
            Shimmer.fromColors(
              baseColor: ColorManager.shimmerBaseColor,
              highlightColor: ColorManager.shimmerHighlightColor,
              child: Icon(
                CupertinoIcons.heart_fill,
                color: ColorManager.darkGrey,
                size: 30,
              ),
            ),
          ],
        ),
        Container(
          height: 10,
          width: 30,
          decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(AppRadius.r10)),
        ),
      ],
    );
  }

  Widget ImageCover() {
    return Shimmer.fromColors(
      baseColor: ColorManager.shimmerBaseColor,
      highlightColor: ColorManager.shimmerHighlightColor,
      child: Container(
        color: ColorManager.grey,
        width: double.infinity,
        height: AppSize.s400,
      ),
    );
  }

  Widget SizeView(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Shimmer.fromColors(
        baseColor: ColorManager.shimmerBaseColor,
        highlightColor: ColorManager.shimmerHighlightColor,
        child: Container(
          height: 15,
          width: 40,
          decoration: BoxDecoration(
              color: ColorManager.grey,
              borderRadius: BorderRadius.circular(AppRadius.r10)),
        ),
      ),
      Row(
        children: [
          for (int i = 0; i < 3; i++) ...{
            Shimmer.fromColors(
              baseColor: ColorManager.shimmerBaseColor,
              highlightColor: ColorManager.shimmerHighlightColor,
              child: Container(
                height: 20,
                width: 40,
                decoration: BoxDecoration(
                    color: ColorManager.grey,
                    borderRadius: BorderRadius.circular(AppRadius.r10)),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          }
        ],
      )
    ]);
  }

  Widget ColorView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Shimmer.fromColors(
          baseColor: ColorManager.shimmerBaseColor,
          highlightColor: ColorManager.shimmerHighlightColor,
          child: Container(
            height: 15,
            width: 40,
            decoration: BoxDecoration(
              color: ColorManager.grey,
              borderRadius: BorderRadius.circular(AppRadius.r10),
            ),
          ),
        ),
        Row(
          children: [
            for (int i = 0; i < 3; i++) ...{
              Shimmer.fromColors(
                  baseColor: ColorManager.shimmerBaseColor,
                  highlightColor: ColorManager.shimmerHighlightColor,
                  child: Container(
                    height: 100,
                    width: 60,
                    decoration: BoxDecoration(
                      color: ColorManager.grey,
                      borderRadius: BorderRadius.circular(AppRadius.r10),
                    ),
                  )),
              SizedBox(
                width: 5,
              ),
            }
          ],
        )
      ],
    );
  }

  Widget DescriptionView(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Shimmer.fromColors(
          baseColor: ColorManager.shimmerBaseColor,
          highlightColor: ColorManager.shimmerHighlightColor,
          child: Container(
            height: 15,
            width: 60,
            decoration: BoxDecoration(
                color: ColorManager.grey,
                borderRadius: BorderRadius.circular(AppRadius.r10)),
          ),
        ),
        Column(
          children: [
            for (int i = 0; i < 10; i++) ...{
              Shimmer.fromColors(
                baseColor: ColorManager.shimmerBaseColor,
                highlightColor: ColorManager.shimmerHighlightColor,
                child: Container(
                  height: 5,
                  width: MediaQuery.of(context).size.width / 1.5,
                  decoration: BoxDecoration(
                      color: ColorManager.grey,
                      borderRadius: BorderRadius.circular(AppRadius.r10)),
                ),
              ),
              SizedBox(
                height: 4,
              ),
            }
          ],
        ),
      ],
    );
  }
}
