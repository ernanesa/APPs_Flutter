import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider for managing app locale/language.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  return LocaleNotifier();
});

/// Notifier for locale state management.
class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier() : super(null) {
    _loadLocale();
  }

  static const String _kLocaleKey = 'selected_locale';

  /// Supported locales with their display names.
  static const Map<String, String> supportedLocales = {
    'en': 'English',
    'zh': '中文 (Chinese)',
    'hi': 'हिन्दी (Hindi)',
    'es': 'Español',
    'fr': 'Français',
    'ar': 'العربية (Arabic)',
    'bn': 'বাংলা (Bengali)',
    'ru': 'Русский (Russian)',
    'pt': 'Português',
    'ja': '日本語 (Japanese)',
    'de': 'Deutsch',
  };

  /// Load locale from SharedPreferences.
  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String? languageCode = prefs.getString(_kLocaleKey);
    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }

  /// Set and persist locale.
  Future<void> setLocale(String languageCode) async {
    state = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLocaleKey, languageCode);
  }

  /// Get display name for a language code.
  static String getDisplayName(String code) {
    return supportedLocales[code] ?? code;
  }
}
