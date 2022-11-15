import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/controller/search_controller.dart';
import 'package:online_shopping/model/product_model.dart';
import 'package:online_shopping/resources/color_manager.dart';
import 'package:provider/provider.dart';

import '../../../resources/font_manager.dart';
import '../../../resources/style_manager.dart';
import '../../../resources/values_manager.dart';
import '../../../widgets/loader-shimmer-widgets/search_item_loader.dart';
import '../../../widgets/search_item_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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

    if (mounted) {
      searchList =
          Provider.of<SearchController>(context, listen: false).searchList;
    }
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
              cursorColor: ColorManager.cursorColor,
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
                            ? const SearchItemLoader()
                            : SearchItemWidget(
                                product: searchList[index],
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
}
