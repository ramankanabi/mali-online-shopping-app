import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:online_shopping/model/user_model.dart';

class UserController with ChangeNotifier {
  User _user = User(name: "", phoneNumber: "", city: "", birthYear: 0);

  User get user {
    return _user;
  }

  Future<void> getUserData(String userId) async {
    try {
      final url =
          "https://gentle-crag-94785.herokuapp.com/api/v1/user/id/$userId";
      final user = await http.get(Uri.parse(url));
      final extractedData = json.decode(user.body);
      _user = User(
          name: extractedData["data"]["user"]["name"],
          phoneNumber: extractedData["data"]["user"]["phoneNumber"],
          city: extractedData["data"]["user"]["city"],
          birthYear: extractedData["data"]["user"]["birthYear"]);
    } catch (er) {
      print(er);
    }
    notifyListeners();
  }
}
