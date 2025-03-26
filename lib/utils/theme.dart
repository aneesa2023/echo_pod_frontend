import 'package:flutter/material.dart';

const Color kMainColor = Color(0xFF7B2CBF);

final ThemeData echoPodTheme = ThemeData(
  scaffoldBackgroundColor: Color(0xFFF6F0FA),
  primaryColor: kMainColor,
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: kMainColor,
    secondary: kMainColor,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: kMainColor.withOpacity(0.7),
    centerTitle: true,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: kMainColor,
      foregroundColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
);
