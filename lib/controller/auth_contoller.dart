// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:online_shopping/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../apiService/dio_interceptors_wrapper.dart';
import '../apiService/dio_options.dart';

String globalToken = "";
String globalUserId = "";

class AuthController with ChangeNotifier {
  late String _token;
  String? _verificationCode;
  bool? isUserExist;
  final storage = const FlutterSecureStorage();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  late String _userId;
  bool _isLogged = false;

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

  Future<void> _createUser(User user, String token) async {
    const url = "https://gentle-crag-94785.herokuapp.com/api/v1/user/signup";

    try {
      final userCreated = await getDio().post(url,
          data: json.encode({
            "token": token,
            "name": user.name,
            "phoneNumber": user.phoneNumber,
            "city": user.city,
            "birthYear": user.birthYear,
          }));
      final extractedData = userCreated.data;
      await storage.write(key: "jwt", value: extractedData["token"]);
      await storage.write(
          key: "userId", value: extractedData["data"]["user"]["_id"]);
      _userId = extractedData["data"]["user"]["_id"];
      _token = extractedData["token"];
      if (_token != null && _userId != null) {
        _isLogged = true;
      } else {
        _isLogged = false;
      }
      notifyListeners();

      notifyListeners();
    } catch (_) {}
  }

  Future<void> _login(String token, User user) async {
    try {
      if (isUserExist == true) {
        const url = "https://gentle-crag-94785.herokuapp.com/api/v1/user/login";
        final loggedUser = await getDio().post(
          url,
          data: jsonEncode(
            {
              "token": token,
              "phoneNumber": user.phoneNumber,
            },
          ),
        );
        final extractedData = loggedUser.data;
        await storage.write(key: "jwt", value: extractedData["token"]);
        await storage.write(
            key: "userId", value: extractedData["data"]["user"]["_id"]);
        _userId = extractedData["data"]["user"]["_id"];
        _token = extractedData["token"];
        globalToken = _token;
        globalUserId = _userId;
        if (_token != null && _userId != null) {
          _isLogged = true;
        } else {
          _isLogged = false;
        }
        notifyListeners();
      }
    } catch (er) {}
  }

  Future<void> verifyPhone(User user) async {
    try {
      await auth.FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+964${user.phoneNumber}',
        verificationCompleted: (auth.PhoneAuthCredential credential) async {
          // await auth.FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (auth.FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String? verficationID, int? resendToken) {
          _verificationCode = verficationID;
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          _verificationCode = verificationID;
        },
        timeout: const Duration(seconds: 60),
      );
      notifyListeners();
    } catch (_) {}
  }

  Future<void> checkCode(String smsCodeContoller, User user) async {
    try {
      _isLoading = true;
      notifyListeners();
      final firebaseAuth =
          await auth.FirebaseAuth.instance.signInWithCredential(
        auth.PhoneAuthProvider.credential(
            verificationId: _verificationCode!,
            smsCode: smsCodeContoller.toString()),
      );
      if (firebaseAuth.user != null) {
        await firebaseAuth.user?.getIdToken().then((token) async {
          if (isUserExist == true) {
            _login(token, user);
          } else {
            await _createUser(user, token);
          }
        });
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkUser(String phoneNumber) async {
    final user = await getDio().get(
        "https://gentle-crag-94785.herokuapp.com/api/v1/user/phone/$phoneNumber");

    if (user.data["data"]["user"] == null) {
      isUserExist = false;
      print("a user doesn't exist");
      return false;
    } else {
      isUserExist = true;
      print("a user exist");
      return true;
    }
  }

  setTokenAndUserIdAndLoggedStatus() async {
    final token = await storage.read(key: "jwt");
    final userId = await storage.read(key: "userId");
    _userId = userId.toString();
    _token = token.toString();
    globalToken = token.toString();
    globalUserId = userId.toString();

    if (token != null && userId != null) {
      _isLogged = true;
    } else {
      _isLogged = false;
    }
    notifyListeners();
  }

  get getUserId {
    return _userId;
  }

  get getToken {
    return _token;
  }

  get isLogged {
    return _isLogged;
  }

  Future<void> logOut() async {
    _isLoading = true;
    notifyListeners();
    await storage.delete(key: "jwt");
    await storage.delete(key: "userId");
    globalToken = "";
    globalUserId = "";
    _isLogged = false;
    _isLoading = false;

    notifyListeners();
  }
}
