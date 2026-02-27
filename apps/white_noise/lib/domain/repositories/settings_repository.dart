import '../entities/timer_entity.dart';

/// Abstract repository for app settings
abstract class SettingsRepository {
  /// Get timer settings
  Future<TimerEntity> getTimerSettings();

  /// Save timer settings
  Future<void> saveTimerSettings(TimerEntity timer);

  /// Get global volume (0.0 to 1.0)
  Future<double> getGlobalVolume();

  /// Save global volume
  Future<void> saveGlobalVolume(double volume);

  /// Get language code
  Future<String> getLanguageCode();

  /// Save language code
  Future<void> saveLanguageCode(String languageCode);

  /// Get dark mode preference
  Future<bool> isDarkMode();

  /// Save dark mode preference
  Future<void> saveDarkMode(bool isDark);

  /// Get keep screen on preference
  Future<bool> isKeepScreenOn();

  /// Save keep screen on preference
  Future<void> saveKeepScreenOn(bool keepOn);

  /// Reset all settings to defaults
  Future<void> resetToDefaults();
}
