import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement.dart';
import '../models/pomodoro_session.dart';
import 'settings_provider.dart';
import 'streak_provider.dart';
import 'timer_provider.dart';

/// Provider for achievements state.
final achievementsProvider = StateNotifierProvider<AchievementsNotifier, List<Achievement>>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AchievementsNotifier(prefs, ref);
});

/// Provider for newly unlocked achievement (for notifications).
final newlyUnlockedAchievementProvider = StateProvider<Achievement?>((ref) => null);

/// Notifier for managing achievements.
class AchievementsNotifier extends StateNotifier<List<Achievement>> {
  final SharedPreferences _prefs;
  final Ref _ref;
  static const _key = 'achievements_unlocked';

  AchievementsNotifier(this._prefs, this._ref) : super(Achievements.all) {
    _loadUnlockedAchievements();
  }

  void _loadUnlockedAchievements() {
    final json = _prefs.getString(_key);
    if (json != null) {
      try {
        final Map<String, dynamic> data = jsonDecode(json);
        state = state.map((achievement) {
          if (data.containsKey(achievement.id)) {
            final unlockedData = data[achievement.id] as Map<String, dynamic>;
            return achievement.copyWith(
              isUnlocked: unlockedData['isUnlocked'] as bool,
              unlockedAt: unlockedData['unlockedAt'] != null
                  ? DateTime.parse(unlockedData['unlockedAt'] as String)
                  : null,
            );
          }
          return achievement;
        }).toList();
      } catch (_) {
        // Use defaults on error
      }
    }
  }

  Future<void> _saveUnlockedAchievements() async {
    final Map<String, dynamic> data = {};
    for (final achievement in state.where((a) => a.isUnlocked)) {
      data[achievement.id] = achievement.toJson();
    }
    await _prefs.setString(_key, jsonEncode(data));
  }

  /// Checks and unlocks achievements based on current progress.
  Future<void> checkAndUnlockAchievements({
    required int totalSessions,
    required int totalFocusMinutes,
    required int currentStreak,
    required int weekendSessions,
    required DateTime? sessionEndTime,
  }) async {
    final List<Achievement> newState = [];
    Achievement? newlyUnlocked;

    for (final achievement in state) {
      if (achievement.isUnlocked) {
        newState.add(achievement);
        continue;
      }

      bool shouldUnlock = false;

      switch (achievement.category) {
        case AchievementCategory.sessions:
          shouldUnlock = totalSessions >= achievement.targetValue;
          break;
        case AchievementCategory.streak:
          shouldUnlock = currentStreak >= achievement.targetValue;
          break;
        case AchievementCategory.time:
          shouldUnlock = totalFocusMinutes >= achievement.targetValue;
          break;
        case AchievementCategory.special:
          if (achievement.id == 'early_bird' && sessionEndTime != null) {
            shouldUnlock = sessionEndTime.hour < 7;
          } else if (achievement.id == 'night_owl' && sessionEndTime != null) {
            shouldUnlock = sessionEndTime.hour >= 22;
          } else if (achievement.id == 'weekend_warrior') {
            shouldUnlock = weekendSessions >= achievement.targetValue;
          }
          break;
      }

      if (shouldUnlock) {
        final unlockedAchievement = achievement.copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        );
        newState.add(unlockedAchievement);
        newlyUnlocked = unlockedAchievement;
      } else {
        newState.add(achievement);
      }
    }

    state = newState;
    await _saveUnlockedAchievements();

    // Notify about newly unlocked achievement
    if (newlyUnlocked != null) {
      _ref.read(newlyUnlockedAchievementProvider.notifier).state = newlyUnlocked;
    }
  }

  /// Called when a session is completed to check achievements.
  Future<void> onSessionCompleted(List<PomodoroSession> allSessions) async {
    final totalSessions = allSessions.where((s) => 
        s.type == SessionType.focus && s.wasCompleted).length;
    
    final totalFocusMinutes = allSessions
        .where((s) => s.type == SessionType.focus && s.wasCompleted)
        .fold<int>(0, (sum, s) => sum + s.durationMinutes);
    
    final streak = _ref.read(streakProvider);
    
    // Count weekend sessions
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekendSessions = allSessions.where((s) {
      final day = s.startTime.weekday;
      return s.startTime.isAfter(weekStart) && 
             (day == DateTime.saturday || day == DateTime.sunday) &&
             s.type == SessionType.focus && 
             s.wasCompleted;
    }).length;

    await checkAndUnlockAchievements(
      totalSessions: totalSessions,
      totalFocusMinutes: totalFocusMinutes,
      currentStreak: streak.currentStreak,
      weekendSessions: weekendSessions,
      sessionEndTime: allSessions.isNotEmpty ? allSessions.last.endTime : null,
    );
  }

  /// Gets unlocked achievements count.
  int get unlockedCount => state.where((a) => a.isUnlocked).length;

  /// Gets total achievements count.
  int get totalCount => state.length;
}
