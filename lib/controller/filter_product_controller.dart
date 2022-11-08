import 'package:flutter/material.dart';

class FilterProductController with ChangeNotifier {
  Map<String, List> _filterList = {"category": [], "price": [], "color": []};
  Map<String, List> get filterList => _filterList;

  final String _query = "";
  addCategoryFilter(List categoryFilterList) {
    _filterList["category"] = categoryFilterList;
    notifyListeners();
  }

  String _getCategoryFilter() {
    String categoryFilter = '';

    filterList["category"]?.forEach((element) {
      categoryFilter = "${categoryFilter + element},";
    });

    if (categoryFilter.isNotEmpty) {
      categoryFilter = categoryFilter.substring(0, categoryFilter.length - 1);
      return "category=$categoryFilter&".toLowerCase();
    } else {
      return "";
    }
  }

  addPriceFilter(List priceFilterList) {
    _filterList["price"] = priceFilterList;
    notifyListeners();
  }

  String _getPriceFilter() {
    Map<String, String> priceFilter = {
      "min": "",
      "max": "",
    };
    if (filterList["price"]!.isNotEmpty) {
      String min = filterList["price"]?[0];
      String max = filterList["price"]?[1] != ''
          ? filterList["price"]![1]
          : "9999999999";
      priceFilter = {
        "min": min,
        "max": max,
      };
      print(
          "customerPrice[gte]=${priceFilter["min"]}&customerPrice[lte]=${priceFilter["max"]}&");
      return "customerPrice[gte]=${priceFilter["min"]}&customerPrice[lte]=${priceFilter["max"]}&";
    } else {
      return "";
    }
  }

  addColorFilter(List colorFilterList) {
    _filterList["color"] = colorFilterList;
    notifyListeners();
  }

  String _getColorFilter() {
    String colorFilter = '';

    filterList["color"]?.forEach((element) {
      colorFilter = "${colorFilter + element},";
    });

    if (colorFilter.isNotEmpty) {
      colorFilter = colorFilter.substring(0, colorFilter.length - 1);
      return "color=$colorFilter&".toLowerCase();
    } else {
      return "";
    }
  }

  String getQuery() {
    String query =
        "${_getCategoryFilter()}${_getPriceFilter()}${_getColorFilter()}";
    while (query.endsWith("&")) {
      query = query.substring(0, query.length - 1);
    }

    return query;
  }

  bool getFilterStatus() {
    if (_filterList["category"]!.isEmpty &&
        _filterList["price"]!.isEmpty &&
        _filterList["color"]!.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  clearFilter() {
    _filterList = {
      "category": [],
      "price": [],
      "color": [],
    };
    notifyListeners();
  }
}
