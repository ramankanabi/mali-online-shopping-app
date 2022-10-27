import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/controller/auth_contoller.dart';
import 'package:online_shopping/controller/favouite_contoller.dart';
import 'package:online_shopping/model/favourite_model.dart';
import 'package:online_shopping/model/product_model.dart';
import 'package:online_shopping/widgets/show_bottom_modal_sheet.dart';
import 'package:provider/provider.dart';

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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final favStatus = await Navigator.pushNamed(
            context, Routes.productViewScreen,
            arguments: [widget.favourite.prodId, isFav]);
        setState(() {
          _isFav = favStatus.toString() == "true";
        });
      },
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              height: 100,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Image.network(
                      widget.favourite.images[0].toString(),
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.favourite.name.toString(),
                          style: getMediumStyle(
                              color: ColorManager.primary,
                              fontSize: FontSize.s18),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          widget.favourite.price.toString(),
                          style: getMediumStyle(
                              color: ColorManager.orange,
                              fontSize: FontSize.s14),
                        ),
                      ],
                    ),
                  ]),
                  Column(
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
                                await Provider.of<FavouriteContoller>(context,
                                        listen: false)
                                    .removeFavourite(
                                        widget.favourite.prodId.toString(),
                                        globalUserId);
                              } else {
                                setState(() {
                                  _isFav = !_isFav;
                                });
                                await Provider.of<FavouriteContoller>(context,
                                        listen: false)
                                    .addToFavourite(
                                        widget.favourite.prodId.toString(),
                                        globalUserId);
                              }
                            },
                            icon: Icon(
                                isFav
                                    ? CupertinoIcons.heart_fill
                                    : CupertinoIcons.heart,
                                color: ColorManager.orange),
                          ),
                          Container(
                            height: 30,
                            width: 100,
                            color: ColorManager.primary,
                            child: ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    isScrollControlled: true,
                                    context: context,
                                    barrierColor: Colors.black87,
                                    builder: (context) => SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      child: ShowModalBottomSheet(
                                        product: Product(
                                          prodId: widget.favourite.prodId,
                                          size: widget.favourite.size,
                                          quantity: widget.favourite.quantity,
                                          price: widget.favourite.price,
                                          name: widget.favourite.name,
                                          images: widget.favourite.images,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Add to cart",
                                  style: getMediumStyle(
                                      color: ColorManager.white,
                                      fontSize: FontSize.s12),
                                )),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }
}
