import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_prefs_provider.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});

class ThemeState {
  final ThemeMode mode;
  final Color seedColor;
  ThemeState({required this.mode, required this.seedColor});
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  final SharedPreferences _prefs;
  ThemeNotifier(this._prefs) : super(ThemeState(
    mode: ThemeMode.values[_prefs.getInt('theme_mode') ?? 0],
    seedColor: Color(_prefs.getInt('theme_color') ?? Colors.deepPurple.value),
  ));

  void setThemeMode(ThemeMode mode) {
    _prefs.setInt('theme_mode', mode.index);
    state = ThemeState(mode: mode, seedColor: state.seedColor);
  }

  void setSeedColor(Color color) {
    _prefs.setInt('theme_color', color.value);
    state = ThemeState(mode: state.mode, seedColor: color);
  }
}
