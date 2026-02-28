import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_prefs_provider.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale> {
  static const _key = 'selected_locale';

  /// Standard mapping of supported locales for our apps.
  static const Map<String, String> supportedLocales = {
    'en': 'English',
    'zh': 'Chinese',
    'hi': 'Hindi',
    'es': 'Spanish',
    'fr': 'French',
    'ar': 'Arabic',
    'bn': 'Bengali',
    'ru': 'Russian',
    'pt': 'Portuguese',
    'ja': 'Japanese',
    'de': 'German',
  };

  @override
  Locale build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final code = prefs.getString(_key) ?? 'en';
    return Locale(code);
  }

  void setLocale(String? code) {
    if (code != null && supportedLocales.containsKey(code)) {
      ref.read(sharedPreferencesProvider).setString(_key, code);
      state = Locale(code);
    }
  }
}
