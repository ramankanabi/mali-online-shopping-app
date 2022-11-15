import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/controller/favouite_contoller.dart';
import 'package:online_shopping/controller/product_controller.dart';
import 'package:online_shopping/widgets/loader-shimmer-widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/auth_contoller.dart';
import '../../../controller/user_controller.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/routes_manager.dart';
import '../../../resources/style_manager.dart';
import '../../../resources/values_manager.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    Provider.of<UserController>(context, listen: false)
        .getUserData(globalUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserController>(context).user;
    final isLoading = Provider.of<UserController>(context).isLoading;
    return Scaffold(
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(AppPadding.p8),
                child: Column(children: [
                  const SizedBox(
                    height: AppSize.s40,
                  ),
                  Container(
                    alignment: Alignment.bottomLeft,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Hello ",
                            style: getMediumStyle(
                              color: ColorManager.orange,
                              fontSize: FontSize.s50,
                            ),
                          ),
                          TextSpan(
                            text: user.name,
                            style: getMediumStyle(
                              color: ColorManager.primary,
                              fontSize: FontSize.s40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSize.s20,
                  ),
                  overViewCard(context),
                  moreCard(context),
                  logOutCard(context),
                ]),
              ),
            ),
    );
  }

  Widget overViewCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Overview",
                style: getMediumStyle(color: ColorManager.orange),
              ),
            ),
            ListTile(
              title: Text("My Orders",
                  style: getMediumStyle(
                      color: ColorManager.darkGrey, fontSize: FontSize.s14)),
              leading: const Icon(CupertinoIcons.cube_box),
              trailing: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.orderScreen);
                  },
                  icon: const Icon(CupertinoIcons.forward)),
              shape: const Border(
                  bottom: BorderSide(width: 0.2), top: BorderSide(width: 0.2)),
            ),
            ListTile(
              title: Text(
                "My Favourites",
                style: getMediumStyle(
                    color: ColorManager.darkGrey, fontSize: FontSize.s14),
              ),
              leading: const Icon(CupertinoIcons.heart),
              trailing: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.favouriteScreen);
                  },
                  icon: const Icon(CupertinoIcons.forward)),
              shape: const Border(
                bottom: BorderSide(width: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget moreCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "More",
                style: getMediumStyle(color: ColorManager.orange),
              ),
            ),
            ListTile(
              title: Text("Chat Us",
                  style: getMediumStyle(
                      color: ColorManager.darkGrey, fontSize: FontSize.s14)),
              leading: const Icon(CupertinoIcons.chat_bubble),
              trailing: IconButton(
                  onPressed: () async {
                    try {
                      const url = "https://wa.me/message/QU2N64TGUCN2I1";
                      await launchUrl(Uri.parse(url),
                          mode: LaunchMode.externalNonBrowserApplication);
                    } catch (e) {
                      print(e);
                    }
                  },
                  icon: const Icon(CupertinoIcons.forward)),
              shape: const Border(
                  bottom: BorderSide(width: 0.2), top: BorderSide(width: 0.2)),
            ),
            ListTile(
              title: Text("About Us",
                  style: getMediumStyle(
                      color: ColorManager.darkGrey, fontSize: FontSize.s14)),
              leading: const Icon(CupertinoIcons.info),
              trailing: IconButton(
                  onPressed: () {}, icon: const Icon(CupertinoIcons.forward)),
              shape: const Border(
                bottom: BorderSide(width: 0.2),
              ),
            ),
            ListTile(
              title: Text(
                "Language",
                style: getMediumStyle(
                    color: ColorManager.darkGrey, fontSize: FontSize.s14),
              ),
              leading: const Icon(Icons.translate_outlined),
              trailing: IconButton(
                  onPressed: () {}, icon: const Icon(CupertinoIcons.forward)),
              shape: const Border(
                bottom: BorderSide(width: 0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget logOutCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          onTap: () {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Log Out'),
                content: const Text('Are you sure you want to log out'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Cancel',
                      style: getRegularStyle(
                          color: ColorManager.lightGrey,
                          fontSize: FontSize.s16),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Provider.of<AuthController>(context, listen: false)
                          .logOut();
                      Provider.of<ProductContoller>(context, listen: false)
                          .resetItem();
                      Provider.of<ProductContoller>(context, listen: false)
                          .fetchProductData();
                      Provider.of<FavouriteContoller>(context, listen: false)
                          .resetItems();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Log Out',
                      style: getRegularStyle(
                          color: ColorManager.orange, fontSize: FontSize.s16),
                    ),
                  ),
                ],
              ),
            );
          },
          title: Text(
            "Log Out",
            style: getMediumStyle(
                color: ColorManager.darkGrey, fontSize: FontSize.s14),
          ),
          leading: const Icon(Icons.exit_to_app_outlined),
          shape: const Border(
            bottom: BorderSide(width: 0.2),
          ),
        ),
      ),
    );
  }
}
