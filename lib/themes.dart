import 'package:flutter/material.dart';

enum AppTheme {
  LightStatusBar,
  DarkStatusBar,
}

final themeData = {
  AppTheme.DarkStatusBar: ThemeData(
    appBarTheme: AppBarTheme(
      brightness: Brightness.dark,
      color: Color(0xFF465a64),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
  ),
  AppTheme.LightStatusBar: ThemeData(
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      color: Colors.white,
      iconTheme: IconThemeData(
        color: Color(0xFF465a64),
      ),
    ),
  )
};
