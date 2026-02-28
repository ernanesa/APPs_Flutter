import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_prefs_provider.dart';

class SettingsState {
  final bool hapticEnabled;
  final bool notificationsEnabled;

  SettingsState({
    this.hapticEnabled = true,
    this.notificationsEnabled = true,
  });

  SettingsState copyWith({
    bool? hapticEnabled,
    bool? notificationsEnabled,
  }) {
    return SettingsState(
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(() {
  return SettingsNotifier();
});

class SettingsNotifier extends Notifier<SettingsState> {
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  SettingsState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return SettingsState(
      hapticEnabled: prefs.getBool('haptic_enabled') ?? true,
      notificationsEnabled: prefs.getBool('notifications_enabled') ?? true,
    );
  }

  Future<void> setHapticEnabled(bool enabled) async {
    await _prefs.setBool('haptic_enabled', enabled);
    state = state.copyWith(hapticEnabled: enabled);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool('notifications_enabled', enabled);
    state = state.copyWith(notificationsEnabled: enabled);
  }
}
