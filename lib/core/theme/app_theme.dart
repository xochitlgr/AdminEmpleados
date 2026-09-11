import 'package:flutter/material.dart';

/// Tema compartido de la aplicación (Constitución VI: Material 3).
class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2E7D32)),
      );
}