import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:core_logic/core_logic.dart';

import '../../domain/entities/daily_goal.dart';

final dailyGoalProvider = NotifierProvider<DailyGoalNotifier, DailyGoal>(() {
  return DailyGoalNotifier();
});

class DailyGoalNotifier extends Notifier<DailyGoal> {
  @override
  DailyGoal build() {
    _loadGoal();
    return DailyGoal(
      targetCalculations: 3,
      completedCalculations: 0,
      date: DateTime.now(),
    );
  }

  Future<void> _loadGoal() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final target = prefs.getInt('daily_goal_target') ?? 3;
    final completed = prefs.getInt('daily_goal_completed') ?? 0;
    final lastResetMs = prefs.getInt('daily_goal_last_reset');

    var goal = DailyGoal(
      targetCalculations: target,
      completedCalculations: completed,
      date: lastResetMs != null
          ? DateTime.fromMillisecondsSinceEpoch(lastResetMs)
          : DateTime.now(),
    );

    if (!_isSameDay(goal.date, DateTime.now())) {
      goal = DailyGoal(
        targetCalculations: target,
        completedCalculations: 0,
        date: DateTime.now(),
      );
      await _saveGoal(goal);
    }

    state = goal;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Future<void> incrementCompleted() async {
    if (!_isSameDay(state.date, DateTime.now())) {
      state = DailyGoal(
        targetCalculations: state.targetCalculations,
        completedCalculations: 1,
        date: DateTime.now(),
      );
    } else {
      state = DailyGoal(
        targetCalculations: state.targetCalculations,
        completedCalculations: state.completedCalculations + 1,
        date: state.date,
      );
    }

    await _saveGoal(state);
  }

  Future<void> setTarget(int target) async {
    state = DailyGoal(
      targetCalculations: target,
      completedCalculations: state.completedCalculations,
      date: state.date,
    );
    await _saveGoal(state);
  }

  Future<void> _saveGoal(DailyGoal goal) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt('daily_goal_target', goal.targetCalculations);
    await prefs.setInt('daily_goal_completed', goal.completedCalculations);
    await prefs.setInt(
      'daily_goal_last_reset',
      goal.date.millisecondsSinceEpoch,
    );
  }
}
