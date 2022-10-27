import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/cart_model.dart';
import 'auth_contoller.dart';

class CartController with ChangeNotifier {
  List<Cart> _cart = [];
  double _totalPrice = 0;
  double get totalPrice => _totalPrice;
  List<Cart> get cart => _cart;

  Future<void> addCart(Cart cart) async {
    try {
      final isUserHasCart = await http.get(Uri.parse(
          "https://gentle-crag-94785.herokuapp.com/api/v1/carts/$globalUserId"));

      if (isUserHasCart.statusCode == 404) {
        const url = "https://gentle-crag-94785.herokuapp.com/api/v1/carts";
        final _cart = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            "Authorization": "Bearer $globalToken"
          },
          body: jsonEncode(
            {
              "customerId": cart.customerId,
              "products": [
                {
                  "productName": cart.productName,
                  "productId": cart.productId,
                  "images": cart.images,
                  "quantity": cart.quantity,
                  "size": cart.size,
                  "price": cart.price,
                  "subTotalPrice": 2,
                }
              ],
            },
          ),
        );
      } else {
        final url =
            "https://gentle-crag-94785.herokuapp.com/api/v1/carts/$globalUserId";
        final _cart = await http.patch(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            "Authorization": "Bearer $globalToken"
          },
          body: jsonEncode(
            {
              "images": cart.images,
              "quantity": cart.quantity,
              "productName": cart.productName,
              "productId": cart.productId,
              "size": cart.size,
              "price": cart.price,
            },
          ),
        );
      }
    } catch (er) {
      print(er);
    }
  }

  Future<http.Response?> getCart(String userId) async {
    final url = "https://gentle-crag-94785.herokuapp.com/api/v1/carts/$userId";

    try {
      final cart = await http.get(Uri.parse(url));
      final extractedData = jsonDecode(cart.body)["data"]["products"] as List;
      final customerId = jsonDecode(cart.body)["data"]["customerId"];

      _totalPrice = jsonDecode(cart.body)["priceCalculation"][0]
              ["subTotalPrice"]
          .toDouble();
      print(_cart.length);

      _cart = extractedData.map((el) => Cart.fromJson(el, customerId)).toList();
      notifyListeners();
      return cart;
    } catch (er) {
      print(er);
    }
  }

  Future<void> updateQuantity(String objectId, int quantity) async {
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/carts/$globalUserId/product/$objectId";

    await http.patch(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        "Authorization": "Bearer $globalToken"
      },
      body: jsonEncode(
        {"quantity": quantity},
      ),
    );
  }

  Future<void> removeProductFromCart(Cart cart) async {
    // final index =
    //     _cart.indexWhere((element) => element.objectId == cart.objectId);
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/carts/$globalUserId/product/${cart.objectId}";
    await http.delete(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        "Authorization": "Bearer $globalToken"
      },
    );
  }

  Future resetItem() async {
    _cart.clear();
    _totalPrice = 0;
    notifyListeners();
  }
}
