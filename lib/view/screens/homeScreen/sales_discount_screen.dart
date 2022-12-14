import 'package:flutter/material.dart';
import 'package:online_shopping/controller/product_controller.dart';
import 'package:online_shopping/resources/color_manager.dart';
import 'package:online_shopping/resources/values_manager.dart';
import 'package:online_shopping/widgets/loader-shimmer-widgets/loader.dart';
import 'package:provider/provider.dart';
import '../../../model/product_model.dart';
import '../../../widgets/product_item_widget.dart';

class SalesDiscountScreen extends StatefulWidget {
  const SalesDiscountScreen({
    super.key,
  });

  @override
  State<SalesDiscountScreen> createState() => _SalesDiscountScreenState();
}

class _SalesDiscountScreenState extends State<SalesDiscountScreen>
    with AutomaticKeepAliveClientMixin<SalesDiscountScreen> {
  late Future _future;
  late ScrollController gridViewController = ScrollController();
  bool isInit = true;
  @override
  void initState() {
    _future = Provider.of<ProductContoller>(context, listen: false)
        .fetchAdvertiseProductData();

    gridViewController.addListener(() async {
      if (gridViewController.position.extentAfter < 300) {
        if (isInit == true) {
          isInit = false;
          await Provider.of<ProductContoller>(context, listen: false)
              .advertiseloadMore()
              .then((_) {
            isInit = true;
          });
        }
      }
    });
    super.initState();
  }

  Future _onRefresh() async {
    Provider.of<ProductContoller>(context, listen: false).resetAdvertiseItem();
    await Provider.of<ProductContoller>(context, listen: false)
        .fetchAdvertiseProductData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        backgroundColor: ColorManager.white,
        appBar: AppBar(
          title: const Text(
            "Sales discount",
          ),
        ),
        body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            final productData =
                Provider.of<ProductContoller>(context).advertiseItems;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loader();
            } else if (productData.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(AppPadding.p8),
                child: gridViewProduct(productData),
              );
            } else {
              return const Loader();
            }
          },
        ),
      ),
    );
  }

  Widget gridViewProduct(List<Product> productData) {
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
