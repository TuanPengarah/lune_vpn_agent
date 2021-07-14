import 'package:flutter/material.dart';

SizedBox textBar({
  required BuildContext context,
  required TextInputType inputType,
  required IconData icon,
  required bool isPassword,
  required TextInputAction inputAction,
  String? label,
  String? hint,
}) {
  return SizedBox(
    width: 400,
    child: TextField(
      obscureText: isPassword,
      keyboardType: inputType,
      textInputAction: inputAction,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label ?? '',
        hintText: hint ?? '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
    ),
  );
}
