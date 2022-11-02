import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:online_shopping/controller/auth_contoller.dart';
import 'package:online_shopping/resources/color_manager.dart';
import 'package:online_shopping/view/screens/favouriteScreen/favourite_sceen.dart';
import 'package:online_shopping/view/screens/homeScreen/home_screen.dart';
import 'package:online_shopping/view/screens/profileScreen/profile_screen.dart';
import 'package:provider/provider.dart';

import '../cacheManager/image_cache_manager.dart' as cache;
import '../resources/routes_manager.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int pageIndex = 0;
  bool isInit = true;
  PageController pageController = PageController();
  final storage = const FlutterSecureStorage();

  onPageChanged(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  onTap(int index) {
    pageController.jumpToPage(index);
  }

  @override
  void didChangeDependencies() async {
    if (isInit) {
      await Provider.of<AuthController>(context)
          .setTokenAndUserIdAndLoggedStatus();
    }
    setState(() {
      isInit = false;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Stack(children: [
        PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          onPageChanged: onPageChanged,
          children: [
            const HomeScreen(),
            FavouriteScreen(),
            // CartScreen(),
            ProfileScreen(),
          ],
        ),
        Positioned(
          bottom: 10,
          left: 30,
          right: 30,
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: ColorManager.primary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    icon: const Icon(CupertinoIcons.home),
                    color: pageIndex == 0
                        ? ColorManager.orange
                        : ColorManager.lightGrey,
                    onPressed: () {
                      onTap(0);
                    }),
                IconButton(
                    icon: const Icon(CupertinoIcons.heart),
                    color: pageIndex == 1
                        ? ColorManager.orange
                        : ColorManager.lightGrey,
                    onPressed: () {
                      onTap(1);
                    }),
                IconButton(
                    icon: const Icon(CupertinoIcons.person),
                    color: pageIndex == 2
                        ? ColorManager.orange
                        : ColorManager.lightGrey,
                    onPressed: () {
                      onTap(2);
                    }),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 70,
          right: 20,
          child: SizedBox(
            width: 60,
            height: 60,
            child: FloatingActionButton(
              backgroundColor: ColorManager.orange,
              child: Icon(
                CupertinoIcons.cart,
                color: ColorManager.white,
                size: 30,
              ),
              onPressed: () async {
                await DefaultCacheManager().removeFile("productImages");
                // Navigator.pushNamed(context, Routes.cartScreen);
              },
            ),
          ),
        ),
      ]),
      // floatingActionButton: Container(
      //   width: 60,
      //   height: 60,
      //   child: FloatingActionButton(
      //     backgroundColor: ColorManager.orange,
      //     child: Icon(
      //       CupertinoIcons.cart,
      //       color: ColorManager.white,
      //       size: 30,
      //     ),
      //     onPressed: () {},
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.,

      // bottomNavigationBar: CupertinoTabBar(
      //     currentIndex: pageIndex,
      //     backgroundColor: ColorManager.primary,
      //     onTap: onTap,
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: Icon(
      //           CupertinoIcons.home,
      //           color: ColorManager.lightGrey,
      //         ),
      //         activeIcon: Icon(CupertinoIcons.home, color: ColorManager.orange),
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(
      //           CupertinoIcons.heart,
      //           color: ColorManager.lightGrey,
      //         ),
      //         activeIcon:
      //             Icon(CupertinoIcons.heart_fill, color: ColorManager.orange),
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(
      //           CupertinoIcons.person,
      //           color: ColorManager.lightGrey,
      //         ),
      //         activeIcon:
      //             Icon(CupertinoIcons.person_fill, color: ColorManager.orange),
      //       ),
      //     ]),
    );
  }
}
