import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color.fromARGB(255, 2, 10, 249);
  // static const Color primary = Colors.blue;
  static const Color background = Color(0xFFF5F5F5);
  static const Color accent = Color(0xFF29ADB2);
  static const Color cardColor = Colors.white;
  // A dark grey/black for the striped background texture simulation
  static const Color stripedColor = Color(0xFFD4D4D4);
  // static const Color cardColor = Colors.white;
  // A dark grey/black for the striped background texture simulation
  // static const Color stripedColor = Color(0xFFD4D4D4);
  static const Color sectionTitleColor = Color(
    0xFF5A5A5A,
  ); // Darker grey for section titles
  static const Color textColorPrimary = Color(0xFF333333); // Dark text color
  static const Color textColorSecondary = Color(
    0xFF666666,
  ); // Lighter text colo
  static const Color success = Color(0xFF4CAF50); // A strong green
  static const Color error = Color(0xFFF44336); // A strong red
}

ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.accent,
    background: AppColors.background,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: Colors.black87),
    bodyMedium: TextStyle(color: Colors.black54),
  ),
);
