import '../entities/app_theme.dart';

/// Repository interface for settings
abstract class ISettingsRepository {
  /// Get selected theme
  Future<ThemeMode> getTheme();

  /// Set theme
  Future<void> setTheme(ThemeMode theme);

  /// Get selected protocol ID
  Future<String> getSelectedProtocolId();

  /// Set selected protocol ID
  Future<void> setSelectedProtocolId(String protocolId);

  /// Get notification enabled status
  Future<bool> getNotificationsEnabled();

  /// Set notification enabled status
  Future<void> setNotificationsEnabled(bool enabled);

  /// Get reminder time (hour of day)
  Future<int> getReminderHour();

  /// Set reminder time
  Future<void> setReminderHour(int hour);
}
