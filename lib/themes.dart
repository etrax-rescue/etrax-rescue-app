import 'package:flutter/material.dart';

enum AppTheme {
  LightStatusBar,
  DarkStatusBar,
  Black,
}

final textColor = const Color(0xFF465a64);

final textTheme = TextTheme(
  headline5: TextStyle(color: textColor),
  bodyText1: TextStyle(color: textColor),
  bodyText2: TextStyle(color: textColor),
  subtitle1: TextStyle(color: textColor),
);

final themeData = {
  AppTheme.DarkStatusBar: ThemeData(
    backgroundColor: const Color(0xFFFAFAFA),
    primaryColor: textColor,
    accentColor: const Color(0xffd32f2f),
    textTheme: textTheme,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.grey),
      hintStyle: TextStyle(color: Colors.grey),
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      color: Color(0xFF465a64),
      textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
  ),
  AppTheme.LightStatusBar: ThemeData(
    backgroundColor: const Color(0xFFFAFAFA),
    primaryColor: textColor,
    accentColor: const Color(0xffd32f2f),
    textTheme: textTheme,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.grey),
      hintStyle: TextStyle(color: Colors.grey),
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      color: Color(0xFFFAFAFA),
      textTheme: textTheme,
      iconTheme: IconThemeData(
        color: Color(0xFF465a64),
      ),
    ),
  ),
  AppTheme.Black: ThemeData(
    backgroundColor: Colors.black,
    primaryColor: textColor,
    accentColor: const Color(0xffd32f2f),
    textTheme: textTheme,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.grey),
      hintStyle: TextStyle(color: Colors.grey),
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      color: Color.fromARGB(128, 0, 0, 0),
      textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.white),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
  ),
};
