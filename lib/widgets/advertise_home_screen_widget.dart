import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/controller/advertise_controller.dart';
import 'package:online_shopping/widgets/slide_dots.dart';
import 'package:online_shopping/widgets/time_countdown_widget.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/style_manager.dart';

class AdvertiseHomeScreenWidget extends StatefulWidget {
  const AdvertiseHomeScreenWidget({super.key});

  @override
  State<AdvertiseHomeScreenWidget> createState() =>
      _AdvertiseHomeScreenWidgetState();
}

class _AdvertiseHomeScreenWidgetState extends State<AdvertiseHomeScreenWidget> {
  int advertisePageIndex = 0;
  late Future _future;
  onChangedPage(int index) {
    setState(() {
      advertisePageIndex = index;
    });
  }

  @override
  void initState() {
    _future = Provider.of<AdvertiseContoller>(context, listen: false)
        .getAllAdvertises();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Shimmer.fromColors(
              baseColor: ColorManager.shimmerBaseColor,
              highlightColor: ColorManager.shimmerHighlightColor,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.24,
                color: ColorManager.grey,
              ),
            );
          } else {
            final advs = Provider.of<AdvertiseContoller>(context).advItems;
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.24,
                    child: PageView.builder(
                      allowImplicitScrolling: true,
                      onPageChanged: onChangedPage,
                      itemCount: advs.length,
                      itemBuilder: (ctx, index) => Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, Routes.salesDiscountScreenScreen);
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.24,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    advs[index].imageCover,
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 30,
                            top: 50,
                            child: Container(
                                color: Colors.black.withOpacity(0.5),
                                // height: 100,
                                width: 150,
                                child: Text(
                                  advs[index].advertiseTitle,
                                  style: getBoldStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s20),
                                  softWrap: true,
                                  textAlign: TextAlign.start,
                                )),
                          ),
                          Positioned(
                            bottom: -40,
                            right: 20,
                            child: TimeCouuntDown(advs[index].timeToEnd),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < advs.length; i++) ...{
                          if (i == advertisePageIndex)
                            SlideDots(true)
                          else
                            SlideDots(false)
                        }
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        });
  }
}
