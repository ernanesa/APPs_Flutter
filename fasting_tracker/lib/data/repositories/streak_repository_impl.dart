import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/streak_data.dart';
import '../../domain/repositories/i_streak_repository.dart';
import '../models/streak_data_model.dart';

class StreakRepositoryImpl implements IStreakRepository {
  final SharedPreferences _prefs;
  
  static const String _streakKey = 'streak_data';

  StreakRepositoryImpl(this._prefs);

  @override
  Future<StreakData> getStreakData() async {
    final json = _prefs.getString(_streakKey);
    if (json == null || json.isEmpty) return const StreakData();
    
    try {
      return StreakDataModel.decode(json);
    } catch (_) {
      return const StreakData();
    }
  }

  @override
  Future<StreakData> recordCompletedFast(int durationMinutes) async {
    final current = await getStreakData();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    int newStreak = current.currentStreak;
    
    if (current.lastCompletedDate != null) {
      final lastDate = DateTime(
        current.lastCompletedDate!.year,
        current.lastCompletedDate!.month,
        current.lastCompletedDate!.day,
      );
      final difference = today.difference(lastDate).inDays;
      
      if (difference == 0) {
        // Already completed today, don't increment streak
        newStreak = current.currentStreak;
      } else if (difference == 1) {
        // Consecutive day
        newStreak = current.currentStreak + 1;
      } else {
        // Streak broken
        newStreak = 1;
      }
    } else {
      // First fast ever
      newStreak = 1;
    }

    final newBest = newStreak > current.bestStreak ? newStreak : current.bestStreak;
    
    final updated = StreakDataModel(
      currentStreak: newStreak,
      bestStreak: newBest,
      lastCompletedDate: now,
      totalCompletedFasts: current.totalCompletedFasts + 1,
      totalFastingMinutes: current.totalFastingMinutes + durationMinutes,
    );

    await _prefs.setString(_streakKey, updated.encode());
    return updated;
  }

  @override
  Future<void> resetStreak() async {
    await _prefs.remove(_streakKey);
  }
}
