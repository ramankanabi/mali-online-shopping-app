// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:online_shopping/controller/auth_contoller.dart';
import 'package:online_shopping/controller/product_controller.dart';
import 'package:online_shopping/model/user_model.dart';
import 'package:online_shopping/resources/font_manager.dart';
import 'package:online_shopping/resources/style_manager.dart';
import 'package:online_shopping/resources/values_manager.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:provider/provider.dart';
import '../../../controller/favouite_contoller.dart';
import '../../../resources/color_manager.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  double cardHeight = 300;
  double cardWidth = 300;
  PageController pageContoller = PageController();
  TextEditingController phoneNumberController = TextEditingController();
  int counter = 60;
  Timer? _timer;
  bool isLoading = false;
  auth.FirebaseAuth? firebaseAuth;

  final _phoneNumberKey = GlobalKey<FormState>();
  final _informationKey = GlobalKey<FormState>();
  TextEditingController smsCodeContoller = TextEditingController();
  User user = User(name: "", phoneNumber: "", city: "", birthYear: 0);
  startCounter() {
    setState(() {
      counter = 60;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        counter--;
      });
      if (counter == 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();

    super.dispose();
  }

  _formSave() async {
    if (pageContoller.page == 0) {
      final isValid = _phoneNumberKey.currentState?.validate();
      if (isValid == false || isValid == null) {
        return;
      }
      _phoneNumberKey.currentState?.save();
      setState(() {
        isLoading = true;
      });
      final isUserExist =
          await Provider.of<AuthController>(context, listen: false)
              .checkUser(user.phoneNumber);

      if (isUserExist) {
        await Provider.of<AuthController>(context, listen: false)
            .verifyPhone(user);
        pageContoller.jumpToPage(2);
        setState(() {
          isLoading = false;
        });
        startCounter();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("code is sent")));
      } else {
        setState(() {
          cardHeight = AppSize.s500;
          isLoading = false;
        });
        pageContoller.jumpToPage(1);
      }
    }
    if (pageContoller.page == 1) {
      final isValid = _informationKey.currentState?.validate();
      if (isValid == false || isValid == null) {
        return;
      }
      _informationKey.currentState?.save();
      await Provider.of<AuthController>(context, listen: false)
          .verifyPhone(user)
          .then((_) {
        setState(() {
          cardHeight = AppSize.s300;
        });
        startCounter();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("code is sent")));
      }).catchError((er) {});

      pageContoller.jumpToPage(2);
    }
  }

  _login() async {
    await Provider.of<AuthController>(context, listen: false)
        .checkCode(smsCodeContoller.text, user)
        .then((_) {
      Provider.of<ProductContoller>(context, listen: false).resetItem();
      Provider.of<ProductContoller>(context, listen: false).fetchProductData();
      Provider.of<FavouriteContoller>(context, listen: false).resetItems();
      Provider.of<FavouriteContoller>(context, listen: false)
          .getUserAllFavourites(globalUserId);
      Navigator.pop(context);
    }).catchError((er) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Oh, something went error"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  color: ColorManager.primary,
                ),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                ),
              ],
            ),
          ),
          Center(
            child: Card(
              shape: Border.all(color: ColorManager.grey, width: 0.1),
              child: AnimatedContainer(
                  height: cardHeight,
                  width: cardWidth,
                  color: ColorManager.white,
                  duration: const Duration(milliseconds: 200),
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    controller: pageContoller,
                    children: [
                      PhoneNumberField(),
                      InformationFields(),
                      VerificationField(),
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }

  Widget PhoneNumberField() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: ColorManager.orange,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Explore The World Of Mali Shopping ",
                  textAlign: TextAlign.center,
                  style: getBoldStyle(
                    color: ColorManager.grey,
                    fontSize: FontSize.s20,
                  ),
                ),
                Form(
                  key: _phoneNumberKey,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phone number",
                            style: getMediumStyle(color: ColorManager.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            cursorColor: ColorManager.cursorColor,
                            style: getRegularStyle(
                                color: ColorManager.primaryOpacity70,
                                fontSize: FontSize.s16),
                            decoration: InputDecoration(
                              focusColor: ColorManager.cursorColor,
                              contentPadding:
                                  const EdgeInsets.all(AppPadding.p8),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorManager.primary),
                              ),
                            ),
                            onSaved: (val) {
                              user = User(
                                name: user.name,
                                phoneNumber: val.toString(),
                                city: user.city,
                                birthYear: user.birthYear,
                              );
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Please enter a phone number";
                              }
                              if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                                return "sorry, only numbers are allowed";
                              }
                              if (val.length != 11) {
                                return "a phone number should contains 11 digit.";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      _formSave();
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        ColorManager.orange,
                      ),
                    ),
                    child: SizedBox(
                      width: AppSize.s100,
                      child: Text(
                        "Submit",
                        textAlign: TextAlign.center,
                        style: getMediumStyle(
                          color: ColorManager.white,
                        ),
                      ),
                    ))
              ],
            ),
    );
  }

  Widget InformationFields() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: ColorManager.orange,
              ),
            )
          : SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                height: AppSize.s500,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Explore The World Of Mali Shopping ",
                      textAlign: TextAlign.center,
                      style: getBoldStyle(
                        color: ColorManager.grey,
                        fontSize: FontSize.s20,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Full name",
                          style: getMediumStyle(
                            color: ColorManager.grey,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Form(
                          key: _informationKey,
                          child: Column(
                            children: [
                              TextFormField(
                                cursorColor: ColorManager.cursorColor,
                                style: getRegularStyle(
                                    color: ColorManager.primaryOpacity70,
                                    fontSize: FontSize.s16),
                                decoration: InputDecoration(
                                  focusColor: ColorManager.cursorColor,
                                  contentPadding:
                                      const EdgeInsets.all(AppPadding.p8),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: ColorManager.primary),
                                  ),
                                ),
                                onSaved: (val) {
                                  user = User(
                                    name: val.toString(),
                                    phoneNumber: user.phoneNumber,
                                    city: user.city,
                                    birthYear: user.birthYear,
                                  );
                                },
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "please enter a name";
                                  }
                                  if (RegExp(
                                          r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                      .hasMatch(val)) {
                                    return "please enter only letters";
                                  }
                                  if (val.length > 20) {
                                    return "sorry,a full name should less than 20 word";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "City",
                                    style: getMediumStyle(
                                        color: ColorManager.grey),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    cursorColor: ColorManager.cursorColor,
                                    style: getRegularStyle(
                                        color: ColorManager.primaryOpacity70,
                                        fontSize: FontSize.s16),
                                    decoration: InputDecoration(
                                      focusColor: ColorManager.cursorColor,
                                      contentPadding:
                                          const EdgeInsets.all(AppPadding.p8),
                                      border: const OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorManager.primary),
                                      ),
                                    ),
                                    onSaved: (val) {
                                      user = User(
                                        name: user.name,
                                        phoneNumber: user.phoneNumber,
                                        city: val.toString(),
                                        birthYear: user.birthYear,
                                      );
                                    },
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "please enter a city";
                                      }
                                      if (RegExp(
                                              r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]')
                                          .hasMatch(val)) {
                                        return "please enter only characters";
                                      }
                                      if (val.length > 20) {
                                        return "sorry,a full name should less than 20 characters";
                                      }

                                      return null;
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Birth year",
                                    style: getMediumStyle(
                                        color: ColorManager.grey),
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    cursorColor: ColorManager.cursorColor,
                                    style: getRegularStyle(
                                        color: ColorManager.primaryOpacity70,
                                        fontSize: FontSize.s16),
                                    decoration: InputDecoration(
                                      focusColor: ColorManager.cursorColor,
                                      contentPadding:
                                          const EdgeInsets.all(AppPadding.p8),
                                      border: const OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorManager.primary),
                                      ),
                                    ),
                                    onSaved: (val) {
                                      user = User(
                                        name: user.name,
                                        phoneNumber: user.phoneNumber,
                                        city: user.city,
                                        birthYear: int.parse(val.toString()),
                                      );
                                    },
                                    validator: (val) {
                                      if (val!.isEmpty) {
                                        return "please enter a birth year";
                                      }
                                      if (!RegExp(r'^[0-9]+$').hasMatch(val)) {
                                        return "please enter only number";
                                      } else if (int.parse(val) < 1900 ||
                                          int.parse(val) >
                                              DateTime.now().year) {
                                        return "please enter a right year";
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _formSave();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            ColorManager.orange,
                          ),
                        ),
                        child: SizedBox(
                          width: AppSize.s100,
                          child: Text(
                            "Submit",
                            textAlign: TextAlign.center,
                            style: getMediumStyle(
                              color: ColorManager.white,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ),
    );
  }

  Widget VerificationField() {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: ColorManager.orange,
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      "Enter Verification Code",
                      style: getBoldStyle(
                        color: ColorManager.grey,
                        fontSize: FontSize.s20,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Wrong number ? ",
                          textAlign: TextAlign.center,
                          style: getRegularStyle(color: ColorManager.grey),
                        ),
                        Text(
                          "Change number",
                          textAlign: TextAlign.center,
                          style: getRegularStyle(color: ColorManager.orange),
                        ),
                      ],
                    ),
                  ],
                ),
                Form(
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Verification code",
                            style: getMediumStyle(
                              color: ColorManager.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            cursorColor: ColorManager.cursorColor,
                            controller: smsCodeContoller,
                            keyboardType: TextInputType.number,
                            style: getRegularStyle(
                                color: ColorManager.primaryOpacity70,
                                fontSize: FontSize.s16),
                            decoration: InputDecoration(
                              focusColor: ColorManager.cursorColor,
                              contentPadding:
                                  const EdgeInsets.all(AppPadding.p8),
                              border: const OutlineInputBorder(),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorManager.primary),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text("00:$counter"),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          ColorManager.orange,
                        ),
                      ),
                      child: SizedBox(
                        width: AppSize.s100,
                        child: Text(
                          "Login",
                          textAlign: TextAlign.center,
                          style: getMediumStyle(
                            color: ColorManager.white,
                          ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: counter == 0
                          ? () async {
                              await Provider.of<AuthController>(context,
                                      listen: false)
                                  .verifyPhone(user)
                                  .then((_) {
                                startCounter();
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("code is sent")));
                              });
                            }
                          : null,
                      child: Text(
                        "resend",
                        style: getRegularStyle(
                          color: counter == 0
                              ? ColorManager.orange
                              : ColorManager.grey,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
    );
  }
}
