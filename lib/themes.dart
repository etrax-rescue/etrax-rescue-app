import 'package:flutter/material.dart';
import 'dart:io' show Platform;

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

class AppThemeData {
  static final DarkStatusBar = ThemeData(
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
  );

  static final LightStatusBar = ThemeData(
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
      // On Android the status bar has a semi-transparent background,
      // which darkens the scaffold color. In my opinion it looks nicer when we
      // use the white icons instead of the dark ones (provided by Brighness.light)
      brightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
      color: Color(0xFFFAFAFA),
      textTheme: TextTheme(
        headline6: TextStyle(
            color: textColor, fontSize: 20, fontWeight: FontWeight.w500),
      ),
      iconTheme: IconThemeData(
        color: textColor,
      ),
    ),
  );
  static final Black = ThemeData(
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
      brightness: Brightness.dark,
      color: Color.fromARGB(128, 0, 0, 0),
      textTheme: TextTheme(
        headline6: TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
  );
}
