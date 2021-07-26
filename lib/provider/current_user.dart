import 'package:flutter/foundation.dart';

class CurrentUser extends ChangeNotifier {
  bool isLogin = false;
  String? username;
  String? uid;
  String? email;
  int? myMoney = 0;
  bool isSuperUser = false;

  setSuperUser(bool value) {
    isSuperUser = value;
    notifyListeners();
  }

  setMoney(int? newMoney) {
    myMoney = newMoney;
    notifyListeners();
  }

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
