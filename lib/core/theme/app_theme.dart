import 'package:flutter/material.dart';
import 'package:go/core/constants/color_manager.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: ColorManager.navyPrimary,
      secondary: ColorManager.greenAccent,
      surface: ColorManager.backgroundWhite,
      onPrimary: ColorManager.textLight,
      onSecondary: ColorManager.textPrimary,
    ),
    scaffoldBackgroundColor: ColorManager.backgroundLight,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorManager.backgroundWhite,
      elevation: 0,
      iconTheme: IconThemeData(color: ColorManager.textPrimary),
      titleTextStyle: TextStyle(
        color: ColorManager.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.navyPrimary,
        foregroundColor: ColorManager.textLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.backgroundGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ColorManager.gray200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ColorManager.greenAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ColorManager.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    cardTheme: CardThemeData(
      color: ColorManager.backgroundWhite,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: ColorManager.greenAccent,
      secondary: ColorManager.navyLight,
      surface: ColorManager.backgroundNavy,
      onPrimary: ColorManager.textPrimary,
      onSecondary: ColorManager.textLight,
    ),
    scaffoldBackgroundColor: ColorManager.backgroundDark,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorManager.backgroundDark,
      elevation: 0,
      iconTheme: IconThemeData(color: ColorManager.textLight),
      titleTextStyle: TextStyle(
        color: ColorManager.textLight,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.greenAccent,
        foregroundColor: ColorManager.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ColorManager.backgroundNavy,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ColorManager.gray500),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ColorManager.greenAccent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: ColorManager.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    cardTheme: CardThemeData(
      color: ColorManager.darkCard,
      elevation: 4,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}
