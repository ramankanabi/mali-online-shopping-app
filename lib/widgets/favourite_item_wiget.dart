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
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              height: AppSize.s100,
              width: MediaQuery.of(context).size.width,
              child: LayoutBuilder(builder: (context, bxct) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ImageWidget(bxct),
                        const SizedBox(
                          width: 10,
                        ),
                        NameAndPriceWidget(),
                      ],
                    ),
                    FavouriteAndCartButtonWidget(),
                  ],
                );
              })),
        ),
      ),
    );
  }

  Widget ImageWidget(BoxConstraints bxct) {
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

  Widget NameAndPriceWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          favourite.name.toString(),
          style: getMediumStyle(
              color: ColorManager.primary, fontSize: FontSize.s18),
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

  Widget FavouriteAndCartButtonWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(
          Icons.more_vert_outlined,
          color: ColorManager.grey,
        ),
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
              height: 30,
              width: 100,
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
                  child: Text(
                    "Add to cart",
                    style: getMediumStyle(
                        color: ColorManager.white, fontSize: FontSize.s12),
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
