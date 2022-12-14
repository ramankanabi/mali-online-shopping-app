import 'package:flutter/material.dart';
import 'package:online_shopping/resources/strings_manager.dart';
import 'package:online_shopping/view/home.dart';
import 'package:online_shopping/view/screens/authScreen/auth_screen.dart';
import 'package:online_shopping/view/screens/cartScreen/cart_screen.dart';
import 'package:online_shopping/view/screens/categoryScreen/category_screen.dart';
import 'package:online_shopping/view/screens/favouriteScreen/favourite_sceen.dart';
import 'package:online_shopping/view/screens/homeScreen/sales_discount_screen.dart';
import 'package:online_shopping/view/screens/orderScreen/form_submit_order.dart';
import 'package:online_shopping/view/screens/homeScreen/home_screen.dart';
import 'package:online_shopping/view/screens/orderScreen/order_screen.dart';
import 'package:online_shopping/view/screens/productViewScreen/product_view_screen.dart';

import '../view/screens/homeScreen/search_screen.dart';

class Routes {
  static const String home = "/home";
  static const String categorySceen = "/categoryScreen";
  static const String productViewScreen = "/productViewScreen";
  static const String authScreen = "/authScreen";
  static const String cartScreen = "/cartScreen";
  static const String formSubmitOrder = "/formSubmitOrder";
  static const String orderScreen = "/orderScreen";
  static const String favouriteScreen = "/favouriteScreen";
  static const String homeScreen = "/homeScreen";
  static const String searchScreen = "/searchScreen";
  static const String salesDiscountScreenScreen = "/salesDiscountScreenScreen";
  static const String mainRoute = "/main";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const Home());
      case Routes.categorySceen:
        List<dynamic> args = routeSettings.arguments as List;
        return MaterialPageRoute(
          builder: (_) => CategoryScreen(
            categoryName: args[0],
          ),
        );
      case Routes.productViewScreen:
        List<dynamic> args = routeSettings.arguments as List;
        return MaterialPageRoute(
            builder: (_) => ProductViewScreen(
                  productId: args[0],
                ));
      case Routes.authScreen:
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case Routes.cartScreen:
        return MaterialPageRoute(builder: (_) => CartScreen());
      case Routes.formSubmitOrder:
        List<dynamic> args = routeSettings.arguments as List;
        return MaterialPageRoute(
            builder: (_) => FormSubmitOrder(
                  cart: args[0],
                ));
      case Routes.orderScreen:
        return MaterialPageRoute(builder: (_) => OrderScreen());

      case Routes.favouriteScreen:
        return MaterialPageRoute(builder: (_) => FavouriteScreen());
      case Routes.homeScreen:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case Routes.searchScreen:
        return MaterialPageRoute(builder: (_) => SearchScreen());
      case Routes.salesDiscountScreenScreen:
        return MaterialPageRoute(builder: (_) => SalesDiscountScreen());

      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: Text(AppStrings.noRouteFound),
              ),
              body: Center(child: Text(AppStrings.noRouteFound)),
            ));
  }
}
