import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:online_shopping/model/product_model.dart';
import 'package:http/http.dart' as http;

import '../apiService/dio_interceptors_wrapper.dart';
import '../apiService/dio_options.dart';

class SearchController with ChangeNotifier {
  List<Product> _searchList = [];

  List<Product> get searchList => _searchList;
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

  Future getSearchResult(String searchInput) async {
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/products/search/$searchInput";
    try {
      final search = await getDio().get(url, options: dioOptions);
      final extractedData = search.data["data"] as List;

      _searchList =
          extractedData.map((product) => Product.fromJson(product)).toList();
      return search;
    } catch (er) {
      print(er);
    }

    notifyListeners();
  }

  resetSearchList() {
    _searchList.clear();
    notifyListeners();
  }
}
