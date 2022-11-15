// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:online_shopping/controller/product_controller.dart';
import 'package:online_shopping/resources/assets_manager.dart';
import 'package:online_shopping/resources/color_manager.dart';
import 'package:online_shopping/resources/font_manager.dart';
import 'package:online_shopping/resources/values_manager.dart';
import 'package:online_shopping/widgets/advertise_home_screen_widget.dart';
import 'package:online_shopping/widgets/circle_category_widget.dart';
import 'package:online_shopping/widgets/loader-shimmer-widgets/loader.dart';
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

  bool isLoadMore = false;
  ScrollController gridViewController = ScrollController();
  late List<Product> productData;
  late Future? _future;
  @override
  void initState() {
    super.initState();
    _future = Provider.of<ProductContoller>(context, listen: false)
        .fetchProductData();
    gridViewController.addListener(() async {
      if (gridViewController.position.extentAfter < 400) {
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

  Future onRefresh() async {
    try {
      await Provider.of<ProductContoller>(context, listen: false).resetItem();
      await Provider.of<ProductContoller>(context, listen: false)
          .fetchProductData();
    } catch (er) {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                    const AdvertiseHomeScreenWidget(),
                    const SizedBox(
                      height: 40,
                    ),
                    searchBar(),
                    const SizedBox(
                      height: AppSize.s40,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: AppSize.s150,
                      child: categories(),
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
                        : gridViewProduct(prodactData),
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

  Widget searchBar() {
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

  Widget categories() {
    List<Map> categoryData = [
      {
        "name": "shoes",
        "image": ImageAsset.shoesCategory,
      },
      {
        "name": "bags",
        "image": ImageAsset.bagsCategory,
      },
      {
        "name": "clothes",
        "image": ImageAsset.clothesCategory,
      },
      {
        "name": "eye glasses",
        "image": ImageAsset.eyeGlassesCategory,
      },
      {
        "name": "accessories",
        "image": ImageAsset.accessoriesCategory,
      },
      {
        "name": "beauty",
        "image": ImageAsset.beautyCategory,
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

  Widget gridViewProduct(List<Product> productData) {
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
