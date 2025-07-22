import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  bool login(String username, String password) {
    if (username == 'user' && password == 'pass1234@') {
      () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        notifyListeners();
      }();
      return true;
    }
    notifyListeners();
    return false;
  }

  void logout() {
    () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      notifyListeners();
    }();
  }
}
