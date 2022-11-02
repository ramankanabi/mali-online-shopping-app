import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping/model/user_model.dart';

import '../apiService/dio_interceptors_wrapper.dart';
import '../apiService/dio_options.dart';

class UserController with ChangeNotifier {
  User _user = User(name: "", phoneNumber: "", city: "", birthYear: 0);
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  User get user {
    return _user;
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

  Future<void> getUserData(String userId) async {
    try {
      _isLoading = true;
      final url =
          "https://gentle-crag-94785.herokuapp.com/api/v1/user/id/$userId";
      final user = await getDio().get(url, options: dioOptions);
      final extractedData = user.data;
      _user = User(
          name: extractedData["data"]["user"]["name"],
          phoneNumber: extractedData["data"]["user"]["phoneNumber"],
          city: extractedData["data"]["user"]["city"],
          birthYear: extractedData["data"]["user"]["birthYear"]);
    } catch (er) {
      print(er);
    }
    _isLoading = false;
    notifyListeners();
  }
}
