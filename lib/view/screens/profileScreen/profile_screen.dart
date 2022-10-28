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
import 'package:online_shopping/view/screens/profileScreen/profile_view.dart';
import 'package:online_shopping/widgets/loader-shimmer-widgets/loader.dart';
import 'package:provider/provider.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/routes_manager.dart';
import '../../../resources/values_manager.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final isLogged = Provider.of<AuthController>(context).isLogged;
    final authLoding = Provider.of<AuthController>(context).isLoading;
    return SafeArea(
      child: Scaffold(
        body: (authLoding
            ? const Loader()
            : isLogged
                ? const ProfileView()
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
                                  onPressed: () async {
                                    await Navigator.pushNamed(
                                        context, Routes.authScreen);
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
