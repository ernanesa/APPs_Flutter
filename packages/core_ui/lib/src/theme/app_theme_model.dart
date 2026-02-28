import 'package:flutter/material.dart';

/// Model representing an application theme.
class AppThemeModel {
  final String id;
  final String nameKey;
  final Color primaryColor;
  final Color secondaryColor;

  const AppThemeModel({
    required this.id,
    required this.nameKey,
    required this.primaryColor,
    required this.secondaryColor,
  });
}

/// Collection of default application themes.
class AppThemes {
  static const tomato = AppThemeModel(
    id: 'tomato',
    nameKey: 'themeTomato',
    primaryColor: Color(0xFFFF5252),
    secondaryColor: Color(0xFFFF8A80),
  );

  static const ocean = AppThemeModel(
    id: 'ocean',
    nameKey: 'themeOcean',
    primaryColor: Color(0xFF2196F3),
    secondaryColor: Color(0xFF64B5F6),
  );

  static const forest = AppThemeModel(
    id: 'forest',
    nameKey: 'themeForest',
    primaryColor: Color(0xFF4CAF50),
    secondaryColor: Color(0xFF81C784),
  );

  static const lavender = AppThemeModel(
    id: 'lavender',
    nameKey: 'themeLavender',
    primaryColor: Color(0xFF9C27B0),
    secondaryColor: Color(0xFFBA68C8),
  );

  static const sunset = AppThemeModel(
    id: 'sunset',
    nameKey: 'themeSunset',
    primaryColor: Color(0xFFFF9800),
    secondaryColor: Color(0xFFFFB74D),
  );

  static const midnight = AppThemeModel(
    id: 'midnight',
    nameKey: 'themeMidnight',
    primaryColor: Color(0xFF263238),
    secondaryColor: Color(0xFF455A64),
  );

  static const rose = AppThemeModel(
    id: 'rose',
    nameKey: 'themeRose',
    primaryColor: Color(0xFFE91E63),
    secondaryColor: Color(0xFFF06292),
  );

  static const mint = AppThemeModel(
    id: 'mint',
    nameKey: 'themeMint',
    primaryColor: Color(0xFF00BFA5),
    secondaryColor: Color(0xFF1DE9B6),
  );

  static const List<AppThemeModel> all = [
    tomato,
    ocean,
    forest,
    lavender,
    sunset,
    midnight,
    rose,
    mint,
  ];

  static AppThemeModel getById(String id) {
    return all.firstWhere((t) => t.id == id, orElse: () => tomato);
  }
}
