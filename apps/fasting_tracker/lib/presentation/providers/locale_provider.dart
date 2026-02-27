import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:core_logic/core_logic.dart';

/// Locale notifier to manage app language
class LocaleNotifier extends StateNotifier<Locale?> {
  final Ref _ref;
  static const _key = 'app_locale';

  LocaleNotifier(this._ref) : super(null) {
    _loadLocale();
  }

  void _loadLocale() {
    final prefs = _ref.read(sharedPreferencesProvider);
    final languageCode = prefs.getString(_key);
    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = _ref.read(sharedPreferencesProvider);
    if (locale == null) {
      await prefs.remove(_key);
    } else {
      await prefs.setString(_key, locale.languageCode);
    }
    state = locale;
  }
}

/// Provider for app locale
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier(ref);
});
