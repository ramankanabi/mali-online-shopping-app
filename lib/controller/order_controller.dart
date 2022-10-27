import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping/model/oder_model.dart';

import '../model/cart_model.dart';
import 'auth_contoller.dart';

class OrderController with ChangeNotifier {
  final List<Map> _finalOrderList = [];
  final List<List<Order>> _order = [];
  List<List<Order>> get order => _order;
  prepareOrderList(List<Cart> cart) async {
    _finalOrderList.clear();
    cart.forEach((el) {
      _finalOrderList.add({
        "productName": el.productName,
        "productId": el.productId,
        "images": el.images,
        "quantity": el.quantity,
        "size": el.size,
        "price": el.price,
        "subTotalPrice": el.subTotalPrice,
      });
    });

    notifyListeners();
  }

  Future<http.Response?> addOrder(
    String customerId,
    String phoneNumber,
    String city,
    String location,
  ) async {
    try {
      const url = "https://gentle-crag-94785.herokuapp.com/api/v1/orders";
      final cartUrl =
          "https://gentle-crag-94785.herokuapp.com/api/v1/carts/$customerId";
      final order = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            "Authorization": "Bearer $globalToken"
          },
          body: jsonEncode({
            "customerId": customerId,
            "products": _finalOrderList,
            "phoneNumber": phoneNumber,
            "city": city,
            "location": location
          }));

      final deleteCurentCart = await http.delete(
        Uri.parse(cartUrl),
      );
      return order;
    } catch (er) {
      print(er);
    }
    return null;
  }

  Future getUserAllOrder(String customerId) async {
    _order.clear();
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/orders/customer/$customerId";
    // notifyListeners();
    final response = await http.get(Uri.parse(url));
    final orderList = jsonDecode(response.body)["data"]["data"] as List;
    final generalData = jsonDecode(response.body);

    for (var orderListData in orderList) {
      final products = orderListData["products"] as List;
      _order.addAll([
        products
            .map((itemData) => Order.fromJson(itemData, orderListData))
            .toList()
      ]);
    }

    // _orderItem = productData
    //     .map((prodData) => Order.fromJson(prodData, generalData))
    //     .toList();
    notifyListeners();
    return response;
  }
}
