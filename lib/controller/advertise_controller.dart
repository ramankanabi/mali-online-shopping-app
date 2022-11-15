import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/model/advertise_model.dart';

import '../apiService/dio_interceptors_wrapper.dart';
import '../apiService/dio_options.dart';

class AdvertiseContoller with ChangeNotifier {
  List<Advertise> _advItems = [];
  List<Advertise> get advItems {
    return _advItems;
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

  Future getAllAdvertises() async {
    try {
      const url = "https://gentle-crag-94785.herokuapp.com/api/v1/advertise/";

      final advs = await getDio().get(url, options: dioOptions);
      final extractedData = advs.data["data"] as List;
      _advItems = extractedData.map((adv) => Advertise.fromJson(adv)).toList();

      return advs;
    } catch (_) {}
  }

  resetItems() {
    _advItems.clear();
    notifyListeners();
  }
}
