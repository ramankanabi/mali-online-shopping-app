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
import "package:http/http.dart" as http;

class ProductItemWidget extends StatefulWidget {
  final Product productData;

  ProductItemWidget({super.key, required this.productData});

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget>
    with AutomaticKeepAliveClientMixin {
  bool _isFav = false;
  bool isInit = true;
  late Product product;
  bool isLoading = false;
  bool get isFav {
    return _isFav;
  }

  @override
  initState() {
    product = widget.productData;
    final isLogged =
        Provider.of<AuthController>(context, listen: false).isLogged;

    if (isLogged) {
      toggleFavStatus();
    } else {
      _isFav = false;
    }
    super.initState();
  }

  toggleFavStatus() async {
    setState(() {
      isLoading = true;
    });
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/favourites/$globalUserId/product/${product.prodId}";
    try {
      final fav = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          "Authorization": "Bearer $globalToken"
        },
      );
      if (fav.statusCode != 404) {
        setState(() {
          _isFav = true;
        });
      } else {
        setState(() {
          _isFav = false;
        });
      }
      setState(() {
        isLoading = false;
      });
    } catch (er) {}
  }

  @override
  Widget build(BuildContext context) {
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
                    arguments: [product.prodId, isFav]);
                setState(() {
                  _isFav = favStatus.toString() == "true";
                });
              },
              child: LayoutBuilder(
                builder: (context, bxcst) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            product.images[0],
                          ),
                          fit: BoxFit.cover),
                    ),
                    child: Stack(
                      children: [
                        if (product.priceDiscount != 0) ...{
                          Banner(
                            message: "discount",
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
                    ),
                  );
                },
              ),
            ),
          );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Widget FavIconButton(bool isLogged) {
    return InkWell(
      onTap: () async {
        if (isLogged) {
          setState(() {
            _isFav = !_isFav;
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
            ),
            Text(
              "Tis is the mavi T-shirt can be use for childreen",
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
}
