import 'dart:ffi';

import 'package:dio/dio.dart';

import '../controller/auth_contoller.dart';

class DioInterceptorsWrapper extends QueuedInterceptorsWrapper {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      "Authorization": "Bearer $globalToken"
    };

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("responseeeee");
    super.onResponse(response, handler);
  }
}
