import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/main.dart';

showNotifSnackBar(String title, int duration) {
  messengerKey.currentState!.showSnackBar(
    SnackBar(
      content: Text(title),
      duration: Duration(seconds: duration),
    ),
  );
}
