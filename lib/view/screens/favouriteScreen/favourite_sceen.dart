import "package:flutter/material.dart";
import 'package:lottie/lottie.dart';
import 'package:online_shopping/controller/favouite_contoller.dart';
import 'package:online_shopping/resources/color_manager.dart';
import 'package:online_shopping/resources/style_manager.dart';
import 'package:online_shopping/widgets/loader-shimmer-widgets/favourite_item_loader.dart';
import 'package:provider/provider.dart';

import '../../../controller/auth_contoller.dart';
import '../../../model/favourite_model.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/routes_manager.dart';
import '../../../widgets/favourite_item_wiget.dart';

class FavouriteScreen extends StatefulWidget {
  FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen>
    with AutomaticKeepAliveClientMixin {
  bool isInit = true;

  // List<Favourite> userFavourites = [];
  @override
  // void didChangeDependencies() async {
  //   if (isInit) {
  //     isLoading = true;
  //     await Provider.of<FavouriteContoller>(context)
  //         .getUserAllFavourites(globalUserId);
  //   }
  //   if (mounted) {
  //     setState(() {
  //       userFavourites =
  //           Provider.of<FavouriteContoller>(context, listen: false).favItems;
  //       isLoading = false;
  //       isInit = false;
  //     });
  //   }
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    Provider.of<FavouriteContoller>(context, listen: false)
        .getUserAllFavourites(globalUserId);
  }

  Future onRefresh() async {
    await Provider.of<FavouriteContoller>(context, listen: false).resetItems();
    await Provider.of<FavouriteContoller>(context, listen: false)
        .getUserAllFavourites(globalUserId);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<FavouriteContoller>(context, listen: true).isLoading;
    final userFavourites =
        Provider.of<FavouriteContoller>(context, listen: true).favItems;
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Text(
            "My Favourite",
            style: getMediumStyle(
                color: ColorManager.primary, fontSize: FontSize.s20),
          ),
        ),
        body: isLoading
            ? const FavouriteItemLoader()
            : (userFavourites.isEmpty
                ? EmptyFavList()
                : FavouriteItemsView(userFavourites)));
  }

  Widget EmptyFavList() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Favourites list is empty :(",
          style: getMediumStyle(
            color: ColorManager.lightGrey,
            fontSize: FontSize.s20,
          ),
        ),
        TextButton(
            onPressed: () {
              onRefresh();
            },
            child: Text(
              "Refresh",
              style: getMediumStyle(
                color: ColorManager.orange,
                fontSize: FontSize.s18,
              ),
            ))
      ],
    ));
  }

  Widget FavouriteItemsView(List<Favourite> userFavourites) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: userFavourites.length,
        itemBuilder: (ctx, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
            ),
            child: FavouriteItemWidget(
              favourite: userFavourites[index],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive {
    return true;
  }
}
