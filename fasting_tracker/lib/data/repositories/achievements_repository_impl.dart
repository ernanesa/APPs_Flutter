import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/achievement.dart';
import '../../domain/repositories/i_achievements_repository.dart';

class AchievementsRepositoryImpl implements IAchievementsRepository {
  final SharedPreferences _prefs;

  static const String _achievementsKey = 'achievements_status';
  static const String _unlockDatesKey = 'achievements_dates';

  AchievementsRepositoryImpl(this._prefs);

  @override
  Future<List<Achievement>> getAchievements() async {
    final statusJson = _prefs.getString(_achievementsKey);
    final datesJson = _prefs.getString(_unlockDatesKey);

    Map<String, bool> unlockStatus = {};
    Map<String, DateTime> unlockDates = {};

    if (statusJson != null && statusJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(statusJson) as Map<String, dynamic>;
        unlockStatus = decoded.map((k, v) => MapEntry(k, v as bool));
      } catch (_) {}
    }

    if (datesJson != null && datesJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(datesJson) as Map<String, dynamic>;
        unlockDates = decoded.map(
          (k, v) => MapEntry(k, DateTime.parse(v as String)),
        );
      } catch (_) {}
    }

    return Achievement.defaultAchievements.map((achievement) {
      return achievement.copyWith(
        isUnlocked: unlockStatus[achievement.id] ?? false,
        unlockedAt: unlockDates[achievement.id],
      );
    }).toList();
  }

  @override
  Future<Achievement> unlockAchievement(String achievementId) async {
    final statusJson = _prefs.getString(_achievementsKey);
    final datesJson = _prefs.getString(_unlockDatesKey);

    Map<String, bool> unlockStatus = {};
    Map<String, String> unlockDates = {};

    if (statusJson != null && statusJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(statusJson) as Map<String, dynamic>;
        unlockStatus = decoded.map((k, v) => MapEntry(k, v as bool));
      } catch (_) {}
    }

    if (datesJson != null && datesJson.isNotEmpty) {
      try {
        final decoded = jsonDecode(datesJson) as Map<String, dynamic>;
        unlockDates = decoded.map((k, v) => MapEntry(k, v as String));
      } catch (_) {}
    }

    final now = DateTime.now();
    unlockStatus[achievementId] = true;
    unlockDates[achievementId] = now.toIso8601String();

    await _prefs.setString(_achievementsKey, jsonEncode(unlockStatus));
    await _prefs.setString(_unlockDatesKey, jsonEncode(unlockDates));

    final achievement = Achievement.defaultAchievements.firstWhere(
      (a) => a.id == achievementId,
    );

    return achievement.copyWith(isUnlocked: true, unlockedAt: now);
  }

  @override
  Future<List<Achievement>> checkAndUnlock({
    required int totalFasts,
    required int currentStreak,
    required int totalHours,
    required double longestFastHours,
  }) async {
    final achievements = await getAchievements();
    final newlyUnlocked = <Achievement>[];

    for (final achievement in achievements) {
      if (achievement.isUnlocked) continue;

      bool shouldUnlock = false;

      switch (achievement.category) {
        case AchievementCategory.sessions:
          shouldUnlock = totalFasts >= achievement.requirement;
          break;
        case AchievementCategory.streak:
          shouldUnlock = currentStreak >= achievement.requirement;
          break;
        case AchievementCategory.time:
          shouldUnlock = totalHours >= achievement.requirement;
          break;
        case AchievementCategory.special:
          // Special achievements based on longest single fast
          if (achievement.id == 'ketosis_reached') {
            shouldUnlock = longestFastHours >= 18;
          } else if (achievement.id == 'autophagy_reached') {
            shouldUnlock = longestFastHours >= 48;
          }
          break;
      }

      if (shouldUnlock) {
        final unlocked = await unlockAchievement(achievement.id);
        newlyUnlocked.add(unlocked);
      }
    }

    return newlyUnlocked;
  }

  @override
  Future<void> resetAchievements() async {
    await _prefs.remove(_achievementsKey);
    await _prefs.remove(_unlockDatesKey);
  }
}
