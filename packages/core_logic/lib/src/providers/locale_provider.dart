import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_prefs_provider.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences _prefs;
  LocaleNotifier(this._prefs) : super(Locale(
    _prefs.getString('app_locale') ?? 'en',
  ));

  void setLocale(String languageCode) {
    _prefs.setString('app_locale', languageCode);
    state = Locale(languageCode);
  }
}
