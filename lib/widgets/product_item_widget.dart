// ignore_for_file: sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/controller/auth_contoller.dart';
import 'package:online_shopping/controller/favouite_contoller.dart';
import 'package:online_shopping/resources/routes_manager.dart';
import 'package:online_shopping/widgets/loader-shimmer-widgets/product_item_loader.dart';
import 'package:provider/provider.dart';
import '../model/product_model.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/style_manager.dart';
import '../resources/values_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import "../cacheManager/image_cache_manager.dart" as cache;

class ProductItemWidget extends StatefulWidget {
  final Product productData;

  const ProductItemWidget({super.key, required this.productData});

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget>
    with AutomaticKeepAliveClientMixin {
  bool isFav = false;
  bool isInit = true;
  late Product product;
  bool isLoading = false;
  bool isNetwork = true;

  @override
  initState() {
    product = widget.productData;
    final isLogged =
        Provider.of<AuthController>(context, listen: false).isLogged;

    if (isLogged) {
      toggleFavStatus();
    } else {
      isFav = false;
    }
    super.initState();
  }

  toggleFavStatus() async {
    setState(() {
      isLoading = true;
    });
    try {
      isFav =
          await FavouriteContoller().getFavourite(product.prodId, globalUserId);

      setState(() {
        isLoading = false;
      });
    } catch (er) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isLogged =
        Provider.of<AuthController>(context, listen: true).isLogged;

    return isLoading
        ? const Center(child: ProductItemLoader())
        : ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            child: GestureDetector(
              onTap: () async {
                final favStatus = await Navigator.pushNamed(
                    context, Routes.productViewScreen,
                    arguments: [product.prodId]);
                setState(() {
                  isFav = favStatus.toString() == "true";
                });
              },
              child: LayoutBuilder(
                builder: (context, bxcst) {
                  return Stack(
                    children: [
                      CachedNetworkImage(
                          imageUrl: product.images[0],
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.cover,
                          width: bxcst.maxWidth,
                          height: bxcst.maxHeight * 0.7,
                          cacheManager: cache.ImageCacheManager().cacheManager),
                      if (product.priceDiscount != 0) ...{
                        Banner(
                          message: "SALE",
                          location: BannerLocation.topStart,
                          color: ColorManager.primaryOpacity70,
                          textStyle: getBoldStyle(
                            color: Colors.white,
                            fontSize: FontSize.s10,
                          ),
                        ),
                      },
                      Positioned(
                          right: 5, top: 5, child: FavIconButton(isLogged)),
                      Positioned(bottom: 0, child: Footer(bxcst))
                    ],
                  );
                },
              ),
            ),
          );
  }

  Widget FavIconButton(bool isLogged) {
    return InkWell(
      onTap: () async {
        if (isLogged) {
          setState(() {
            isFav = !isFav;
          });
          isFav == true
              ? await Provider.of<FavouriteContoller>(context, listen: false)
                  .addToFavourite(product.prodId, globalUserId)
              : await Provider.of<FavouriteContoller>(context, listen: false)
                  .removeFavourite(product.prodId, globalUserId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Should Log in :)"),
            ),
          );
        }
      },
      child: Card(
        shape: const CircleBorder(),
        child: Container(
          alignment: Alignment.center,
          height: 25,
          width: 25,
          child: Icon(
            isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
            size: 18,
            color: ColorManager.orange,
          ),
        ),
      ),
    );
  }

  Widget Footer(BoxConstraints bxcst) {
    return Container(
      height: bxcst.maxHeight * 0.30,
      width: bxcst.maxWidth,
      color: ColorManager.white,
      child: Padding(
        padding: const EdgeInsets.all(AppPadding.p8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: getBoldStyle(
                  color: ColorManager.grey, fontSize: FontSize.s16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              product.discreption_EN.toString(),
              style: getRegularStyle(
                  color: ColorManager.lightGrey, fontSize: FontSize.s12),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            if (product.priceDiscount == 0) ...{
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: product.price.toString(),
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
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: product.price.toString(),
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
                              color: ColorManager.lightGrey,
                              fontSize: FontSize.s8),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: product.priceDiscount.toString(),
                          style: getBoldStyle(
                              color: ColorManager.orange,
                              fontSize: FontSize.s16),
                        ),
                        TextSpan(
                          text: " IQD",
                          style: getBoldStyle(
                              color: ColorManager.orange,
                              fontSize: FontSize.s10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            }
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
