import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:online_shopping/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

String globalToken = "";
String globalUserId = "";

class AuthController with ChangeNotifier {
  late String _token;
  String? _verificationCode;
  bool? isUserExist;
  final storage = new FlutterSecureStorage();

  late String _userId;
  bool _isLogged = false;
  Future<void> _createUser(User user, String token) async {
    const url = "https://gentle-crag-94785.herokuapp.com/api/v1/user/signup";

    try {
      final userCreated = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode({
            "token": token,
            "name": user.name,
            "phoneNumber": user.phoneNumber,
            "city": user.city,
            "birthYear": user.birthYear,
          }));
      final extractedData = json.decode(userCreated.body);
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
      print("login succefully .");
      notifyListeners();

      notifyListeners();
    } catch (er) {
      print(er);
      throw er;
    }
  }

  Future<void> _login(String token, User user) async {
    try {
      if (isUserExist == true) {
        const url = "https://gentle-crag-94785.herokuapp.com/api/v1/user/login";
        final loggedUser = await http.post(Uri.parse(url),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              "token": token,
              "phoneNumber": user.phoneNumber,
            }));
        final extractedData = json.decode(loggedUser.body);
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
        print("login succefully .");
        notifyListeners();
      }
    } catch (er) {
      print(er);
      throw er;
    }
  }

  Future<void> verifyPhone(User user) async {
    try {
      final firebaseAuth = await auth.FirebaseAuth.instance
          .verifyPhoneNumber(
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
      )
          .then((value) {
        // startCounter();
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text("code is sent")));
      });
      notifyListeners();
    } catch (er) {
      print(er);
      throw er;
    }
  }

  Future<void> checkCode(String smsCodeContoller, User user) async {
    try {
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
    } catch (e) {
      print(e);
      throw e;
    }
  }

  Future<bool> checkUser(String phoneNumber) async {
    late http.Response user;
    late dynamic extracteData;
    try {
      user = await http.get(Uri.parse(
          "https://gentle-crag-94785.herokuapp.com/api/v1/user/phone/$phoneNumber"));
      extracteData = jsonDecode(user.body);
    } catch (er) {
      print(er);
    }

    if (extracteData["data"]["user"] == null) {
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
    await storage.delete(key: "jwt");
    await storage.delete(key: "userId");
    _isLogged = false;

    notifyListeners();
  }
}
