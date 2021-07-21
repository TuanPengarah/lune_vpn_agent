import 'package:flutter/material.dart';

class VpnFilterList extends ChangeNotifier {
  bool isAscending = true;
  bool isAll = true;
  String status = 'All';

  setAscending(bool value) {
    isAscending = value;
    notifyListeners();
  }

  setAllFilter(bool value) {
    isAll = value;
    notifyListeners();
  }

  setStatus(String newStatus) {
    status = newStatus;
    notifyListeners();
  }
}
