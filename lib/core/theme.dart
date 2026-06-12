import 'package:flutter/material.dart';

class AppTheme {
  static const Color forestGreen = Color(0xFF2D6A4F);
  static const Color lightGreen = Color(0xFF52B788);
  static const Color softWhite = Color(0xFFF8F9FA);
  static const Color earthBrown = Color(0xFF8B5E3C);
  static const Color warmBeige = Color(0xFFF0E6D3);
  static const Color darkText = Color(0xFF1A1A2E);
  static const Color greyText = Color(0xFF6C757D);
  static const Color cardBg = Color(0xFFFFFFFF);

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: forestGreen,
          primary: forestGreen,
          secondary: lightGreen,
          background: softWhite,
          surface: cardBg,
        ),
        scaffoldBackgroundColor: softWhite,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: softWhite,
          elevation: 0,
          centerTitle: false,
          iconTheme: IconThemeData(color: darkText),
          titleTextStyle: TextStyle(
            color: darkText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: forestGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: cardBg,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFDEE2E6)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: forestGreen, width: 2),
          ),
        ),
      );
}
