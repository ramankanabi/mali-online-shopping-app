import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:online_shopping/apiService/dio_interceptors_wrapper.dart';
import 'package:online_shopping/apiService/dio_options.dart';
import 'package:online_shopping/model/product_model.dart';
import "package:dio/dio.dart";

class ProductContoller with ChangeNotifier {
  int _page = 1;
  int _categoryPage = 1;
  int _advertisePage = 1;
  final int _limit = 20;

  List<Product> _items = [];
  List<Product> get items => _items;

  Product _product = Product(
    quantity: 0,
    name: "",
    prodId: "",
    price: 0,
    size: [],
    images: [],
    relatedProduct: [],
  );

  Product get product => _product;

  List<Product> _advertiseItems = [];

  List<Product> get advertiseItems => _advertiseItems;

  List<Product> _categoryItems = [];
  List<Product> get categoryItems => _categoryItems;

  List<Product> _similarProdctItems = [];
  List<Product> get similarProdctItems => _similarProdctItems;

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

  Future fetchProductData() async {
    try {
      _page = 1;
      final url =
          "https://mali-online-shoppingg.herokuapp.com/api/v1/products?page=$_page&limit=$_limit&sort=productName";

      final response = await getDio().get(url, options: dioOptions);
      final extractedData = response.data["data"] as List;

      _items =
          extractedData.map((prodData) => Product.fromJson(prodData)).toList();
      notifyListeners();
      return response;
    } catch (er) {}
  }

  Future<Product?> fetchOneProduct(String prodId) async {
    final url =
        "https://mali-online-shoppingg.herokuapp.com/api/v1/products/$prodId";
    try {
      final response = await getDio().get(url, options: dioOptions);
      final extractedData = response.data["data"]["data"];
      _product = Product.fromJson(extractedData);

      return _product;
    } catch (er) {}
    return null;
  }

  Future fetchAdvertiseProductData() async {
    _advertisePage = 1;
    try {
      final url =
          "https://mali-online-shoppingg.herokuapp.com/api/v1/products?priceDiscount[gt]=0&page=$_advertisePage&limit=$_limit";
      final response = await getDio().get(url);
      final extractedData = response.data["data"] as List;

      _advertiseItems =
          extractedData.map((prodData) => Product.fromJson(prodData)).toList();
      notifyListeners();
      return response;
    } catch (_) {}
  }

  Future advertiseloadMore() async {
    try {
      _advertisePage = _advertisePage + 1;

      final url =
          "https://mali-online-shoppingg.herokuapp.com/api/v1/products?priceDiscount[gt]=0&page=$_advertisePage&limit=$_limit";

      final response = await getDio().get(url, options: dioOptions);
      final extractedData = jsonDecode(response.data)["data"] as List;
      if (jsonDecode(response.data)["results"] != 0) {
        _advertiseItems.addAll(extractedData
            .map((prodData) => Product.fromJson(prodData))
            .toList());
      } else {}
    } catch (er) {}
    notifyListeners();
  }

  Future fetchCategoryProductData(String query) async {
    _categoryPage = 1;
    try {
      final url =
          "https://mali-online-shoppingg.herokuapp.com/api/v1/products?$query&page=$_categoryPage&limit=$_limit";
      final response = await getDio().get(url);
      final extractedData = response.data["data"] as List;

      _categoryItems =
          extractedData.map((prodData) => Product.fromJson(prodData)).toList();
      notifyListeners();
      return response;
    } catch (er) {}
  }

  Future loadMore() async {
    try {
      _page++;
      final url =
          "https://mali-online-shoppingg.herokuapp.com/api/v1/products?page=$_page&limit=$_limit&sort=productName";

      final response = await getDio().get(url, options: dioOptions);
      final extractedData = response.data["data"] as List;
      if (response.data["results"] != 0) {
        _items.addAll(extractedData
            .map((prodData) => Product.fromJson(prodData))
            .toList());
      } else {
        _page = _page - 1;
      }
    } catch (er) {}
    notifyListeners();
  }

  Future categoryloadMore(String query) async {
    try {
      _categoryPage = _categoryPage + 1;
      final url =
          "https://mali-online-shoppingg.herokuapp.com/api/v1/products?$query&page=$_categoryPage&limit=$_limit";

      final response = await getDio().get(url, options: dioOptions);
      final extractedData = response.data["data"] as List;
      if (response.data["results"] != 0) {
        _categoryItems.addAll(extractedData
            .map((prodData) => Product.fromJson(prodData))
            .toList());
      } else {
        _categoryPage = _categoryPage - 1;
      }
    } catch (er) {}
    notifyListeners();
  }

  Future similarProducts(String category) async {
    try {
      _page = 1;
      final url =
          "https://mali-online-shoppingg.herokuapp.com/api/v1/products?category=$category&limit=10";

      final response = await getDio().get(url, options: dioOptions);
      final extractedData = response.data["data"] as List;

      _similarProdctItems =
          extractedData.map((prodData) => Product.fromJson(prodData)).toList();
      notifyListeners();
      return response;
    } catch (er) {}
  }

  resetCategoryProductItem() {
    _categoryItems.clear();
    notifyListeners();
  }

  resetItem() {
    _items.clear();
    notifyListeners();
  }

  resetAdvertiseItem() {
    _advertiseItems.clear();
    notifyListeners();
  }
}
