import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  String? username;
  String? password;

  bool login(String username, String password) {
    if (username == 'user' && password == 'pass') {
      this.username = username;
      this.password = password;
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  }

  void logout() {
    username = null;
    password = null;
    notifyListeners();
  }
}
