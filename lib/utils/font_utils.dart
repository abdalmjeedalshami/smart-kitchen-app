import 'package:flutter/material.dart';

class FontUtils {
  /// الخطوط البديلة في حالة فشل تحميل Google Fonts
  static const List<String> fallbackFonts = [
    'Roboto',
    '-apple-system',
    'BlinkMacSystemFont',
    'Segoe UI',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  /// الحصول على خط آمن
  static String getSafeFontFamily() {
    return fallbackFonts.join(', ');
  }

  /// إنشاء TextStyle آمن
  static TextStyle createSafeTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: getSafeFontFamily(),
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
    );
  }

  /// إنشاء ThemeData آمن
  static ThemeData createSafeTheme({Color? primaryColor, Color? accentColor}) {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: primaryColor,
      colorScheme: ColorScheme.fromSeed(seedColor: primaryColor ?? Colors.blue),
      fontFamily: getSafeFontFamily(),
      textTheme: TextTheme(
        displayLarge: createSafeTextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: createSafeTextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: createSafeTextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        headlineLarge: createSafeTextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: createSafeTextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: createSafeTextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: createSafeTextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: createSafeTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: createSafeTextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: createSafeTextStyle(fontSize: 16),
        bodyMedium: createSafeTextStyle(fontSize: 14),
        bodySmall: createSafeTextStyle(fontSize: 12),
        labelLarge: createSafeTextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        labelMedium: createSafeTextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: createSafeTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
