import 'package:flutter/material.dart';

import '../entity/User.dart';

class GlobalContext with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }
}
