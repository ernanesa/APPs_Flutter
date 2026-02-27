import '../entities/streak_entity.dart';

/// Abstract repository for streak operations
abstract class StreakRepository {
  /// Get current streak
  Future<StreakEntity> getStreak();

  /// Update streak (record activity for today)
  Future<StreakEntity> updateStreak();

  /// Reset streak
  Future<StreakEntity> resetStreak();

  /// Check if active today
  Future<bool> isActiveToday();

  /// Get current streak count
  Future<int> getCurrentStreak();

  /// Get best streak count
  Future<int> getBestStreak();
}
