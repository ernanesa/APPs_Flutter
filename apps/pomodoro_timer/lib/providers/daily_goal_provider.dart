import 'package:core_logic/core_logic.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_goal.dart';

/// Provider for daily goal (Notifier API 2026).
final dailyGoalProvider = NotifierProvider<DailyGoalNotifier, DailyGoal>(() {
  return DailyGoalNotifier();
});

/// Notifier for managing daily goals.
class DailyGoalNotifier extends Notifier<DailyGoal> {
  static const _goalKey = 'daily_goal';
  static const _targetKey = 'daily_goal_target';

  @override
  DailyGoal build() {
    _loadDailyGoal();
    return DailyGoal(date: DateTime.now());
  }

  void _loadDailyGoal() {
    final prefs = ref.read(sharedPreferencesProvider);
    final targetSessions = prefs.getInt(_targetKey) ?? 8;
    final json = prefs.getString(_goalKey);

    if (json != null) {
      try {
        final map = jsonDecode(json) as Map<String, dynamic>;
        final savedGoal = DailyGoal.fromJson(map);

        if (savedGoal.isToday) {
          state = savedGoal.copyWith(targetSessions: targetSessions);
        } else {
          state = DailyGoal(
            date: DateTime.now(),
            targetSessions: targetSessions,
          );
          _saveDailyGoal();
        }
      } catch (_) {
        state = DailyGoal(date: DateTime.now(), targetSessions: targetSessions);
      }
    } else {
      state = DailyGoal(date: DateTime.now(), targetSessions: targetSessions);
    }
  }

  Future<void> _saveDailyGoal() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_goalKey, jsonEncode(state.toJson()));
  }

  /// Records a completed focus session.
  void recordFocusSessionCompleted(int durationMinutes) {
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
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_targetKey, target);
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
