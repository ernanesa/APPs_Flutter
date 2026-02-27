import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_theme.dart';
import 'settings_provider.dart';

/// Provider for the currently selected theme.
final selectedThemeProvider = StateNotifierProvider<ThemeNotifier, AppTheme>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});

/// Provider for the computed ThemeData (light mode).
final lightThemeDataProvider = Provider<ThemeData>((ref) {
  final selectedTheme = ref.watch(selectedThemeProvider);
  return ThemeData(
    useMaterial3: true,
    colorScheme: selectedTheme.lightColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: selectedTheme.primaryColor,
      foregroundColor: Colors.white,
    ),
  );
});

/// Provider for the computed ThemeData (dark mode).
final darkThemeDataProvider = Provider<ThemeData>((ref) {
  final selectedTheme = ref.watch(selectedThemeProvider);
  return ThemeData(
    useMaterial3: true,
    colorScheme: selectedTheme.darkColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: selectedTheme.darkColorScheme.surface,
      foregroundColor: selectedTheme.darkColorScheme.onSurface,
    ),
  );
});

/// Notifier for managing theme selection.
class ThemeNotifier extends StateNotifier<AppTheme> {
  final SharedPreferences _prefs;
  static const _key = 'selected_theme';

  ThemeNotifier(this._prefs) : super(AppThemes.tomato) {
    _loadSelectedTheme();
  }

  void _loadSelectedTheme() {
    final themeId = _prefs.getString(_key);
    if (themeId != null) {
      state = AppThemes.getById(themeId);
    }
  }

  Future<void> selectTheme(AppTheme theme) async {
    state = theme;
    await _prefs.setString(_key, theme.id);
  }
}
