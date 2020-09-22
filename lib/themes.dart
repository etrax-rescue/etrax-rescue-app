import 'package:flutter/material.dart';

enum AppTheme {
  LightStatusBar,
  DarkStatusBar,
  Black,
}

MaterialColor primarySwatch = MaterialColor(500, {
  50: const Color(0xffe9ebec),
  100: const Color(0xffc8ced1),
  200: const Color(0xffa3adb2),
  300: const Color(0xff7e8c93),
  400: const Color(0xff62737b),
  500: const Color(0xff465a64),
  600: const Color(0xff3f525c),
  700: const Color(0xff374852),
  800: const Color(0xff2f3f48),
  900: const Color(0xff202e36),
});

Color accentColor = const Color(0xffd32f2f);
Color lightBackgroundColor = const Color(0xFFFAFAFA);
Color darkBackgroundColor = Colors.black;

final textColor = const Color(0xFF465a64);

final textTheme = TextTheme(
  headline5: TextStyle(color: textColor),
  bodyText1: TextStyle(color: textColor),
  bodyText2: TextStyle(color: textColor),
  subtitle1: TextStyle(color: textColor),
);

/*
final themeData = {
  AppTheme.DarkStatusBar: ThemeData.from(
    colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primarySwatch,
        accentColor: accentColor,
        backgroundColor: lightBackgroundColor,
        brightness: Brightness.dark),
    textTheme: textTheme,
  ),
  AppTheme.LightStatusBar: ThemeData.from(
    colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primarySwatch,
        accentColor: accentColor,
        backgroundColor: lightBackgroundColor,
        brightness: Brightness.light),
    textTheme: textTheme,
  ),
  AppTheme.Black: ThemeData.from(
    colorScheme: ColorScheme.fromSwatch(
        primarySwatch: primarySwatch,
        accentColor: accentColor,
        backgroundColor: darkBackgroundColor,
        brightness: Brightness.dark),
    textTheme: textTheme,
  ),
};*/

final themeData = {
  AppTheme.DarkStatusBar: ThemeData(
    backgroundColor: const Color(0xFFFAFAFA),
    primaryColor: textColor,
    primaryColorLight: const Color(0xFFa3adb2),
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
        headline6: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
  ),
  AppTheme.LightStatusBar: ThemeData(
    backgroundColor: const Color(0xFFFAFAFA),
    primaryColor: textColor,
    primaryColorLight: const Color(0xFFa3adb2),
    accentColor: const Color(0xffd32f2f),
    textTheme: textTheme,
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.grey),
      hintStyle: TextStyle(color: Colors.grey),
    ),
    appBarTheme: AppBarTheme(
      brightness: Brightness.light,
      color: Color(0xFFFAFAFA),
      textTheme: TextTheme(
        headline6: TextStyle(
            color: textColor, fontSize: 20, fontWeight: FontWeight.w500),
      ),
      iconTheme: IconThemeData(
        color: textColor,
      ),
    ),
  ),
  AppTheme.Black: ThemeData(
    backgroundColor: Colors.black,
    primaryColor: textColor,
    primaryColorLight: const Color(0xFFa3adb2),
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
        headline6: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
  ),
};
