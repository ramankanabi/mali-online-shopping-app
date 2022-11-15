import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/controller/auth_contoller.dart';
import 'package:online_shopping/controller/favouite_contoller.dart';
import 'package:online_shopping/model/favourite_model.dart';
import 'package:online_shopping/model/product_model.dart';
import 'package:online_shopping/resources/values_manager.dart';
import 'package:online_shopping/widgets/show_bottom_modal_sheet.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../cacheManager/image_cache_manager.dart' as cache;
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/style_manager.dart';

class FavouriteItemWidget extends StatefulWidget {
  final Favourite favourite;
  const FavouriteItemWidget({
    super.key,
    required this.favourite,
  });

  @override
  State<FavouriteItemWidget> createState() => _FavouriteItemWidgetState();
}

class _FavouriteItemWidgetState extends State<FavouriteItemWidget> {
  bool _isFav = true;
  bool get isFav => _isFav;
  late Favourite favourite;
  @override
  void initState() {
    favourite = widget.favourite;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          final favStatus = await Navigator.pushNamed(
              context, Routes.productViewScreen,
              arguments: [favourite.prodId]);
          setState(() {
            _isFav = favStatus.toString() == "true";
          });
        },
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(AppPadding.p8),
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: AppSize.s100,
                child: LayoutBuilder(
                  builder: (context, bxct) {
                    return Row(children: [
                      Container(
                        child: imageWidget(bxct),
                      ),
                      Expanded(
                        child: Container(
                          color: ColorManager.white,
                          child: Stack(children: [
                            Positioned(
                              top: 10,
                              left: 5,
                              child: nameAndPriceWidget(),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: favouriteAndCartButtonWidget(),
                            )
                          ]),
                        ),
                      ),
                    ]);
                  },
                )),
          ),
        )

        //  Card(
        //   elevation: 2,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: SizedBox(
        //         height: AppSize.s100,
        //         width: MediaQuery.of(context).size.width - 20,
        //         child: LayoutBuilder(builder: (context, bxct) {
        //           return Row(
        //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //             children: [
        //               SizedBox(
        //                 width: 200,
        //                 child: Row(
        //                   children: [
        //                     imageWidget(bxct),
        //                     const SizedBox(
        //                       width: 10,
        //                     ),
        //                     nameAndPriceWidget(),
        //                   ],
        //                 ),
        //               ),
        //               favouriteAndCartButtonWidget(),
        //             ],
        //           );
        //         })),
        //   ),
        // ),
        );
  }

  Widget imageWidget(BoxConstraints bxct) {
    return SizedBox(
      width: bxct.maxWidth * 0.25,
      height: bxct.maxHeight,
      child: CachedNetworkImage(
        imageUrl: favourite.images[0].toString(),
        fit: BoxFit.cover,
        cacheManager: cache.ImageCacheManager().cacheManager,
      ),
    );
  }

  Widget nameAndPriceWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          favourite.name,
          style: getMediumStyle(
              color: ColorManager.primary, fontSize: FontSize.s18),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        const SizedBox(
          height: 4,
        ),
        if (favourite.priceDiscount == 0) ...{
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: favourite.price.toString(),
                  style: getBoldStyle(
                      color: ColorManager.orange, fontSize: FontSize.s16),
                ),
                TextSpan(
                  text: " IQD",
                  style: getBoldStyle(
                      color: ColorManager.orange, fontSize: FontSize.s10),
                ),
              ],
            ),
          ),
        } else ...{
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: favourite.price.toString(),
                      style: TextStyle(
                        fontSize: FontSize.s12,
                        fontWeight: FontWeight.normal,
                        color: ColorManager.lightGrey,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.grey,
                      ),
                    ),
                    TextSpan(
                      text: " IQD",
                      style: getBoldStyle(
                          color: ColorManager.lightGrey, fontSize: FontSize.s8),
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: favourite.priceDiscount.toString(),
                      style: getBoldStyle(
                          color: ColorManager.orange, fontSize: FontSize.s16),
                    ),
                    TextSpan(
                      text: " IQD",
                      style: getBoldStyle(
                          color: ColorManager.orange, fontSize: FontSize.s10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        },
      ],
    );
  }

  Widget favouriteAndCartButtonWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            IconButton(
              splashRadius: 0.1,
              onPressed: () async {
                if (isFav) {
                  setState(() {
                    _isFav = !_isFav;
                  });
                  await Provider.of<FavouriteContoller>(context, listen: false)
                      .removeFavourite(
                          favourite.prodId.toString(), globalUserId);
                } else {
                  setState(() {
                    _isFav = !_isFav;
                  });
                  await Provider.of<FavouriteContoller>(context, listen: false)
                      .addToFavourite(
                          favourite.prodId.toString(), globalUserId);
                }
              },
              icon: Icon(
                  isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                  color: ColorManager.orange),
            ),
            Container(
              height: AppSize.s30,
              width: AppSize.s100,
              color: ColorManager.primary,
              child: ElevatedButton(
                onPressed: () async {
                  final connectionStatus =
                      await Connectivity().checkConnectivity();
                  if (connectionStatus == ConnectivityResult.none) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Cheack internet connection"),
                      ),
                    );
                  } else {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      barrierColor: Colors.black87,
                      builder: (context) => SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: ShowModalBottomSheet(
                          product: Product(
                            prodId: favourite.prodId,
                            size: favourite.size,
                            quantity: favourite.quantity,
                            price: favourite.price,
                            name: favourite.name,
                            images: favourite.images,
                          ),
                        ),
                      ),
                    );
                  }
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ColorManager.primary)),
                child: Text(
                  "Add to cart",
                  style: getMediumStyle(
                      color: ColorManager.white, fontSize: FontSize.s12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
