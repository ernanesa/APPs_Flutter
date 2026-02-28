import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(Color seedColor, {ColorScheme? dynamicColorScheme}) {
    return ThemeData(
      colorScheme: dynamicColorScheme ?? ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static ThemeData darkTheme(Color seedColor, {ColorScheme? dynamicColorScheme}) {
    return ThemeData(
      colorScheme: dynamicColorScheme ?? ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
