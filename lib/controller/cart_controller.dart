import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../apiService/dio_interceptors_wrapper.dart';
import '../apiService/dio_options.dart';
import '../model/cart_model.dart';
import 'auth_contoller.dart';

class CartController with ChangeNotifier {
  List<Cart> _cart = [];
  double _totalPrice = 0;
  double get totalPrice => _totalPrice;
  List<Cart> get cart => _cart;
  Options dioOptions = DioOptions().dioOptions;
  Dio getDio() {
    Dio dio = Dio();

    dio.interceptors.addAll(
      [
        DioInterceptorsWrapper(),
        DioOptions().dioCacheManager.interceptor,
      ],
    );
    return dio;
  }

  Future<void> addCart(Cart cart) async {
    try {
      await getDio()
          .get(
        "https://gentle-crag-94785.herokuapp.com/api/v1/carts/$globalUserId",
      )
          .then((_) async {
        final url =
            "https://gentle-crag-94785.herokuapp.com/api/v1/carts/$globalUserId";
        await getDio().patch(
          url,
          data: jsonEncode(
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
      }).catchError((err) async {
        if (err.toString().contains("404")) {
          const url = "https://gentle-crag-94785.herokuapp.com/api/v1/carts";
          await getDio().post(
            url,
            data: jsonEncode(
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
        }
      });
    } catch (er) {
      print(er);
    }
  }

  Future<Response?> getCart(String userId) async {
    final url = "https://gentle-crag-94785.herokuapp.com/api/v1/carts/$userId";

    try {
      final cart = await getDio().get(
        url,
      );
      final extractedData = cart.data["data"]["products"] as List;
      final customerId = cart.data["data"]["customerId"];

      _totalPrice =
          cart.data["priceCalculation"][0]["subTotalPrice"].toDouble();

      _cart = extractedData.map((el) => Cart.fromJson(el, customerId)).toList();
      notifyListeners();
      return cart;
    } catch (er) {}
    return null;
  }

  Future<void> updateQuantity(String objectId, int quantity) async {
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/carts/$globalUserId/product/$objectId";

    await getDio().patch(
      url,
      data: jsonEncode(
        {"quantity": quantity},
      ),
    );
  }

  Future<void> removeProductFromCart(Cart cart) async {
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/carts/$globalUserId/product/${cart.objectId}";
    await getDio().delete(
      url,
    );
  }

  Future resetItem() async {
    _cart.clear();
    _totalPrice = 0;
    notifyListeners();
  }
}
