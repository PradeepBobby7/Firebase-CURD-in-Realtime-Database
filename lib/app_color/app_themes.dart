import 'package:flutter/material.dart';

class Apptheme {
  static const Color primaryGreen = Color(0xFF00EF54);
  static const Color black = Color(0xFF000000);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: black,
    primaryColor: primaryGreen,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: black,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primaryGreen),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: black,
      foregroundColor: primaryGreen,
      titleTextStyle: TextStyle(color: primaryGreen,fontWeight: FontWeight.bold,fontSize: 20)
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70)
    )
  );
}
