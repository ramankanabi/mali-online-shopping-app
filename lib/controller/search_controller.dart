import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:online_shopping/model/product_model.dart';
import 'package:http/http.dart' as http;

class SearchController with ChangeNotifier {
  List<Product> _searchList = [];

  List<Product> get searchList => _searchList;

  Future getSearchResult(String searchInput) async {
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/products/search/$searchInput";
    try {
      final search = await http.get(Uri.parse(url));
      final extractedData = jsonDecode(search.body)["data"] as List;

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
