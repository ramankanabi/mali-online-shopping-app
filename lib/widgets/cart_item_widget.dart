import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/controller/cart_controller.dart';
import 'package:online_shopping/model/cart_model.dart';
import 'package:online_shopping/resources/values_manager.dart';
import 'package:provider/provider.dart';

import '../controller/favouite_contoller.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/routes_manager.dart';
import '../resources/style_manager.dart';
import '../cacheManager/image_cache_manager.dart' as cache;

class CartItem extends StatefulWidget {
  const CartItem({super.key, required this.cart});
  final Cart cart;
  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem>
    with AutomaticKeepAliveClientMixin {
  late Cart cart;
  late int quantity;
  late double subTotal;
  bool isLoading = false;
  bool isRemoved = false;
  late Future _future;
  bool _isFav = false;

  bool get isFav {
    return _isFav;
  }

  @override
  void initState() {
    cart = widget.cart;
    quantity = cart.quantity;
    subTotal = cart.subTotalPrice!.toDouble();
    _future = Provider.of<FavouriteContoller>(context, listen: false)
        .getFavourite(cart.productId, cart.customerId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isRemoved
        ? Container()
        : FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              _isFav =
                  Provider.of<FavouriteContoller>(context, listen: false).isFav;
              return snapshot.data == null
                  ? Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.orange,
                        strokeWidth: 2,
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.productViewScreen,
                            arguments: [cart.productId, isFav]);
                      },
                      child: Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(AppPadding.p8),
                            child: SizedBox(
                              height: AppSize.s150,
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    imageWidget(),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cart.productName,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: getMediumStyle(
                                                  color: ColorManager.primary,
                                                  fontSize: FontSize.s20),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              subTotal.toString(),
                                              style: getMediumStyle(
                                                  color: ColorManager.orange,
                                                  fontSize: FontSize.s16),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              cart.size,
                                              style: getRegularStyle(
                                                  color: ColorManager.lightGrey,
                                                  fontSize: FontSize.s14),
                                            )
                                          ]),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              removeProductFromCart(cart);
                                            },
                                            child: Icon(
                                              CupertinoIcons.delete,
                                              color: ColorManager.grey,
                                              size: 22,
                                            ),
                                          ),
                                          quantityWidget(),
                                        ],
                                      ),
                                    ),
                                  ]),
                            ),
                          )));
            });
  }

  void removeProductFromCart(Cart cart) async {
    try {
      setState(() {
        isRemoved = true;
      });
      await Provider.of<CartController>(context, listen: false)
          .removeProductFromCart(cart);
    } catch (er) {
      setState(() {
        isRemoved = false;
      });
    }
  }

  void decreaseQuantity() async {
    try {
      if (quantity > 1) {
        setState(() {
          isLoading = true;
          quantity--;
        });
        await Provider.of<CartController>(context, listen: false)
            .updateQuantity(cart.objectId, quantity);
        subTotal = quantity * cart.price;
        setState(() {
          isLoading = false;
        });
      }
    } catch (er) {
      setState(() {
        quantity++;
      });
    }
  }

  void increaseQuantity() async {
    try {
      if (quantity < 11) {
        setState(() {
          isLoading = true;
          quantity++;
        });
        await Provider.of<CartController>(context, listen: false)
            .updateQuantity(cart.objectId, quantity);
        subTotal = quantity * cart.price;
        setState(() {
          isLoading = false;
        });
      }
    } catch (er) {
      setState(() {
        quantity--;
      });
    }
  }

  Widget quantityWidget() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.r15),
      ),
      elevation: 3,
      child: Container(
          width: AppSize.s90,
          height: AppSize.s30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.r20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                radius: 30,
                borderRadius: BorderRadius.circular(AppRadius.r10),
                splashColor: ColorManager.grey.withOpacity(0.3),
                onTap: () async {
                  decreaseQuantity();
                },
                child: Icon(
                  CupertinoIcons.minus,
                  color: ColorManager.grey,
                  size: 22,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              isLoading
                  ? SizedBox(
                      height: 10,
                      width: 10,
                      child: CircularProgressIndicator(
                        color: ColorManager.orange,
                        strokeWidth: 1,
                      ),
                    )
                  : Text(
                      quantity.toString(),
                      style: getMediumStyle(
                          color: ColorManager.darkGrey, fontSize: FontSize.s20),
                    ),
              const SizedBox(
                width: 5,
              ),
              InkWell(
                radius: AppRadius.r30,
                borderRadius: BorderRadius.circular(AppRadius.r10),
                splashColor: ColorManager.orange.withOpacity(0.3),
                onTap: () async {
                  increaseQuantity();
                },
                child: Icon(
                  CupertinoIcons.plus,
                  color: ColorManager.orange,
                  size: 22,
                ),
              ),
            ],
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget imageWidget() {
    return CachedNetworkImage(
      imageUrl: cart.images[0],
      fit: BoxFit.cover,
      cacheManager: cache.ImageCacheManager().cacheManager,
    );
  }
}
