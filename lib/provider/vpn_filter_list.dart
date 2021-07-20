import 'package:flutter/material.dart';

class VpnFilterList extends ChangeNotifier {
  bool isAscending = true;

  setAscending(bool value) {
    isAscending = value;
    notifyListeners();
  }
}
