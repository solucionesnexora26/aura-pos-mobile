import 'package:flutter/material.dart';

/// Paleta de marca de Aura POS. Sirve como semilla para los ColorScheme
/// de Material 3 (claro y oscuro), generados dinámicamente en [AppTheme].
abstract class AppColors {
  AppColors._();

  // Color semilla de marca (violeta-azulado "Aura")
  static const Color seed = Color(0xFF5B5FEF);

  // Acentos funcionales
  static const Color success = Color(0xFF1FAE6B);
  static const Color warning = Color(0xFFF2A93B);
  static const Color danger = Color(0xFFE0524B);
  static const Color info = Color(0xFF3B9CF2);

  // Neutrales de superficie personalizados
  static const Color surfaceLight = Color(0xFFFBFAFF);
  static const Color surfaceDark = Color(0xFF121218);

  // Colores de estado de venta
  static const Color openTicket = Color(0xFFF2A93B);
  static const Color paidTicket = Color(0xFF1FAE6B);
  static const Color cancelledTicket = Color(0xFFE0524B);
}
