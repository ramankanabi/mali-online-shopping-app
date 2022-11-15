import 'package:flutter/material.dart';

class FilterProductController with ChangeNotifier {
  Map<String, String> _filterList = {
    "category": "",
    "minPrice": "",
    "maxPrice": "",
    "color": ''
  };
  Map<String, String> get filterList => _filterList;

  addCategoryFilter(String categoryFilter) {
    _filterList["category"] = categoryFilter;
    notifyListeners();
  }

  String _getCategoryFilter() {
    String categoryFilter = '';

    categoryFilter = filterList["category"]!;

    if (categoryFilter != '') {
      return "category=$categoryFilter&".toLowerCase();
    } else {
      return "";
    }
  }

  addPriceFilter(String minPriceFilter, String maxPriceFilter) {
    _filterList["maxPrice"] = maxPriceFilter;
    _filterList["minPrice"] = minPriceFilter;
    notifyListeners();
  }

  String _getPriceFilter() {
    String query = '';
    if (filterList["minPrice"] != '') {
      String min = filterList["minPrice"]!;
      query = "customerPrice[gte]=$min&";
    }
    if (filterList["maxPrice"] != '') {
      String max = filterList["maxPrice"]!;
      query = "${query}customerPrice[lte]=$max&";
    }
    return query;
  }

  addColorFilter(String colorFilterList) {
    _filterList["color"] = colorFilterList;
    notifyListeners();
  }

  String _getColorFilter() {
    String colorFilter = '';

    colorFilter = filterList["color"]!;
    if (colorFilter != '') {
      return "color=$colorFilter&".toLowerCase();
    } else {
      return '';
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
    if (_filterList["category"] == '' &&
        _filterList["maxPrice"] == '' &&
        _filterList["minPrice"] == '' &&
        _filterList["color"] == "") {
      return false;
    } else {
      return true;
    }
  }

  clearFilter() {
    _filterList = {
      "category": '',
      "maxPrice": '',
      "minPrice": '',
      "color": '',
    };
    notifyListeners();
  }
}
