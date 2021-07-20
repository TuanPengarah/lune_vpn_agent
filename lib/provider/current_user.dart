import 'package:flutter/foundation.dart';

class CurrentUser extends ChangeNotifier {
  bool isLogin = false;
  String? username;
  String? uid;
  String? email;

  checkLogin(bool newValue) {
    isLogin = newValue;
    notifyListeners();
  }

  setUserName(String? newName) {
    username = newName;
    notifyListeners();
  }

  setUID(String? newUID) {
    uid = newUID;
    notifyListeners();
  }

  setEmail(String? newEmail) {
    email = newEmail;
    notifyListeners();
  }
}
