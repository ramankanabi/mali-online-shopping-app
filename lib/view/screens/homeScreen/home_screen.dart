// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:online_shopping/cacheManager/image_cache_manager.dart';
import 'package:online_shopping/controller/product_controller.dart';
import 'package:online_shopping/resources/color_manager.dart';
import 'package:online_shopping/resources/font_manager.dart';
import 'package:online_shopping/resources/values_manager.dart';
import 'package:online_shopping/widgets/circle_category_widget.dart';
import 'package:online_shopping/widgets/loader-shimmer-widgets/loader.dart';
import 'package:online_shopping/widgets/slide_dots.dart';
import 'package:online_shopping/widgets/time_countdown_widget.dart';
import 'package:provider/provider.dart';
import '../../../model/product_model.dart';
import '../../../resources/routes_manager.dart';
import '../../../widgets/product_item_widget.dart';
import '/resources/style_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  bool isInit = true;
  bool isLoading = false;
  int advertisePageIndex = 0;
  bool isLoadMore = false;
  ScrollController gridViewController = ScrollController();
  late List<Product> productData;
  late Future? _future;
  @override
  void initState() {
    super.initState();
    ImageCacheManager().getImageCache();
    _future = Provider.of<ProductContoller>(context, listen: false)
        .fetchProductData();
    gridViewController.addListener(() async {
      if (gridViewController.position.extentAfter < 50) {
        if (isInit == true) {
          isInit = false;
          Provider.of<ProductContoller>(context, listen: false)
              .loadMore()
              .then((_) {
            isInit = true;
          });
        }
      }
    });
  }

  onChangedPage(int index) {
    setState(() {
      advertisePageIndex = index;
    });
  }

  Future onRefresh() async {
    try {
      await Provider.of<ProductContoller>(context, listen: false).resetItem();
      await Provider.of<ProductContoller>(context, listen: false)
          .fetchProductData();
    } catch (er) {
      print(er);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: FutureBuilder(
          future: _future,
          builder: (
            context,
            snapshot,
          ) {
            final prodactData =
                Provider.of<ProductContoller>(context, listen: true).items;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            } else {
              return Padding(
                padding: const EdgeInsets.all(AppPadding.p14),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  controller: gridViewController,
                  children: [
                    const SizedBox(
                      height: AppSize.s20,
                    ),
                    Text(
                      "Mali",
                      style: getTextStyle(
                          FontSize.s60,
                          FontConstants.fontFamily,
                          FontWeightManager.bold,
                          ColorManager.primary),
                    ),
                    const SizedBox(
                      height: AppSize.s20,
                    ),
                    AdvertiseView(),
                    const SizedBox(
                      height: 40,
                    ),
                    SearchBar(),
                    const SizedBox(
                      height: AppSize.s40,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: AppSize.s150,
                      child: Categories(),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text("Most popular",
                          style: getBoldStyle(
                              color: ColorManager.primary,
                              fontSize: FontSize.s20)),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                            color: ColorManager.orange,
                          ))
                        : GridViewProduct(prodactData),
                    isLoadMore
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              color: ColorManager.orange,
                            ),
                          )
                        : Container(),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget AdvertiseView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              allowImplicitScrolling: true,
              onPageChanged: onChangedPage,
              itemCount: 5,
              itemBuilder: (ctx, index) => Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                          context, Routes.salesDiscountScreenScreen);
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/cover3.jpg",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 30,
                    top: 50,
                    child: Column(
                      children: [
                        Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Text(
                              "New Year Sale !",
                              style: getBoldStyle(
                                  color: ColorManager.white,
                                  fontSize: FontSize.s20),
                            )),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Text(
                            "Up To 25% Off",
                            style: getBoldStyle(
                                color: ColorManager.white,
                                fontSize: FontSize.s25),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        TimeCouuntDown()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 5; i++) ...{
                  if (i == advertisePageIndex)
                    SlideDots(true)
                  else
                    SlideDots(false)
                }
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget SearchBar() {
    return TextField(
      readOnly: true,
      cursorColor: ColorManager.cursorColor,
      style: getRegularStyle(
          color: ColorManager.primaryOpacity70, fontSize: FontSize.s16),
      decoration: InputDecoration(
        focusColor: ColorManager.cursorColor,
        contentPadding: const EdgeInsets.all(AppPadding.p8),
        prefixIcon: Icon(
          Icons.search,
          color: ColorManager.primaryOpacity70,
        ),
        prefixIconColor: ColorManager.darkGrey,
        hintText: "search",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSize.s30),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorManager.primary),
          borderRadius: BorderRadius.circular(AppSize.s30),
        ),
      ),
      onTap: () {
        Navigator.pushNamed(context, Routes.searchScreen);
      },
    );
  }

  Widget Categories() {
    List<Map> categoryData = [
      {
        "name": "shoes",
        "image": "assets/images/categoriesIcon/shoes.png",
      },
      {
        "name": "bags",
        "image": "assets/images/categoriesIcon/handbag.png",
      },
      {
        "name": "clothes",
        "image": "assets/images/categoriesIcon/clothes.png",
      },
      {
        "name": "eye glasses",
        "image": "assets/images/categoriesIcon/sunglass.png",
      },
      {
        "name": "jewelries",
        "image": "assets/images/categoriesIcon/jewelry.png",
      },
      {
        "name": "makeups",
        "image": "assets/images/categoriesIcon/makeup.png",
      }
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Categories",
          style:
              getBoldStyle(color: ColorManager.primary, fontSize: FontSize.s20),
        ),
        SizedBox(
          height: AppSize.s110,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: categoryData.length,
              itemBuilder: (context, index) {
                return CircleCategoryWidget(
                  category: categoryData[index]["name"],
                  image: categoryData[index]["image"],
                );
              }),
        ),
      ],
    );
  }

  Widget GridViewProduct(List<Product> productData) {
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
  }
}
