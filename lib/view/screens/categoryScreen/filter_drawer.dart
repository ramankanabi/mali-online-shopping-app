import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/controller/filter_product_controller.dart';
import 'package:online_shopping/controller/product_controller.dart';
import 'package:online_shopping/view/screens/categoryScreen/color_filter_dawer.dart';
import 'package:online_shopping/view/screens/categoryScreen/price_filter_drawer.dart';
import 'package:provider/provider.dart';

import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/style_manager.dart';
import 'category_filter_drawer.dart';

class FilterDrawer extends StatefulWidget {
  const FilterDrawer({Key? key, required this.categoryName}) : super(key: key);
  final String categoryName;

  @override
  State<FilterDrawer> createState() => _FilterDrawerState();
}

class _FilterDrawerState extends State<FilterDrawer> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _drawer = Drawer(
    backgroundColor: ColorManager.orange,
  );

  Widget get drawer => _drawer;

  @override
  Widget build(BuildContext context) {
    final categoryFilter =
        Provider.of<FilterProductController>(context).filterList["category"];
    final maxPriceFilter =
        Provider.of<FilterProductController>(context).filterList["maxPrice"];
    final minPriceFilter =
        Provider.of<FilterProductController>(context).filterList["minPrice"];
    final colorFilter =
        Provider.of<FilterProductController>(context).filterList["color"];
    String priceFilter = "$minPriceFilter ~ $maxPriceFilter";
    return Drawer(
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer: drawer,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  title: Text(
                    "Filter",
                    style: getMediumStyle(
                        color: ColorManager.grey, fontSize: FontSize.s18),
                  ),
                  elevation: 0.2,
                  actions: [
                    TextButton(
                        onPressed: () {
                          clearFilter();
                        },
                        child: Text(
                          "clear",
                          style: getMediumStyle(color: ColorManager.orange),
                        ))
                  ],
                ),
                FilterListTile("Category", categoryFilter!, () {
                  openDrawer(const CategoryDrawer());
                }),
                FilterListTile("Price", priceFilter == " ~ " ? "" : priceFilter,
                    () {
                  openDrawer(const PriceDrawer());
                }),
                FilterListTile("Color", colorFilter!, () {
                  openDrawer(const ColorDrawer());
                }),
              ],
            ),
            InkWell(
              onTap: () {
                applyFilter();
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: double.infinity,
                color: ColorManager.orange,
                child: Text(
                  "Apply",
                  style: getBoldStyle(
                    color: ColorManager.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget FilterListTile(String title, String filter, Function onPress) {
    return ListTile(
      title: Text(title,
          style: getMediumStyle(
              color: ColorManager.darkGrey, fontSize: FontSize.s14)),
      subtitle: filter.isEmpty
          ? null
          : Text(
              filter,
              style: getRegularStyle(color: ColorManager.orange),
            ),
      trailing: IconButton(
          onPressed: () => onPress(),
          icon: const Icon(
            CupertinoIcons.forward,
            size: 15,
          )),
      shape: const Border(bottom: BorderSide(width: 0.2)),
    );
  }

  openDrawer(Widget drawer) {
    _drawer = drawer;
    setState(() {});
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void clearFilter() {
    Provider.of<FilterProductController>(context, listen: false).clearFilter();
    final query =
        Provider.of<FilterProductController>(context, listen: false).getQuery();
    Provider.of<ProductContoller>(context, listen: false)
        .resetCategoryProductItem();
    Provider.of<ProductContoller>(context, listen: false)
        .fetchCategoryProductData(query);
    Navigator.pop(context);
  }

  void applyFilter() {
    final query =
        Provider.of<FilterProductController>(context, listen: false).getQuery();

    Provider.of<ProductContoller>(context, listen: false)
        .resetCategoryProductItem();
    Provider.of<ProductContoller>(context, listen: false)
        .fetchCategoryProductData(query);

    Navigator.pop(context);
  }
}
