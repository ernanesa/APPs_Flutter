import 'package:core_logic/core_logic.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pomodoro_settings.dart';

/// Provider for Pomodoro settings (Notifier API 2026).
final pomodoroSettingsProvider =
    NotifierProvider<PomodoroSettingsNotifier, PomodoroSettings>(() {
  return PomodoroSettingsNotifier();
});

/// Notifier for managing Pomodoro settings.
class PomodoroSettingsNotifier extends Notifier<PomodoroSettings> {
  static const _key = 'pomodoro_settings';

  @override
  PomodoroSettings build() {
    _loadSettings();
    return const PomodoroSettings();
  }

  void _loadSettings() {
    final prefs = ref.read(sharedPreferencesProvider);
    final json = prefs.getString(_key);
    if (json != null) {
      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        state = PomodoroSettings.fromJson(map);
      } catch (_) {
        // Use default settings
      }
    }
  }

  Future<void> _saveSettings() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, jsonEncode(state.toJson()));
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
