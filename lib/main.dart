import 'package:flutter/material.dart';
import 'package:online_shopping/controller/auth_contoller.dart';
import 'package:online_shopping/controller/cart_controller.dart';
import 'package:online_shopping/controller/favouite_contoller.dart';
import 'package:online_shopping/controller/order_controller.dart';
import 'package:online_shopping/controller/product_controller.dart';
import 'package:online_shopping/resources/routes_manager.dart';
import 'package:online_shopping/view/home.dart';
import 'package:online_shopping/view/screens/orderScreen/form_submit_order.dart';
import 'package:online_shopping/view/screens/orderScreen/order_screen.dart';
import 'package:online_shopping/view/screens/searchScreen/search_screen.dart';
import 'package:online_shopping/widgets/loader-shimmer-widgets/product_view_page_loader.dart';
import 'package:provider/provider.dart';
import './resources/theme_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controller/search_controller.dart';
import 'controller/user_controller.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => ProductContoller(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthController(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserController(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => FavouriteContoller(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CartController(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => OrderController(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SearchController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: getApplicationTheme(),
        home: Home(),
        onGenerateRoute: RouteGenerator.getRoute,
      ),
    );
  }
}
