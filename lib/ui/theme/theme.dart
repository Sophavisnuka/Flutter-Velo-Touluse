// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color.fromRGBO(255, 87, 34, 1);
  static const Color secondary = Color.fromRGBO(76, 175, 80, 1);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color.fromARGB(255, 241, 241, 241);
  static const Color error = Color(0xFFB00020);
  static const Color black = Color.fromARGB(255, 0, 0, 0);
  static const Color transparent = Color.fromARGB(0, 0, 0, 0);

  static const String fontFamily = 'Poppins';

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface:surface,
        error:error,
        onPrimary:Colors.white,
        onSecondary:Colors.white,
        onSurface:Colors.black,
      ),
      scaffoldBackgroundColor: background,
    );
  }
}