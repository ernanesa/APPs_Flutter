import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_prefs_provider.dart';

class SettingsState {
  final bool hapticEnabled;
  final bool notificationsEnabled;
  final bool useImperialUnits; // Metric (kg/cm) vs Imperial (lbs/in)
  final bool enableGamification; // Toggle for badges and streaks

  SettingsState({
    this.hapticEnabled = true,
    this.notificationsEnabled = true,
    this.useImperialUnits = false,
    this.enableGamification = true,
  });

  SettingsState copyWith({
    bool? hapticEnabled,
    bool? notificationsEnabled,
    bool? useImperialUnits,
    bool? enableGamification,
  }) {
    return SettingsState(
      hapticEnabled: hapticEnabled ?? this.hapticEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      useImperialUnits: useImperialUnits ?? this.useImperialUnits,
      enableGamification: enableGamification ?? this.enableGamification,
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
      useImperialUnits: prefs.getBool('use_imperial_units') ?? false,
      enableGamification: prefs.getBool('enable_gamification') ?? true,
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

  Future<void> setUseImperialUnits(bool enabled) async {
    await _prefs.setBool('use_imperial_units', enabled);
    state = state.copyWith(useImperialUnits: enabled);
  }

  Future<void> setEnableGamification(bool enabled) async {
    await _prefs.setBool('enable_gamification', enabled);
    state = state.copyWith(enableGamification: enabled);
  }
}
