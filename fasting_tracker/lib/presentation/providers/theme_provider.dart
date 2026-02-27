import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/app_theme.dart';
import '../../data/repositories/settings_repository_impl.dart';
import 'shared_prefs_provider.dart';

/// Theme notifier
class ThemeNotifier extends StateNotifier<AppThemeType> {
  final SettingsRepositoryImpl _repository;

  ThemeNotifier(this._repository) : super(AppThemeType.forest) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final theme = await _repository.getTheme();
    state = theme;
  }

  Future<void> setTheme(AppThemeType theme) async {
    await _repository.setTheme(theme);
    state = theme;
  }
}

/// Theme provider
final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeType>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(SettingsRepositoryImpl(prefs));
});
