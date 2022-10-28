import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping/model/product_model.dart';

class ProductContoller with ChangeNotifier {
  int _page = 1;
  int _categoryPage = 1;
  final int _limit = 26;

  List<Product> _items = [];
  List<Product> get items => _items;

  Product _product = Product(
      quantity: 0, name: "", prodId: "", price: 0, size: [], images: []);

  Product get product => _product;

  List<Product> _categoryItems = [];

  List<Product> get categoryItems => _categoryItems;

  Future fetchProductData() async {
    try {
      _page = 1;
      final url =
          "https://gentle-crag-94785.herokuapp.com/api/v1/products?page=$_page&limit=$_limit";
      final response = await http.get(Uri.parse(url));
      final extractedData = jsonDecode(response.body)["data"] as List;

      _items =
          extractedData.map((prodData) => Product.fromJson(prodData)).toList();
      notifyListeners();
      return response;
    } catch (er) {
      print(er);
    }
  }

  Future<http.Response?> fetchOneProduct(String prodId) async {
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/products/$prodId";
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = jsonDecode(response.body)["data"]["data"];
      _product = Product.fromJson(extractedData);
      notifyListeners();

      return response;
    } catch (er) {
      print(er);
    }
    return null;
  }

  // String curentCategory = '';
  Future fetchCategoryProductData(String category) async {
    // if (curentCategory != category) {
    //   _categoryItems = [];
    //   curentCategory = category;
    // }
    _categoryPage = 1;

    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/products?category=$category&page=$_categoryPage&limit=$_limit";
    final response = await http.get(Uri.parse(url));
    final extractedData = jsonDecode(response.body)["data"] as List;

    _categoryItems =
        extractedData.map((prodData) => Product.fromJson(prodData)).toList();
    notifyListeners();
    return response;
  }

  Future loadMore() async {
    try {
      _page++;
      final url =
          "https://gentle-crag-94785.herokuapp.com/api/v1/products?page=$_page&limit=$_limit";

      final response = await http.get(Uri.parse(url));
      final extractedData = jsonDecode(response.body)["data"] as List;
      if (jsonDecode(response.body)["results"] != 0) {
        _items.addAll(extractedData
            .map((prodData) => Product.fromJson(prodData))
            .toList());
      }
    } catch (er) {
      print(er);
    }
    notifyListeners();
  }

  Future categoryloadMore(String categoryName) async {
    try {
      _categoryPage = _categoryPage + 1;

      final url =
          "https://gentle-crag-94785.herokuapp.com/api/v1/products?category=$categoryName&page=${_categoryPage}&limit=$_limit";

      final response = await http.get(Uri.parse(url));
      final extractedData = jsonDecode(response.body)["data"] as List;
      if (jsonDecode(response.body)["results"] != 0) {
        _categoryItems.addAll(extractedData
            .map((prodData) => Product.fromJson(prodData))
            .toList());
      } else {}
    } catch (er) {
      print(er);
    }
    notifyListeners();
  }

  Future resetCategoryProductItem() async {
    _categoryItems.clear();
    notifyListeners();
  }

  Future resetItem() async {
    _items.clear();
    notifyListeners();
  }
}
