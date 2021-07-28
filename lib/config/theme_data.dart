import 'package:flutter/material.dart';

class MyThemes {
  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.teal,
      brightness: Brightness.dark,
    ),
    textTheme: TextTheme(
      bodyText1: TextStyle(color: Colors.white),
      bodyText2: TextStyle(color: Colors.white),
    ),
    primarySwatch: Colors.teal,
    primaryColor: Colors.teal,
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.blue,
      brightness: Brightness.dark,
    ),
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue,
  );
}
