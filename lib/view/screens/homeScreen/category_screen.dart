import 'package:flutter/material.dart';
import 'package:online_shopping/controller/product_controller.dart';
import 'package:online_shopping/resources/color_manager.dart';
import 'package:online_shopping/resources/font_manager.dart';
import 'package:online_shopping/resources/style_manager.dart';
import 'package:online_shopping/resources/values_manager.dart';
import 'package:online_shopping/widgets/circle_category_widget.dart';
import 'package:online_shopping/widgets/loader-shimmer-widgets/loader.dart';
import 'package:provider/provider.dart';
import '../../../model/product_model.dart';
import '../../../widgets/product_item_widget.dart';

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
  @override
  void initState() {
    _future = Provider.of<ProductContoller>(context, listen: false)
        .fetchCategoryProductData(widget.categoryName);

    gridViewController.addListener(() async {
      if (gridViewController.position.extentAfter < 300) {
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
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          title: Text(
            widget.categoryName,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(AppPadding.p8),
              child: TextButton(
                child: Text(
                  "category",
                  style: getBoldStyle(
                      color: ColorManager.orange, fontSize: FontSize.s14),
                ),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => ShowCategoryDialog());
                },
              ),
            )
          ],
        ),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            final productData =
                Provider.of<ProductContoller>(context).categoryItems;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            } else if (productData.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(AppPadding.p8),
                child: GridViewProduct(productData),
              );
            } else {
              return const Loader();
            }
          },
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

  Widget ShowCategoryDialog() {
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
    return Dialog(
      elevation: 20,
      backgroundColor: Colors.transparent,
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40)),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2),
          itemCount: categoryData.length,
          itemBuilder: (context, index) {
            return CircleCategoryWidget(
                category: categoryData[index]["name"],
                image: categoryData[index]["image"]);
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
