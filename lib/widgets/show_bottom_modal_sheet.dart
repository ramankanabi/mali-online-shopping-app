import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/controller/auth_contoller.dart';
import 'package:online_shopping/controller/cart_controller.dart';
import 'package:online_shopping/model/cart_model.dart';
import 'package:provider/provider.dart';

import '../model/product_model.dart';
import '../resources/color_manager.dart';
import '../resources/font_manager.dart';
import '../resources/style_manager.dart';
import '../resources/values_manager.dart';
import '../cacheManager/image_cache_manager.dart' as cache;

class ShowModalBottomSheet extends StatefulWidget {
  const ShowModalBottomSheet({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  State<ShowModalBottomSheet> createState() => _ShowModalBottomSheetState();
}

class _ShowModalBottomSheetState extends State<ShowModalBottomSheet> {
  late Cart _cart;
  int sizeButtonIndex = 0;
  int quantity = 1;
  late String pickedSize;
  onPick(int index, String size) {
    setState(() {
      pickedSize = size;
      sizeButtonIndex = index;
    });
  }

  @override
  void initState() {
    pickedSize = widget.product.size[0];
    _cart = Cart(
      customerId: globalUserId,
      productId: widget.product.prodId,
      productName: widget.product.name,
      images: widget.product.images,
      quantity: 1,
      size: '',
      price: double.parse(widget.product.price.toString()),
      objectId: "",
    );
    super.initState();
  }

  Widget NameAndImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.product.name,
          style: getBoldStyle(
            color: ColorManager.primary,
            fontSize: FontSize.s25,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: AppSize.s100,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.product.images.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.all(AppPadding.p5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.r3),
                      child: Container(
                        height: AppSize.s100,
                        width: AppSize.s60,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                widget.product.images[index],
                                cacheManager:
                                    cache.ImageCacheManager().cacheManager,
                              ),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ));
              }),
        ),
      ],
    );
  }

  Widget SizesView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "choose a size",
          style: getMediumStyle(
              color: ColorManager.darkGrey, fontSize: FontSize.s20),
        ),
        const SizedBox(
          height: 10,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (int i = 0; i < widget.product.size.length; i++) ...{
                Padding(
                  padding: const EdgeInsets.all(AppPadding.p5),
                  child: OutlinedButton(
                    onPressed: () => onPick(i, widget.product.size[i]),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.r10),
                        ),
                      ),
                      overlayColor: MaterialStateProperty.all<Color>(
                        ColorManager.orange.withOpacity(0.08),
                      ),
                      side: MaterialStateProperty.all(
                        BorderSide(
                            color: sizeButtonIndex == i
                                ? ColorManager.orange
                                : ColorManager.grey),
                      ),
                    ),
                    child: Text(
                      widget.product.size[i],
                      style: getRegularStyle(
                          color: sizeButtonIndex == i
                              ? ColorManager.orange
                              : ColorManager.darkGrey,
                          fontSize: FontSize.s16),
                    ),
                  ),
                ),
              }
            ],
          ),
        )
      ],
    );
  }

  Widget Quantity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "quantity",
          style: getMediumStyle(
              color: ColorManager.darkGrey, fontSize: FontSize.s20),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              onPressed: () {
                if (quantity < widget.product.quantity) {
                  setState(() {
                    quantity++;
                  });
                }
              },
              icon: const Icon(Icons.add_circle_outline),
              splashRadius: 20,
              splashColor: ColorManager.grey.withOpacity(0.2),
            ),
            Text(
              quantity.toString(),
              style: getMediumStyle(
                  color: ColorManager.darkGrey, fontSize: FontSize.s20),
            ),
            IconButton(
              onPressed: () {
                if (quantity > 0) {
                  setState(() {
                    quantity--;
                  });
                }
              },
              icon: const Icon(Icons.remove_circle_outline),
              splashRadius: 20,
              splashColor: ColorManager.grey.withOpacity(0.2),
            ),
          ],
        )
      ],
    );
  }

  Widget AddToCart() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          _cart = Cart(
            customerId: globalUserId,
            productId: _cart.productId,
            productName: _cart.productName,
            images: _cart.images,
            quantity: quantity,
            size: pickedSize,
            price: _cart.price,
            objectId: "",
          );
          await Provider.of<CartController>(context, listen: false)
              .addCart(_cart);
          if (mounted) {
            Navigator.pop(context);
          }
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(ColorManager.orange),
        ),
        child: Container(
          alignment: Alignment.center,
          width: AppSize.s300,
          height: AppSize.s40,
          child: Text(
            "Add To Cart",
            style:
                getBoldStyle(color: ColorManager.white, fontSize: FontSize.s18),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NameAndImages(),
          SizesView(),
          Quantity(),
          AddToCart(),
        ],
      ),
    );
  }
}
