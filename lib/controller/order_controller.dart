import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:online_shopping/model/oder_model.dart';

import '../apiService/dio_interceptors_wrapper.dart';
import '../apiService/dio_options.dart';
import '../model/cart_model.dart';

class OrderController with ChangeNotifier {
  final List<Map> _finalOrderList = [];
  final List<List<Order>> _order = [];
  List<List<Order>> get order => _order;

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

  prepareOrderList(List<Cart> cart) async {
    _finalOrderList.clear();
    for (var el in cart) {
      _finalOrderList.add({
        "productName": el.productName,
        "productId": el.productId,
        "images": el.images,
        "quantity": el.quantity,
        "size": el.size,
        "price": el.price,
        "subTotalPrice": el.subTotalPrice,
      });
    }

    notifyListeners();
  }

  Future<Response?> addOrder(
    String customerId,
    String phoneNumber,
    String city,
    String location,
  ) async {
    try {
      const url = "https://gentle-crag-94785.herokuapp.com/api/v1/orders";
      final cartUrl =
          "https://gentle-crag-94785.herokuapp.com/api/v1/carts/$customerId";
      final order = await getDio().post(url,
          data: jsonEncode({
            "customerId": customerId,
            "products": _finalOrderList,
            "phoneNumber": phoneNumber,
            "city": city,
            "location": location
          }));

      await getDio().delete(
        cartUrl,
      );
      return order;
    } catch (er) {}
    return null;
  }

  Future getUserAllOrder(String customerId) async {
    _order.clear();
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/orders/customer/$customerId";
    final response = await getDio().get(url, options: dioOptions);
    final orderList = response.data["data"]["data"] as List;

    for (var orderListData in orderList) {
      final products = orderListData["products"] as List;
      _order.addAll([
        products
            .map((itemData) => Order.fromJson(itemData, orderListData))
            .toList()
      ]);
    }

    notifyListeners();
    return response;
  }
}
