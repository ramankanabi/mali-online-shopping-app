import 'package:flutter/material.dart';
import 'package:online_shopping/controller/product_controller.dart';
import 'package:online_shopping/resources/color_manager.dart';
import 'package:online_shopping/resources/values_manager.dart';
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

          // ignore: prefer_const_literals_to_create_immutables
          actions: [
            const Padding(
              padding: EdgeInsets.all(AppPadding.p8),
              child: Icon(Icons.format_list_bulleted_sharp),
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
              return ProductItemWidget(
                productName: productData[index].name,
                prodId: productData[index].prodId,
                price: productData[index].price,
                imagePath: productData[index].images[0],
              );
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
