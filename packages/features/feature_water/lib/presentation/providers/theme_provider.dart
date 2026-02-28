import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/app_theme.dart';
import 'package:core_logic/core_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<AppThemeType> {
  final SharedPreferences _prefs;
  static const _key = 'water_app_theme';

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
