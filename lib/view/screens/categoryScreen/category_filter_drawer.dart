import 'package:flutter/material.dart';
import 'package:online_shopping/controller/product_controller.dart';
import 'package:provider/provider.dart';

import '../../../controller/filter_product_controller.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/style_manager.dart';

class CategoryDrawer extends StatefulWidget {
  const CategoryDrawer({super.key});

  @override
  State<CategoryDrawer> createState() => _CategoryDrawerState();
}

class _CategoryDrawerState extends State<CategoryDrawer> {
  List<dynamic> filterList = [];

  final List categoryList = [
    "Shoes",
    "Bags",
    "Clothes",
    "eye glass",
    "Jewelries",
    "Makeups",
  ];
  List isSelectedList = [];
  @override
  void initState() {
    final categoryFilterList =
        Provider.of<FilterProductController>(context, listen: false)
            .filterList["category"];
    isSelectedList = List.generate(categoryList.length, (i) {
      if (categoryFilterList!.contains(categoryList[i])) {
        return true;
      } else {
        return false;
      }
    });
    filterList = categoryFilterList!.toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            AppBar(
              automaticallyImplyLeading: true,
              title: Text(
                "Category",
                style: getMediumStyle(
                    color: ColorManager.grey, fontSize: FontSize.s18),
              ),
              elevation: 0.2,
            ),
            SizedBox(
              height: 400,
              child: ListView.builder(
                  itemCount: categoryList.length,
                  itemBuilder: (context, index) {
                    return CategoryListTile(categoryList[index], index);
                  }),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Provider.of<FilterProductController>(context, listen: false)
                .addCategoryFilter(filterList);

            Navigator.pop(context);
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
        ),
      ],
    ));
  }

  Widget CategoryListTile(String categoryName, int index) {
    return ListTile(
      title: Text(categoryName,
          style: getMediumStyle(
              color: isSelectedList[index]
                  ? ColorManager.orange
                  : ColorManager.grey,
              fontSize: FontSize.s14)),
      shape: const Border(bottom: BorderSide(width: 0.2)),
      focusColor: ColorManager.orange,
      hoverColor: ColorManager.orange.withOpacity(0.3),
      onTap: () {
        isSelectedList[index] = !isSelectedList[index];
        if (isSelectedList[index]) {
          filterList.add(categoryName);
        } else {
          filterList.remove(categoryName);
        }
        print(filterList.length);
        print(isSelectedList[index]);

        setState(() {});
      },
    );
  }
}
