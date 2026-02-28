import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/app_theme.dart';
import '../../domain/repositories/i_settings_repository.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  final SharedPreferences _prefs;

  static const String _themeKey = 'app_theme';
  static const String _protocolKey = 'selected_protocol';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _reminderHourKey = 'reminder_hour';

  SettingsRepositoryImpl(this._prefs);

  @override
  Future<ThemeMode> getTheme() async {
    final themeName = _prefs.getString(_themeKey);
    if (themeName == null) return ThemeMode.forest;

    try {
      return ThemeMode.values.firstWhere(
        (t) => t.name == themeName,
        orElse: () => ThemeMode.forest,
      );
    } catch (_) {
      return ThemeMode.forest;
    }
  }

  @override
  Future<void> setTheme(ThemeMode theme) async {
    await _prefs.setString(_themeKey, theme.name);
  }

  @override
  Future<String> getSelectedProtocolId() async {
    return _prefs.getString(_protocolKey) ?? '16_8';
  }

  @override
  Future<void> setSelectedProtocolId(String protocolId) async {
    await _prefs.setString(_protocolKey, protocolId);
  }

  @override
  Future<bool> getNotificationsEnabled() async {
    return _prefs.getBool(_notificationsKey) ?? true;
  }

  @override
  Future<void> setNotificationsEnabled(bool enabled) async {
    await _prefs.setBool(_notificationsKey, enabled);
  }

  @override
  Future<int> getReminderHour() async {
    return _prefs.getInt(_reminderHourKey) ?? 8;
  }

  @override
  Future<void> setReminderHour(int hour) async {
    await _prefs.setInt(_reminderHourKey, hour);
  }
}
