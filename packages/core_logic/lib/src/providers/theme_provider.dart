import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:core_ui/core_ui.dart';
import 'shared_prefs_provider.dart';

class ThemeState {
  final ThemeMode mode;
  final Color seedColor;
  ThemeState({required this.mode, required this.seedColor});
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(() {
  return ThemeNotifier();
});

class ThemeNotifier extends Notifier<ThemeState> {
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  ThemeState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return ThemeState(
      mode: ThemeMode.values[prefs.getInt('theme_mode') ?? 0],
      seedColor: Color(prefs.getInt('theme_color') ?? Colors.deepPurple.value),
    );
  }

  void setThemeMode(ThemeMode mode) {
    _prefs.setInt('theme_mode', mode.index);
    state = ThemeState(mode: mode, seedColor: state.seedColor);
  }

  void setSeedColor(Color color) {
    _prefs.setInt('theme_color', color.value);
    state = ThemeState(mode: state.mode, seedColor: color);
  }
}

/// Advanced theme provider for apps that support custom themes with gradients.
final selectedThemeProvider =
    NotifierProvider<SelectedThemeNotifier, AppThemeModel>(() {
  return SelectedThemeNotifier();
});

class SelectedThemeNotifier extends Notifier<AppThemeModel> {
  static const _key = 'selected_theme_id';

  @override
  AppThemeModel build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final id = prefs.getString(_key) ?? AppThemes.tomato.id;
    return AppThemes.getById(id);
  }

  void selectTheme(AppThemeModel theme) {
    ref.read(sharedPreferencesProvider).setString(_key, theme.id);
    state = theme;
    
    // Also update the basic themeProvider's seed color for compatibility
    ref.read(themeProvider.notifier).setSeedColor(theme.primaryColor);
  }
}
