import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:online_shopping/controller/auth_contoller.dart';
import 'package:online_shopping/controller/user_controller.dart';
import 'package:online_shopping/model/user_model.dart';
import 'package:online_shopping/resources/color_manager.dart';
import 'package:online_shopping/resources/style_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import "package:material_design_icons_flutter/material_design_icons_flutter.dart";
import 'package:provider/provider.dart';
import '../../resources/font_manager.dart';
import '../../resources/routes_manager.dart';
import '../../resources/values_manager.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  bool isInit = true;
  late bool isLogged;
  late User user;
  bool isLoading = false;
  @override
  void didChangeDependencies() async {
    if (isInit) {
      isLogged = Provider.of<AuthController>(context).isLogged;
      if (isLogged) {
        isLoading = true;
        final userId = Provider.of<AuthController>(context).getUserId;
        await Provider.of<UserController>(context)
            .getUserData(userId)
            .then((_) {
          setState(() {
            isLoading = false;
            isInit = false;
          });
        });
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLogged
            ? (isLoading
                ? Center(
                    child: Lottie.asset("assets/lottieAnimations/loader.json",
                        width: 300, height: 300),
                  )
                : const ProfileView())
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: AppSize.s200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            CupertinoIcons.person,
                            size: 60,
                            color: ColorManager.grey.withOpacity(0.5),
                          ),
                          Text(
                            "My Account",
                            style: getMediumStyle(
                                color: ColorManager.primary,
                                fontSize: FontSize.s18),
                          ),
                          Text(
                            "Please log in to see your account",
                            style: getRegularStyle(
                                color: ColorManager.darkGrey,
                                fontSize: FontSize.s14),
                          ),
                          SizedBox(
                            height: 40,
                            width: AppSize.s300,
                            child: ElevatedButton(
                              child: Text(
                                "Login",
                                style: getMediumStyle(
                                  color: ColorManager.white,
                                ),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, Routes.authScreen);
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserController>(context).user;
    return Scaffold(
      body: SingleChildScrollView(
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
            OverViewCard(context),
            AccountCard(),
            MoreCard(context),
            LogOutCard(context),
          ]),
        ),
      ),
    );
  }

  Widget OverViewCard(BuildContext context) {
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

  Widget AccountCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Account",
                style: getMediumStyle(color: ColorManager.orange),
              ),
            ),
            ListTile(
              title: Text("Personal Details",
                  style: getMediumStyle(
                      color: ColorManager.darkGrey, fontSize: FontSize.s14)),
              leading: const Icon(CupertinoIcons.person),
              trailing: IconButton(
                  onPressed: () {}, icon: const Icon(CupertinoIcons.forward)),
              shape: const Border(
                  bottom: BorderSide(width: 0.2), top: BorderSide(width: 0.2)),
            ),
          ],
        ),
      ),
    );
  }

  Widget MoreCard(BuildContext context) {
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
                  onPressed: () {}, icon: const Icon(CupertinoIcons.forward)),
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

  Widget LogOutCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          onTap: () {
            Provider.of<AuthController>(context, listen: false).logOut();
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
