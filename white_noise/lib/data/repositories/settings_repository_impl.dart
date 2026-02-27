import '../../domain/entities/timer_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/timer_dto.dart';

/// Implementation of SettingsRepository using LocalDataSource
class SettingsRepositoryImpl implements SettingsRepository {
  final LocalDataSource _localDataSource;

  // Default values
  static const double _defaultVolume = 0.7;
  static const String _defaultLanguage = 'en';
  static const bool _defaultDarkMode = false;
  static const bool _defaultKeepScreenOn = false;

  SettingsRepositoryImpl({required LocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<TimerEntity> getTimerSettings() async {
    final json = await _localDataSource.getJson('timer_settings');

    if (json == null) {
      return const TimerEntity(
        duration: Duration(minutes: 30),
        isEnabled: false,
      );
    }

    final dto = TimerDto.fromJson(json);
    return dto.toEntity();
  }

  @override
  Future<void> saveTimerSettings(TimerEntity timer) async {
    final dto = TimerDto.fromEntity(timer);
    await _localDataSource.setJson('timer_settings', dto.toJson());
  }

  @override
  Future<double> getGlobalVolume() async {
    final json = await _localDataSource.getJson('app_settings');
    return (json?['globalVolume'] as num?)?.toDouble() ?? _defaultVolume;
  }

  @override
  Future<void> saveGlobalVolume(double volume) async {
    await _updateSettings({'globalVolume': volume.clamp(0.0, 1.0)});
  }

  @override
  Future<String> getLanguageCode() async {
    final json = await _localDataSource.getJson('app_settings');
    return (json?['languageCode'] as String?) ?? _defaultLanguage;
  }

  @override
  Future<void> saveLanguageCode(String languageCode) async {
    await _updateSettings({'languageCode': languageCode});
  }

  @override
  Future<bool> isDarkMode() async {
    final json = await _localDataSource.getJson('app_settings');
    return (json?['isDarkMode'] as bool?) ?? _defaultDarkMode;
  }

  @override
  Future<void> saveDarkMode(bool isDark) async {
    await _updateSettings({'isDarkMode': isDark});
  }

  @override
  Future<bool> isKeepScreenOn() async {
    final json = await _localDataSource.getJson('app_settings');
    return (json?['keepScreenOn'] as bool?) ?? _defaultKeepScreenOn;
  }

  @override
  Future<void> saveKeepScreenOn(bool keepOn) async {
    await _updateSettings({'keepScreenOn': keepOn});
  }

  @override
  Future<void> resetToDefaults() async {
    // Reset app settings
    await _localDataSource.setJson('app_settings', {
      'globalVolume': _defaultVolume,
      'languageCode': _defaultLanguage,
      'isDarkMode': _defaultDarkMode,
      'keepScreenOn': _defaultKeepScreenOn,
    });

    // Reset timer settings
    await saveTimerSettings(
      const TimerEntity(duration: Duration(minutes: 30), isEnabled: false),
    );
  }

  // Private helper
  Future<void> _updateSettings(Map<String, dynamic> updates) async {
    final json = await _localDataSource.getJson('app_settings') ?? {};
    json.addAll(updates);
    await _localDataSource.setJson('app_settings', json);
  }
}
