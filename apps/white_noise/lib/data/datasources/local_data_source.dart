import 'dart:isolate';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source using SharedPreferences for persistent storage
/// Provides type-safe wrappers for all storage operations
class LocalDataSource {
  final SharedPreferences _prefs;

  LocalDataSource(this._prefs);

  // ===== STRING OPERATIONS =====

  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  // ===== INT OPERATIONS =====

  Future<int?> getInt(String key) async {
    return _prefs.getInt(key);
  }

  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  // ===== DOUBLE OPERATIONS =====

  Future<double?> getDouble(String key) async {
    return _prefs.getDouble(key);
  }

  Future<bool> setDouble(String key, double value) async {
    return await _prefs.setDouble(key, value);
  }

  // ===== BOOL OPERATIONS =====

  Future<bool?> getBool(String key) async {
    return _prefs.getBool(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  // ===== JSON OPERATIONS =====

  Future<Map<String, dynamic>?> getJson(String key) async {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;

    try {
      return await Isolate.run(() => json.decode(jsonString)) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = json.encode(value);
      return await _prefs.setString(key, jsonString);
    } catch (e) {
      return false;
    }
  }

  // ===== STRING LIST OPERATIONS =====

  Future<List<String>?> getStringList(String key) async {
    return _prefs.getStringList(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  // ===== UTILITY OPERATIONS =====

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs.clear();
  }

  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  Set<String> getKeys() {
    return _prefs.getKeys();
  }

  // ===== STORAGE KEYS CONSTANTS =====

  static const String keyCurrentMix = 'current_mix';
  static const String keyFavoriteSounds = 'favorite_sounds';
  static const String keyGlobalVolume = 'global_volume';
  static const String keySoundVolumes = 'sound_volumes';
  static const String keyThemeMode = 'theme_mode';
  static const String keyLanguage = 'language';
  static const String keyAchievements = 'achievements';
  static const String keyLastActivityDate = 'last_activity_date';
  static const String keyCurrentStreak = 'current_streak';
  static const String keyBestStreak = 'best_streak';
  static const String keyTotalSessions = 'total_sessions';
  static const String keyTotalPlayTime = 'total_play_time';
  static const String keyThreeSoundMixes = 'three_sound_mixes';
  static const String keyShowOnboarding = 'show_onboarding';
}
