import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/model/favourite_model.dart';

import '../apiService/dio_interceptors_wrapper.dart';
import '../apiService/dio_options.dart';

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

  Future<void> addToFavourite(String prodId, String userId) async {
    const url = "https://gentle-crag-94785.herokuapp.com/api/v1/favourites";
    try {
      await getDio().post(url,
          data: jsonEncode({
            "userId": userId,
            "productId": prodId,
          }));
    } catch (er) {}
  }

  Future<void> removeFavourite(String prodId, String userId) async {
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/favourites/$userId/product/$prodId";
    try {
      await getDio().delete(
        url,
      );
    } catch (er) {}
  }

  Future<bool> getFavourite(String prodId, String userId) async {
    _isFav = false;
    final url =
        "https://gentle-crag-94785.herokuapp.com/api/v1/favourites/$userId/product/$prodId";
    try {
      final fav = await getDio().get(url, options: dioOptions);
      if (fav.statusCode != 404) {
        return true;
      } else {
        return false;
      }
    } catch (er) {
      return false;
    }
  }

  Future getUserAllFavourites(String userId) async {
    try {
      _iasLoaing = true;
      final url =
          "https://gentle-crag-94785.herokuapp.com/api/v1/favourites/$userId";

      final favs = await getDio().get(url, options: dioOptions);
      if (favs.statusCode != 404) {
        final extractedData = favs.data["data"]["data"] as List;

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
    }
  }

  resetItems() {
    _favItems.clear();
    notifyListeners();
  }
}
