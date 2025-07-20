import 'package:baby_gallery/store/users.dart';
import 'package:flutter/material.dart';

class UsersProvider with ChangeNotifier {
  List<User> _users = [];

  List<User> get users => _users;

  void addUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  void removeUser(User user) {
    _users.remove(user);
    notifyListeners();
  }

  void setUsers(List<User> users) {
    _users = users;
    notifyListeners();
  }
}
