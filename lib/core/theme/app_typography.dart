import 'package:flutter/material.dart';

/// Escala tipográfica de Aura POS, alineada a Material 3 type scale.
abstract class AppTypography {
  AppTypography._();

  static TextTheme textTheme(Color baseColor) {
    return TextTheme(
      displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w400, color: baseColor, letterSpacing: -0.25),
      displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w400, color: baseColor),
      displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, color: baseColor),
      headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: baseColor),
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: baseColor),
      headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: baseColor),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: baseColor),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: baseColor, letterSpacing: 0.15),
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: baseColor, letterSpacing: 0.1),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: baseColor, letterSpacing: 0.5),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: baseColor, letterSpacing: 0.25),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: baseColor, letterSpacing: 0.4),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: baseColor, letterSpacing: 0.1),
      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: baseColor, letterSpacing: 0.5),
      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: baseColor, letterSpacing: 0.5),
    );
  }
}
