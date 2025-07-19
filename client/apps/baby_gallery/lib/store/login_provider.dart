import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  bool login(String username, String password) {
    if (username == 'user' && password == 'pass') {
      () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', username);
        await prefs.setString('password', password);
        notifyListeners();
      };
      return true;
    }
    notifyListeners();
    return false;
  }

  void logout() {
    () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('username');
      await prefs.remove('password');
      notifyListeners();
    };
  }
}
