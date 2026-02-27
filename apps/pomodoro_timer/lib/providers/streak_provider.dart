import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/streak_data.dart';
import 'settings_provider.dart';

/// Provider for streak data.
final streakProvider = StateNotifierProvider<StreakNotifier, StreakData>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StreakNotifier(prefs);
});

/// Notifier for managing streak data.
class StreakNotifier extends StateNotifier<StreakData> {
  final SharedPreferences _prefs;
  static const _key = 'streak_data';

  StreakNotifier(this._prefs) : super(const StreakData()) {
    _loadStreak();
  }

  void _loadStreak() {
    final json = _prefs.getString(_key);
    if (json != null) {
      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        state = StreakData.fromJson(map);
        _checkAndUpdateStreak();
      } catch (_) {
        // Use default on error
      }
    }
  }

  Future<void> _saveStreak() async {
    await _prefs.setString(_key, jsonEncode(state.toJson()));
  }

  /// Called when a focus session is completed.
  void recordFocusSessionCompleted() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // If already recorded today, don't update streak
    if (state.wasActiveToday) {
      return;
    }

    final int newStreak;
    final newTotalDays = state.totalDaysActive + 1;

    if (state.lastActiveDate == null) {
      // First ever session
      newStreak = 1;
    } else {
      final lastActive = DateTime(
        state.lastActiveDate!.year,
        state.lastActiveDate!.month,
        state.lastActiveDate!.day,
      );
      final daysSinceLastActive = today.difference(lastActive).inDays;

      if (daysSinceLastActive == 1) {
        // Consecutive day - increment streak
        newStreak = state.currentStreak + 1;
      } else if (daysSinceLastActive == 0) {
        // Same day - keep streak
        newStreak = state.currentStreak;
      } else {
        // Streak broken - reset to 1
        newStreak = 1;
      }
    }

    final newBestStreak = newStreak > state.bestStreak
        ? newStreak
        : state.bestStreak;

    state = state.copyWith(
      currentStreak: newStreak,
      bestStreak: newBestStreak,
      lastActiveDate: now,
      totalDaysActive: newTotalDays,
    );

    _saveStreak();
  }

  /// Checks if streak needs to be reset (called on app open).
  void _checkAndUpdateStreak() {
    if (state.lastActiveDate == null) return;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActive = DateTime(
      state.lastActiveDate!.year,
      state.lastActiveDate!.month,
      state.lastActiveDate!.day,
    );
    final daysSinceLastActive = today.difference(lastActive).inDays;

    // If more than 1 day has passed, streak is broken
    if (daysSinceLastActive > 1) {
      state = state.copyWith(currentStreak: 0);
      _saveStreak();
    }
  }

  /// Resets all streak data (for testing/debugging).
  void reset() {
    state = const StreakData();
    _saveStreak();
  }
}
