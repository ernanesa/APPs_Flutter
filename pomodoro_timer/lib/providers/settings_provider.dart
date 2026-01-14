import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pomodoro_settings.dart';

/// Provider for SharedPreferences instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be initialized');
});

/// Provider for Pomodoro settings.
final settingsProvider =
    StateNotifierProvider<SettingsNotifier, PomodoroSettings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsNotifier(prefs);
});

/// Notifier for managing Pomodoro settings.
class SettingsNotifier extends StateNotifier<PomodoroSettings> {
  final SharedPreferences _prefs;
  static const _key = 'pomodoro_settings';

  SettingsNotifier(this._prefs) : super(const PomodoroSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    final json = _prefs.getString(_key);
    if (json != null) {
      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        state = PomodoroSettings.fromJson(map);
      } catch (_) {
        // Use default settings on error
      }
    }
  }

  Future<void> _saveSettings() async {
    await _prefs.setString(_key, jsonEncode(state.toJson()));
  }

  void updateFocusDuration(int minutes) {
    state = state.copyWith(focusDurationMinutes: minutes);
    _saveSettings();
  }

  void updateShortBreakDuration(int minutes) {
    state = state.copyWith(shortBreakMinutes: minutes);
    _saveSettings();
  }

  void updateLongBreakDuration(int minutes) {
    state = state.copyWith(longBreakMinutes: minutes);
    _saveSettings();
  }

  void updateSessionsUntilLongBreak(int sessions) {
    state = state.copyWith(sessionsUntilLongBreak: sessions);
    _saveSettings();
  }

  void toggleSound() {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
    _saveSettings();
  }

  void toggleVibration() {
    state = state.copyWith(vibrationEnabled: !state.vibrationEnabled);
    _saveSettings();
  }

  void toggleAutoStartBreaks() {
    state = state.copyWith(autoStartBreaks: !state.autoStartBreaks);
    _saveSettings();
  }

  void toggleAutoStartFocus() {
    state = state.copyWith(autoStartFocus: !state.autoStartFocus);
    _saveSettings();
  }

  void toggleNotifications() {
    state = state.copyWith(notificationsEnabled: !state.notificationsEnabled);
    _saveSettings();
  }

  void toggleDarkMode() {
    state = state.copyWith(darkMode: !state.darkMode);
    _saveSettings();
  }

  void toggleColorfulMode() {
    state = state.copyWith(colorfulMode: !state.colorfulMode);
    _saveSettings();
  }
}
