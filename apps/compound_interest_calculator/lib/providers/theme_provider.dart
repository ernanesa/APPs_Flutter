import 'package:flutter_riverpod/legacy.dart';
import 'package:core_logic/core_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

enum AppThemeType {
  forest(Color(0xFF27AE60), Color(0xFF1E8449)),
  ocean(Color(0xFF3498DB), Color(0xFF2980B9)),
  sunset(Color(0xFFE67E22), Color(0xFFD35400));

  final Color primaryColor;
  final Color secondaryColor;
  const AppThemeType(this.primaryColor, this.secondaryColor);
}

class ThemeNotifier extends StateNotifier<AppThemeType> {
  final SharedPreferences _prefs;
  static const _key = 'compound_app_theme';

  ThemeNotifier(this._prefs) : super(AppThemeType.ocean) {
    _loadTheme();
  }

  void _loadTheme() {
    final themeName = _prefs.getString(_key);
    if (themeName != null) {
      state = AppThemeType.values.firstWhere(
        (e) => e.name == themeName,
        orElse: () => AppThemeType.ocean,
      );
    }
  }

  Future<void> setTheme(AppThemeType theme) async {
    await _prefs.setString(_key, theme.name);
    state = theme;
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeType>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});
