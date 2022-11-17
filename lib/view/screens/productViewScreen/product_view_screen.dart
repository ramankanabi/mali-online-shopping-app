// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/controller/product_controller.dart';
import 'package:online_shopping/resources/color_manager.dart';
import 'package:online_shopping/resources/font_manager.dart';
import 'package:online_shopping/resources/style_manager.dart';
import 'package:online_shopping/resources/values_manager.dart';
import 'package:online_shopping/widgets/loader-shimmer-widgets/product_view_page_loader.dart';
import 'package:online_shopping/widgets/slide_dots.dart';
import 'package:provider/provider.dart';

import '../../../controller/auth_contoller.dart';
import '../../../controller/favouite_contoller.dart';
import '../../../model/product_model.dart';
import '../../../resources/routes_manager.dart';
import '../../../widgets/product_item_widget.dart';
import '../../../widgets/show_bottom_modal_sheet.dart';
import '../../../cacheManager/image_cache_manager.dart' as cache;

class ProductViewScreen extends StatefulWidget {
  const ProductViewScreen({required this.productId, Key? key})
      : super(key: key);

  final String productId;

  @override
  State<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen>
    with AutomaticKeepAliveClientMixin {
  bool isInit = true;
  bool isLoading = false;
  int pageIndex = 0;
  bool isFav = false;
  int productFavCount = 0;
  Product? product;

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  fetchData() async {
    try {
      isLoading = true;

      final isLogged =
          Provider.of<AuthController>(context, listen: false).isLogged;
      product = await ProductContoller().fetchOneProduct(widget.productId);
      if (isLogged) {
        isFav = await FavouriteContoller()
            .getFavourite(widget.productId, globalUserId);
      } else {
        isFav = false;
      }
      setState(() {
        isLoading = false;
      });
    } catch (er) {}
  }

  _onPageChanged(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isLogged = Provider.of<AuthController>(context).isLogged;
    return WillPopScope(
        onWillPop: () async {
          Navigator.pop(context, isFav);

          return false;
        },
        child: Scaffold(
          body: isLoading
              ? ProductViewPageLoader()
              : product != null
                  ? SafeArea(
                      child: Padding(
                      padding: const EdgeInsets.all(AppPadding.p8),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            imageCover(
                              product!,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            namePriceFav(product!, isLogged),
                            SizedBox(
                              height: AppSize.s70,
                              width: double.infinity,
                              child: sizeView(
                                product!,
                              ),
                            ),
                            if (product!.relatedProduct!.isNotEmpty) ...{
                              SizedBox(
                                height: AppSize.s100,
                                width: double.infinity,
                                child: colorView(
                                  product!,
                                ),
                              ),
                            },
                            SizedBox(
                              height: 15,
                            ),
                            descriptionView(
                              product!,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 1,
                                  ),
                                ),
                                Text(
                                  "   similar products   ",
                                  style: getMediumStyle(
                                    color: ColorManager.grey,
                                    fontSize: FontSize.s16,
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    // height: 21,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SimilarProducts(
                              category: product!.category!,
                            ),
                          ],
                        ),
                      ),
                    ))
                  : somthingWrong(),
          persistentFooterButtons: [
            product != null ? footer(product!, isLogged) : Container(),
          ],
        ));
  }

  Widget namePriceFav(Product product, bool isLogged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                product.name,
                style: getBoldStyle(
                    color: ColorManager.primary, fontSize: FontSize.s25),
                softWrap: true,
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                    color: isFav ? ColorManager.orange : ColorManager.darkGrey,
                    size: 30,
                  ),
                  onPressed: () async {
                    if (isLogged) {
                      setState(() {
                        isFav = !isFav;
                      });
                      if (isFav == true) {
                        await Provider.of<FavouriteContoller>(context,
                                listen: false)
                            .addToFavourite(product.prodId, globalUserId);
                      } else {
                        await Provider.of<FavouriteContoller>(context,
                                listen: false)
                            .removeFavourite(product.prodId, globalUserId);
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Should Log in :)"),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ],
        ),
        if (product.priceDiscount == 0) ...{
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: product.price.toString(),
                  style: getBoldStyle(
                      color: ColorManager.orange, fontSize: FontSize.s20),
                ),
                TextSpan(
                  text: " IQD",
                  style: getBoldStyle(
                      color: ColorManager.orange, fontSize: FontSize.s16),
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
                        fontSize: FontSize.s16,
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
                          fontSize: FontSize.s12),
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
                          color: ColorManager.orange, fontSize: FontSize.s20),
                    ),
                    TextSpan(
                      text: " IQD",
                      style: getBoldStyle(
                          color: ColorManager.orange, fontSize: FontSize.s16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        }
      ],
    );
  }

  Widget imageCover(Product product) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          width: double.infinity,
          height: AppSize.s400,
          child: PageView.builder(
            onPageChanged: _onPageChanged,
            itemCount: product.images.length,
            itemBuilder: (context, index) => Container(
              width: double.infinity,
              height: AppSize.s400,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    product.images[index],
                    cacheManager: cache.ImageCacheManager().cacheManager,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: Icon(Icons.share_outlined),
            color: ColorManager.darkGrey,
            splashColor: ColorManager.white,
            onPressed: () {},
          ),
        ),
        Positioned(
          bottom: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < product.images.length; i++) ...{
                if (i == pageIndex)
                  SlideDots(
                    true,
                  )
                else
                  SlideDots(false)
              }
            ],
          ),
        ),
        Positioned(
            left: 0,
            top: 0,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back,
                size: 25,
                color: ColorManager.darkGrey,
              ),
              splashColor: ColorManager.white,
              onPressed: () {
                Navigator.pop(context);
              },
            ))
      ],
    );
  }

  Widget sizeView(Product product) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "size",
            style: getMediumStyle(
              color: ColorManager.darkGrey,
              fontSize: FontSize.s20,
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          width: MediaQuery.of(context).size.width / 1.5,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: product.size.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.all(AppPadding.p5),
                  child: Chip(
                    label: Text(
                      product.size[index].toString(),
                      style: getMediumStyle(color: ColorManager.grey1),
                    ),
                    backgroundColor: ColorManager.white,
                    side: BorderSide(width: AppSize.s0_5),
                  ),
                );
              }),
        ),
      ],
    );
  }

  Widget colorView(Product product) {
    return Row(
      children: [
        Expanded(
          child: Text(
            "color",
            style: getMediumStyle(
              color: ColorManager.darkGrey,
              fontSize: FontSize.s20,
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          width: MediaQuery.of(context).size.width / 1.5,
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: product.relatedProduct!.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.all(AppPadding.p5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.r3),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.productViewScreen,
                              arguments: [
                                product.relatedProduct?[index]["productId"]
                              ]);
                        },
                        child: Container(
                          height: AppSize.s100,
                          width: AppSize.s60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: CachedNetworkImageProvider(
                                  product.relatedProduct![index]["images"][0],
                                ),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ));
              }),
        ),
      ],
    );
  }

  Widget descriptionView(Product product) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "description",
            style: getMediumStyle(
              color: ColorManager.darkGrey,
              fontSize: FontSize.s20,
            ),
          ),
        ),
        Container(
          alignment: Alignment.topLeft,
          width: MediaQuery.of(context).size.width / 1.5,
          child: Text(
            product.discreption_EN.toString(),
            maxLines: 5,
            softWrap: true,
            style: getRegularStyle(
                color: ColorManager.grey, fontSize: FontSize.s16),
            textAlign: TextAlign.justify,
          ),
        )
      ],
    );
  }

  Widget footer(Product product, bool isLoggedd) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.all(AppPadding.p5),
            child: ElevatedButton(
              onPressed: () {
                if (isLoggedd) {
                  if (product != null) {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      barrierColor: Colors.black87,
                      builder: (context) => SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: ShowModalBottomSheet(
                          product: product,
                        ),
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Should Log in :)"),
                    ),
                  );
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
                  style: getBoldStyle(
                      color: ColorManager.white, fontSize: FontSize.s18),
                ),
              ),
            )),
      ],
    );
  }

  Widget somthingWrong() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Oh, somthings goes wrong",
            style: getMediumStyle(
                color: ColorManager.grey, fontSize: FontSize.s17),
          ),
          SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              "Go Back",
              style: getMediumStyle(
                  color: ColorManager.orange, fontSize: FontSize.s16),
            ),
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SimilarProducts extends StatefulWidget {
  const SimilarProducts({super.key, required this.category});
  final String category;

  @override
  State<SimilarProducts> createState() => _SimilarProductsState();
}

class _SimilarProductsState extends State<SimilarProducts> {
  late Future _future;
  @override
  void initState() {
    _future = Provider.of<ProductContoller>(context, listen: false)
        .similarProducts(widget.category);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else if (snapshot.hasData) {
            final productData =
                Provider.of<ProductContoller>(context, listen: false)
                    .similarProdctItems;
            return GridView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              shrinkWrap: true, // You won't see infinite size error
              itemCount: productData.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                          spreadRadius: 1.5,
                          blurRadius: 10,
                          color: Colors.grey.shade300),
                    ],
                  ),
                  child: ProductItemWidget(
                    productData: productData[index],
                  ),
                );
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1 / 1.5,
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
