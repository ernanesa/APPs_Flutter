import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/streak_data.dart';

final streakProvider = StateNotifierProvider<StreakNotifier, StreakData>((ref) {
  return StreakNotifier();
});

class StreakNotifier extends StateNotifier<StreakData> {
  StreakNotifier() : super(const StreakData()) {
    _loadStreak();
  }

  Future<void> _loadStreak() async {
    final prefs = await SharedPreferences.getInstance();
    final currentStreak = prefs.getInt('current_streak') ?? 0;
    final bestStreak = prefs.getInt('best_streak') ?? 0;
    final lastActiveMs = prefs.getInt('last_active_date');

    state = StreakData(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      lastActiveDate: lastActiveMs != null
          ? DateTime.fromMillisecondsSinceEpoch(lastActiveMs)
          : null,
    );
  }

  Future<void> recordActivity() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (state.isActiveToday) return; // Already recorded today

    int newStreak = 1;
    if (state.lastActiveDate != null) {
      final lastDate = DateTime(
        state.lastActiveDate!.year,
        state.lastActiveDate!.month,
        state.lastActiveDate!.day,
      );
      final difference = today.difference(lastDate).inDays;

      if (difference == 1) {
        newStreak = state.currentStreak + 1; // Consecutive day
      } else if (difference > 1) {
        newStreak = 1; // Streak broken
      }
    }

    final newBest = newStreak > state.bestStreak ? newStreak : state.bestStreak;

    state = StreakData(
      currentStreak: newStreak,
      bestStreak: newBest,
      lastActiveDate: now,
    );

    await _saveStreak();
  }

  Future<void> _saveStreak() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_streak', state.currentStreak);
    await prefs.setInt('best_streak', state.bestStreak);
    if (state.lastActiveDate != null) {
      await prefs.setInt(
        'last_active_date',
        state.lastActiveDate!.millisecondsSinceEpoch,
      );
    }
  }
}
