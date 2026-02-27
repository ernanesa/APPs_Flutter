import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/daily_goal.dart';
import 'settings_provider.dart';

/// Provider for daily goal.
final dailyGoalProvider = StateNotifierProvider<DailyGoalNotifier, DailyGoal>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return DailyGoalNotifier(prefs);
});

/// Notifier for managing daily goals.
class DailyGoalNotifier extends StateNotifier<DailyGoal> {
  final SharedPreferences _prefs;
  static const _goalKey = 'daily_goal';
  static const _targetKey = 'daily_goal_target';

  DailyGoalNotifier(this._prefs) : super(DailyGoal(date: DateTime.now())) {
    _loadDailyGoal();
  }

  void _loadDailyGoal() {
    final targetSessions = _prefs.getInt(_targetKey) ?? 8;
    final json = _prefs.getString(_goalKey);

    if (json != null) {
      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        final savedGoal = DailyGoal.fromJson(map);

        // Check if it's still today
        if (savedGoal.isToday) {
          state = savedGoal.copyWith(targetSessions: targetSessions);
        } else {
          // New day - reset progress but keep target
          state = DailyGoal(
            date: DateTime.now(),
            targetSessions: targetSessions,
          );
          _saveDailyGoal();
        }
      } catch (_) {
        // Use default on error
        state = DailyGoal(date: DateTime.now(), targetSessions: targetSessions);
      }
    } else {
      state = DailyGoal(date: DateTime.now(), targetSessions: targetSessions);
    }
  }

  Future<void> _saveDailyGoal() async {
    await _prefs.setString(_goalKey, jsonEncode(state.toJson()));
  }

  /// Records a completed focus session.
  void recordFocusSessionCompleted(int durationMinutes) {
    // Ensure we're tracking today
    if (!state.isToday) {
      state = DailyGoal(
        date: DateTime.now(),
        targetSessions: state.targetSessions,
      );
    }

    state = state.copyWith(
      completedSessions: state.completedSessions + 1,
      focusMinutesToday: state.focusMinutesToday + durationMinutes,
    );

    _saveDailyGoal();
  }

  /// Updates the daily target.
  Future<void> setTargetSessions(int target) async {
    await _prefs.setInt(_targetKey, target);
    state = state.copyWith(targetSessions: target);
    _saveDailyGoal();
  }

  /// Resets today's progress (for testing/debugging).
  void resetTodayProgress() {
    state = DailyGoal(
      date: DateTime.now(),
      targetSessions: state.targetSessions,
    );
    _saveDailyGoal();
  }
}
