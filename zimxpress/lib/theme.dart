import 'package:flutter/material.dart';

final appTheme = ThemeData(
  primaryColor: const Color(0xFFF97316),
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFFFB923C)),
  scaffoldBackgroundColor: const Color(0xFFF0F0F0),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
    bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF333333)),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFF97316),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFF97316)),
    ),
  ),
);
