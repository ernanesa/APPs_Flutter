import 'package:flutter/material.dart';

/// Represents a color theme for the app.
class AppTheme {
  final String id;
  final String nameKey; // i18n key
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;

  const AppTheme({
    required this.id,
    required this.nameKey,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
  });

  /// Creates a ColorScheme for light mode.
  ColorScheme get lightColorScheme => ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,
  );

  /// Creates a ColorScheme for dark mode.
  ColorScheme get darkColorScheme => ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,
  );
}

/// Predefined app themes.
class AppThemes {
  static const tomato = AppTheme(
    id: 'tomato',
    nameKey: 'themeTomato',
    primaryColor: Color(0xFFE53935), // Red
    secondaryColor: Color(0xFFFF5722),
    accentColor: Color(0xFFFF8A65),
  );

  static const ocean = AppTheme(
    id: 'ocean',
    nameKey: 'themeOcean',
    primaryColor: Color(0xFF1976D2), // Blue
    secondaryColor: Color(0xFF0288D1),
    accentColor: Color(0xFF4FC3F7),
  );

  static const forest = AppTheme(
    id: 'forest',
    nameKey: 'themeForest',
    primaryColor: Color(0xFF388E3C), // Green
    secondaryColor: Color(0xFF43A047),
    accentColor: Color(0xFF81C784),
  );

  static const lavender = AppTheme(
    id: 'lavender',
    nameKey: 'themeLavender',
    primaryColor: Color(0xFF7B1FA2), // Purple
    secondaryColor: Color(0xFF9C27B0),
    accentColor: Color(0xFFBA68C8),
  );

  static const sunset = AppTheme(
    id: 'sunset',
    nameKey: 'themeSunset',
    primaryColor: Color(0xFFF57C00), // Orange
    secondaryColor: Color(0xFFFF9800),
    accentColor: Color(0xFFFFB74D),
  );

  static const midnight = AppTheme(
    id: 'midnight',
    nameKey: 'themeMidnight',
    primaryColor: Color(0xFF303F9F), // Indigo
    secondaryColor: Color(0xFF3F51B5),
    accentColor: Color(0xFF7986CB),
  );

  static const rose = AppTheme(
    id: 'rose',
    nameKey: 'themeRose',
    primaryColor: Color(0xFFC2185B), // Pink
    secondaryColor: Color(0xFFE91E63),
    accentColor: Color(0xFFF48FB1),
  );

  static const mint = AppTheme(
    id: 'mint',
    nameKey: 'themeMint',
    primaryColor: Color(0xFF00897B), // Teal
    secondaryColor: Color(0xFF009688),
    accentColor: Color(0xFF80CBC4),
  );

  static List<AppTheme> get all => [
    tomato,
    ocean,
    forest,
    lavender,
    sunset,
    midnight,
    rose,
    mint,
  ];

  static AppTheme getById(String id) {
    return all.firstWhere(
      (theme) => theme.id == id,
      orElse: () => tomato,
    );
  }
}
