import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/achievement.dart';

final achievementProvider =
    StateNotifierProvider<AchievementNotifier, List<Achievement>>((ref) {
      return AchievementNotifier();
    });

class AchievementNotifier extends StateNotifier<List<Achievement>> {
  AchievementNotifier() : super(DefaultAchievements.all) {
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedIds = prefs.getStringList('unlocked_achievements') ?? [];

    state =
        DefaultAchievements.all.map((achievement) {
          final isUnlocked = unlockedIds.contains(achievement.id);
          return isUnlocked
              ? achievement.copyWith(
                isUnlocked: true,
                unlockedAt: DateTime.now(), // Ideally store actual unlock time
              )
              : achievement;
        }).toList();
  }

  Future<List<Achievement>> checkAndUnlock({
    required int totalCalculations,
    required int currentStreak,
    required double totalAmount,
    required int months,
  }) async {
    final newlyUnlocked = <Achievement>[];

    state =
        state.map((achievement) {
          if (achievement.isUnlocked) return achievement;

          bool shouldUnlock = false;

          switch (achievement.id) {
            case 'first_calculation':
              shouldUnlock = totalCalculations >= 1;
              break;
            case 'calculation_10':
              shouldUnlock = totalCalculations >= 10;
              break;
            case 'calculation_50':
              shouldUnlock = totalCalculations >= 50;
              break;
            case 'calculation_100':
              shouldUnlock = totalCalculations >= 100;
              break;
            case 'streak_3':
              shouldUnlock = currentStreak >= 3;
              break;
            case 'streak_7':
              shouldUnlock = currentStreak >= 7;
              break;
            case 'streak_30':
              shouldUnlock = currentStreak >= 30;
              break;
            case 'million':
              shouldUnlock = totalAmount >= 1000000;
              break;
            case 'ten_million':
              shouldUnlock = totalAmount >= 10000000;
              break;
            case 'long_term':
              shouldUnlock = months >= 120; // 10 years
              break;
          }

          if (shouldUnlock) {
            newlyUnlocked.add(achievement);
            return achievement.copyWith(
              isUnlocked: true,
              unlockedAt: DateTime.now(),
            );
          }

          return achievement;
        }).toList();

    if (newlyUnlocked.isNotEmpty) {
      await _saveAchievements();
    }

    return newlyUnlocked;
  }

  Future<void> _saveAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    final unlockedIds =
        state.where((a) => a.isUnlocked).map((a) => a.id).toList();
    await prefs.setStringList('unlocked_achievements', unlockedIds);
  }
}
