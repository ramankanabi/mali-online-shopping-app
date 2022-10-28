// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
import '../../../widgets/show_bottom_modal_sheet.dart';

class ProductViewScreen extends StatefulWidget {
  const ProductViewScreen(
      {required this.productId, required this.isFav, Key? key})
      : super(key: key);

  final String productId;
  final bool isFav;

  @override
  State<ProductViewScreen> createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
  bool isInit = true;
  bool isLoading = false;
  int pageIndex = 0;
  late Future _future;
  bool isFav = false;
  int productFavCount = 0;

  @override
  void initState() {
    final isLogged =
        Provider.of<AuthController>(context, listen: false).isLogged;
    if (isLogged) {
      toggleFavStatus();
    } else {
      isFav = false;
    }
    _future = Provider.of<ProductContoller>(context, listen: false)
        .fetchOneProduct(widget.productId);
    super.initState();
  }

  toggleFavStatus() async {
    setState(() {
      isLoading = true;
    });
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/favourites/$globalUserId/product/${widget.productId}";
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
          isFav = true;
        });
      } else {
        setState(() {
          isFav = false;
        });
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
    final isLogged = Provider.of<AuthController>(context).isLogged;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, isFav);

        return false;
      },
      child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            final _product =
                Provider.of<ProductContoller>(context, listen: true).product;
            return Scaffold(
              body: snapshot.connectionState == ConnectionState.waiting ||
                      isLoading
                  ? ProductViewPageLoader()
                  : snapshot.hasData
                      ? SafeArea(
                          child: Padding(
                          padding: const EdgeInsets.all(AppPadding.p8),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ImageCover(
                                  _product,
                                ),
                                NamePriceFav(_product, isLogged),
                                SizedBox(
                                  height: AppSize.s70,
                                  width: double.infinity,
                                  child: SizeView(
                                    _product,
                                  ),
                                ),
                                SizedBox(
                                  height: AppSize.s100,
                                  width: double.infinity,
                                  child: ColorView(
                                    _product,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                DescriptionView(
                                  _product,
                                ),
                              ],
                            ),
                          ),
                        ))
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Oh, somthings goes wrong",
                                style: getMediumStyle(
                                    color: ColorManager.grey,
                                    fontSize: FontSize.s17),
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
                                      color: ColorManager.orange,
                                      fontSize: FontSize.s16),
                                ),
                              )
                            ],
                          ),
                        ),
              persistentFooterButtons: [
                Footer(_product, isLogged),
              ],
            );
          }),
    );
  }

  Widget NamePriceFav(Product product, bool isLogged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.name,
              style: getBoldStyle(
                  color: ColorManager.primary, fontSize: FontSize.s25),
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

  Widget ImageCover(Product product) {
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
                  image: NetworkImage(product.images[index]),
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

  Widget SizeView(Product product) {
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

  Widget ColorView(Product product) {
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
              itemCount: product.relatedProduct?.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: EdgeInsets.all(AppPadding.p5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.r3),
                      child: Container(
                        height: AppSize.s100,
                        width: AppSize.s60,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/images/productImages/p4.jpg",
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

  Widget DescriptionView(Product product) {
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

  Widget Footer(Product product, bool isLoggedd) {
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
}
