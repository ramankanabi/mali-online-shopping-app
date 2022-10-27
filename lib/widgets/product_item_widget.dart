// ignore_for_file: sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/controller/auth_contoller.dart';
import 'package:online_shopping/controller/favouite_contoller.dart';
import 'package:online_shopping/resources/routes_manager.dart';
import 'package:online_shopping/widgets/loader-shimmer-widgets/product_item_loader.dart';
import 'package:provider/provider.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/style_manager.dart';
import '../resources/values_manager.dart';
import "package:http/http.dart" as http;
import 'package:shimmer/shimmer.dart';

class ProductItemWidget extends StatefulWidget {
  final String productName;
  final String prodId;
  final int price;
  final String imagePath;
  const ProductItemWidget({
    super.key,
    required this.prodId,
    required this.productName,
    required this.price,
    required this.imagePath,
  });

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget>
    with AutomaticKeepAliveClientMixin {
  bool _isFav = false;
  bool isInit = true;
  // late Future _future;
  bool isLoading = false;
  bool get isFav {
    return _isFav;
  }

  @override
  initState() {
    // _future = Provider.of<FavouriteContoller>(context, listen: false)
    //     .getFavourite(widget.prodId, globalUserId);
    toggleFavStatus();
    // TODO: implement initState
    super.initState();
  }

  toggleFavStatus() async {
    setState(() {
      isLoading = true;
    });
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/favourites/$globalUserId/product/${widget.prodId}";
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
    return isLoading
        ? const Center(child: ProductItemLoader())
        : ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.r12),
            child: GestureDetector(
              onTap: () async {
                final favStatus = await Navigator.pushNamed(
                    context, Routes.productViewScreen,
                    arguments: [widget.prodId, isFav]);
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
                            widget.imagePath,
                          ),
                          fit: BoxFit.cover),
                    ),
                    child: Stack(
                      children: [
                        Positioned(right: 5, top: 5, child: FavIconButton()),
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

  Widget FavIconButton() {
    return InkWell(
      onTap: () async {
        setState(() {
          _isFav = !_isFav;
        });
        isFav == true
            ? await Provider.of<FavouriteContoller>(context, listen: false)
                .addToFavourite(widget.prodId, globalUserId)
            : await Provider.of<FavouriteContoller>(context, listen: false)
                .removeFavourite(widget.prodId, globalUserId);
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
              widget.productName,
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
            Text(
              "${widget.price} IQD",
              style: getBoldStyle(
                  color: ColorManager.orange, fontSize: FontSize.s16),
            ),
          ],
        ),
      ),
    );
  }
}
