import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/daily_goal.dart';

final dailyGoalProvider = StateNotifierProvider<DailyGoalNotifier, DailyGoal>((ref) {
  return DailyGoalNotifier();
});

class DailyGoalNotifier extends StateNotifier<DailyGoal> {
  DailyGoalNotifier() : super(DailyGoal(targetCalculations: 3, completedCalculations: 0, date: DateTime.now())) {
    _loadGoal();
  }

  Future<void> _loadGoal() async {
    final prefs = await SharedPreferences.getInstance();
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
    
    // Reset if new day
    if (!_isSameDay(goal.date, DateTime.now())) {
      goal = DailyGoal(targetCalculations: target, completedCalculations: 0, date: DateTime.now());
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
    // Reset if new day
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('daily_goal_target', goal.targetCalculations);
    await prefs.setInt('daily_goal_completed', goal.completedCalculations);
    await prefs.setInt('daily_goal_last_reset', goal.date.millisecondsSinceEpoch);
  }
}
