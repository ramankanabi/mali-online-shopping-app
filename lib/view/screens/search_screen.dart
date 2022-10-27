import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/controller/search_controller.dart';
import 'package:online_shopping/model/product_model.dart';
import 'package:online_shopping/resources/color_manager.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../resources/font_manager.dart';
import '../../resources/routes_manager.dart';
import '../../resources/style_manager.dart';
import '../../resources/values_manager.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future _future;
  final _searchController = TextEditingController();
  List<Product> searchList = [];
  bool isLoading = false;
  final FocusNode _searchNode = FocusNode();
  onChange(String value) async {
    setState(() {
      isLoading = true;
    });
    Provider.of<SearchController>(context, listen: false).resetSearchList();
    await Provider.of<SearchController>(context, listen: false)
        .getSearchResult(value.trim());

    searchList =
        Provider.of<SearchController>(context, listen: false).searchList;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: AppSize.s12,
            ),
            Text(
              "Search for a Product",
              style: getBoldStyle(
                  color: ColorManager.primary, fontSize: FontSize.s25),
            ),
            const SizedBox(
              height: 30,
            ),
            TextField(
              style: getMediumStyle(
                color: ColorManager.grey,
              ),
              controller: _searchController,
              onChanged: (val) => onChange(val.toString()),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.r8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                hintText: "eg: polo shirt",
                prefixIcon:
                    Icon(CupertinoIcons.search, color: ColorManager.grey1),
                prefixIconColor: ColorManager.grey1,
              ),
              autofocus: true,
              focusNode: _searchNode,
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: isLoading ? 5 : searchList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        isLoading
                            ? SearchItemLoader()
                            : SearchItemWidget(
                                searchList[index],
                              ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget SearchItemWidget(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.productViewScreen,
          arguments: [product.prodId, false],
        );
      },
      child: Container(
          decoration: BoxDecoration(color: ColorManager.white, boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ]),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                          product.images[0],
                        ),
                        fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: getMediumStyle(
                          color: ColorManager.grey, fontSize: FontSize.s20),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      product.discreption_EN.toString(),
                      style: getRegularStyle(
                          color: ColorManager.lightGrey,
                          fontSize: FontSize.s14),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${product.price.toString()} IQD",
                      style: getMediumStyle(
                          color: ColorManager.orange, fontSize: FontSize.s18),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }

  Widget SearchItemLoader() {
    return Row(
      children: [
        Shimmer.fromColors(
          baseColor: ColorManager.shimmerBaseColor,
          highlightColor: ColorManager.shimmerHighlightColor,
          child: Container(
            height: 80,
            width: 80,
            color: ColorManager.grey,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Shimmer.fromColors(
              baseColor: ColorManager.shimmerBaseColor,
              highlightColor: ColorManager.shimmerHighlightColor,
              child: Container(
                height: 10,
                width: 50,
                decoration: BoxDecoration(
                    color: ColorManager.grey,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Shimmer.fromColors(
              baseColor: ColorManager.shimmerBaseColor,
              highlightColor: ColorManager.shimmerHighlightColor,
              child: Container(
                height: 10,
                width: 80,
                decoration: BoxDecoration(
                    color: ColorManager.grey,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Shimmer.fromColors(
              baseColor: ColorManager.shimmerBaseColor,
              highlightColor: ColorManager.shimmerHighlightColor,
              child: Container(
                height: 10,
                width: 40,
                decoration: BoxDecoration(
                    color: ColorManager.grey,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        )
      ],
    );
  }
}
