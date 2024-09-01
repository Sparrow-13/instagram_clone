import 'package:flutter/material.dart';

import '../entity/user.dart';

class GlobalContext with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  void removeUser() {
    _user = null;
    notifyListeners();
  }
}
