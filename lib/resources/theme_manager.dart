// ignore_for_file: prefer_const_constructors

import './color_manager.dart';
import './font_manager.dart';
import './style_manager.dart';
import './values_manager.dart';
import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      // main colors of the appte
      primaryColor: ColorManager.primary,
      primaryColorLight: ColorManager.primaryOpacity70,
      disabledColor: ColorManager.grey1,
      // ripple color
      splashColor: ColorManager.primaryOpacity70,
      // card view theme
      cardTheme: CardTheme(
          color: ColorManager.white,
          shadowColor: ColorManager.grey,
          elevation: AppSize.s1),
      // App bar theme
      appBarTheme: AppBarTheme(
        centerTitle: false,
        color: ColorManager.white,
        elevation: AppSize.s0_5,
        shadowColor: ColorManager.primaryOpacity70,
        iconTheme: IconThemeData(color: ColorManager.grey),
        titleTextStyle: getRegularStyle(
            color: ColorManager.primary, fontSize: FontSize.s20),
      ),
      // Button theme
      buttonTheme: ButtonThemeData(
          shape: StadiumBorder(),
          disabledColor: ColorManager.grey1,
          buttonColor: ColorManager.primary,
          splashColor: ColorManager.primaryOpacity70),

      // elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              textStyle: getRegularStyle(color: ColorManager.white),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSize.s12)))),

      // Text theme
      textTheme: TextTheme(
          headline1: getBoldStyle(
              color: ColorManager.darkGrey, fontSize: FontSize.s16),
          subtitle1: getMediumStyle(
              color: ColorManager.lightGrey, fontSize: FontSize.s14),
          subtitle2: getMediumStyle(
              color: ColorManager.primary, fontSize: FontSize.s14),
          caption: getRegularStyle(color: ColorManager.grey1),
          bodyText1: getRegularStyle(color: ColorManager.grey)),
      // input decoration theme (text form field)

      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.all(AppPadding.p8),
        // hint style
        hintStyle: getRegularStyle(
            color: ColorManager.lightGrey, fontSize: FontSize.s16),

        // label style
        labelStyle: getMediumStyle(color: ColorManager.grey),
        // error style
        errorStyle: getRegularStyle(color: ColorManager.error),

        // enabled border
        // enabledBorder: OutlineInputBorder(
        //     borderSide:
        //         BorderSide(color: ColorManager.grey, width: AppSize.s1_5),
        //     borderRadius: BorderRadius.all(Radius.circular(30))),

        // focused border
        // focusedBorder: OutlineInputBorder(
        //     borderSide:
        //         BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
        //     borderRadius: BorderRadius.all(Radius.circular(30))),

        // error border
        // errorBorder: OutlineInputBorder(
        //     borderSide:
        //         BorderSide(color: ColorManager.error, width: AppSize.s1_5),
        //     borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),
        // // focused error border
        // focusedErrorBorder: OutlineInputBorder(
        //     borderSide:
        //         BorderSide(color: ColorManager.primary, width: AppSize.s1_5),
        //     borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),
      ));
}
