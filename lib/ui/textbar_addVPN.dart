import 'package:flutter/material.dart';

TextField buildTextField(
  TextEditingController _userNameController,
  bool _errUsername,
) {
  return TextField(
    textCapitalization: TextCapitalization.words,
    controller: _userNameController,
    decoration: InputDecoration(
      errorText: _errUsername == true ? 'Please enter your vpn username' : null,
      labelText: 'Enter your vpn username',
    ),
  );
}
