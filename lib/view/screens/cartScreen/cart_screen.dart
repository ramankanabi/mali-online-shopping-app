import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/controller/auth_contoller.dart';
import 'package:online_shopping/controller/cart_controller.dart';
import 'package:online_shopping/resources/values_manager.dart';
import 'package:online_shopping/widgets/loader-shimmer-widgets/loader.dart';
import 'package:provider/provider.dart';
import '../../../model/cart_model.dart';
import '../../../resources/color_manager.dart';
import '../../../resources/font_manager.dart';
import '../../../resources/routes_manager.dart';
import '../../../resources/style_manager.dart';
import '../../../widgets/cart_item_widget.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen>
    with AutomaticKeepAliveClientMixin {
  late Future _future;
  late double totalPrice;
  @override
  void initState() {
    _future = Provider.of<CartController>(context, listen: false)
        .getCart(globalUserId);
    super.initState();
  }

  Future _onRefresh() async {
    try {
      await Provider.of<CartController>(context, listen: false).resetItem();
      await Provider.of<CartController>(context, listen: false)
          .getCart(globalUserId);
      // _cart = Provider.of<CartController>(context, listen: false).cart;
      // setState(() {});
    } catch (er) {
      print(er);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            final _cart =
                Provider.of<CartController>(context, listen: true).cart;

            final totalPrice =
                Provider.of<CartController>(context, listen: true).totalPrice;
            return Scaffold(
              appBar: AppBar(
                centerTitle: false,
                title: Text(
                  "My Cart",
                  style: getMediumStyle(
                      color: ColorManager.primary, fontSize: FontSize.s20),
                ),
              ),
              body: snapshot.connectionState == ConnectionState.waiting
                  ? const Loader()
                  : snapshot.hasData
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: _cart.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CartItem(
                                cart: _cart[index],
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.cart,
                                color: ColorManager.lightGrey,
                                size: 80,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Cart is empty :(",
                                style: getMediumStyle(
                                    color: ColorManager.lightGrey,
                                    fontSize: FontSize.s20),
                              ),
                            ],
                          ),
                        ),
              persistentFooterButtons: [
                Footer(_cart, totalPrice),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget Footer(List<Cart> cart, double totalPrice) {
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Price :",
                style: getBoldStyle(
                  color: ColorManager.darkGrey,
                  fontSize: FontSize.s17,
                ),
              ),
              Text("$totalPrice IQD",
                  style: getBoldStyle(
                      color: ColorManager.orange, fontSize: FontSize.s20))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: AppSize.s50,
            width: double.infinity,
            child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(ColorManager.orange),
                ),
                onPressed: () {
                  placeOrder(context, cart);
                },
                child: Text(
                  "Place Order",
                  style: getMediumStyle(
                    color: ColorManager.white,
                  ),
                )),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

void placeOrder(BuildContext context, List cart) async {
  final connectionStatus = await Connectivity().checkConnectivity();

  if (connectionStatus == ConnectivityResult.none) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Check internet connection"),
      ),
    );
  } else if (cart.isNotEmpty) {
    Navigator.pushNamed(context, Routes.formSubmitOrder, arguments: [cart]);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Cart is empty :("),
      ),
    );
  }
}
