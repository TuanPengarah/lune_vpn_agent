import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/main.dart';

showErrorSnackBar(String title) {
  messengerKey.currentState!.showSnackBar(
    SnackBar(
      content: Text(title),
      backgroundColor: Colors.red,
    ),
  );
}
