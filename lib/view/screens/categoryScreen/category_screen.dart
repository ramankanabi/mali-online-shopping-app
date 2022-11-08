import 'dart:async';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/controller/product_controller.dart';
import 'package:online_shopping/resources/color_manager.dart';
import 'package:online_shopping/resources/style_manager.dart';
import 'package:online_shopping/resources/values_manager.dart';
import 'package:online_shopping/widgets/loader-shimmer-widgets/loader.dart';
import 'package:provider/provider.dart';
import '../../../controller/filter_product_controller.dart';
import '../../../model/product_model.dart';
import '../../../resources/font_manager.dart';
import '../../../widgets/product_item_widget.dart';
import 'filter_drawer.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryName;
  const CategoryScreen({super.key, required this.categoryName});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with AutomaticKeepAliveClientMixin<CategoryScreen> {
  late Future _future;
  late ScrollController gridViewController = ScrollController();
  bool isInit = true;
  bool isFilter = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    _future = Provider.of<ProductContoller>(context, listen: false)
        .fetchCategoryProductData(widget.categoryName);

    gridViewController.addListener(() async {
      if (gridViewController.position.extentAfter < 50) {
        if (isInit == true) {
          isInit = false;
          await Provider.of<ProductContoller>(context, listen: false)
              .categoryloadMore(widget.categoryName)
              .then((_) {
            isInit = true;
          });
        }
      }
    });
    super.initState();
  }

  Future _onRefresh() async {
    Provider.of<ProductContoller>(context, listen: false)
        .resetCategoryProductItem();

    await Provider.of<ProductContoller>(context, listen: false)
        .fetchCategoryProductData(widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    final isFiltered =
        Provider.of<FilterProductController>(context, listen: true)
            .getFilterStatus();

    return WillPopScope(
      onWillPop: () async {
        await Provider.of<FilterProductController>(context, listen: false)
            .clearFilter();
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: FilterDrawer(
          categoryName: widget.categoryName,
        ),
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          title: Text(
            widget.categoryName,
          ),
          actions: [
            IconButton(
              icon: Badge(
                padding: const EdgeInsets.all(AppPadding.p5),
                position: const BadgePosition(end: -5, top: -5),
                showBadge: isFiltered,
                badgeColor: ColorManager.orange.withOpacity(0.8),
                child: Icon(
                  CupertinoIcons.square_fill_line_vertical_square,
                  color: ColorManager.grey,
                ),
              ),
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              final productData =
                  Provider.of<ProductContoller>(context).categoryItems;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loader();
              } else if (snapshot.connectionState == ConnectionState.done) {
                return Padding(
                  padding: const EdgeInsets.all(AppPadding.p8),
                  child: GridViewProduct(productData),
                );
              } else {
                return Center(
                  child: Text(
                    "somethings went wrong",
                    style: getMediumStyle(
                      color: ColorManager.grey,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget GridViewProduct(List<Product> productData) {
    return SingleChildScrollView(
      controller: gridViewController,
      child: Column(
        children: [
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
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
                  child: ProductItemWidget(productData: productData[index]));
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1 / 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
