import 'package:flutter/material.dart';
import 'package:lune_vpn_agent/main.dart';

showSuccessSnackBar(String title) {
  messengerKey.currentState!.showSnackBar(
    SnackBar(
      content: Text(title),
      backgroundColor: Colors.green,
    ),
  );
}
