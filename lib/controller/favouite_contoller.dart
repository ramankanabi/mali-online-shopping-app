import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:online_shopping/controller/auth_contoller.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping/model/favourite_model.dart';

class FavouriteContoller with ChangeNotifier {
  bool _isFav = false;
  List<Favourite> _favItems = [];
  bool _iasLoaing = false;
  bool get isLoading => _iasLoaing;
  List<Favourite> get favItems {
    return _favItems;
  }

  bool get isFav {
    return _isFav;
  }

  Future<void> addToFavourite(String prodId, String userId) async {
    const url = "https://gentle-crag-94785.herokuapp.com/api/v1/favourites";
    try {
      await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json',
            "Authorization": "Bearer $globalToken"
          },
          body: jsonEncode({
            "userId": userId,
            "productId": prodId,
          }));
    } catch (er) {
      print(er);
    }
  }

  Future<void> removeFavourite(String prodId, String userId) async {
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/favourites/$userId/product/$prodId";
    try {
      final deleteFav = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          "Authorization": "Bearer $globalToken"
        },
      );
    } catch (er) {
      print(er);
    }
  }

  Future<http.Response?> getFavourite(String prodId, String userId) async {
    _isFav = false;
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/favourites/$userId/product/$prodId";
    try {
      final fav = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          "Authorization": "Bearer $globalToken"
        },
      );
      if (fav.statusCode != 404) {
        _isFav = true;
        print("trueeeeeeeeeeeeeeeeeeeeee");
        notifyListeners();
      } else {
        print("flaaaasssseeee");
        _isFav = false;
        notifyListeners();
      }

      return fav;
    } catch (er) {
      print(er);
    }
  }

  Future getUserAllFavourites(String userId) async {
    try {
      _iasLoaing = true;
      final url =
          "https://gentle-crag-94785.herokuapp.com/api/v1/favourites/$userId";

      final favs = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
          "Authorization": "Bearer $globalToken"
        },
      );
      if (favs.statusCode != 404) {
        final extractedData = jsonDecode(favs.body)["data"]["data"] as List;

        _favItems = extractedData
            .map((prodData) => Favourite.fromJson(prodData))
            .toList();
        _iasLoaing = false;
        notifyListeners();
      }

      return favs;
    } catch (er) {
      _iasLoaing = false;
      notifyListeners();
      print(er);
    }
  }

  resetItems() {
    _favItems.clear();
    notifyListeners();
  }
}
