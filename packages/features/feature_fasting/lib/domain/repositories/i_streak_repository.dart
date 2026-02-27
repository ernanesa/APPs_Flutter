import '../entities/streak_data.dart';

/// Repository interface for streak data
abstract class IStreakRepository {
  /// Get current streak data
  Future<StreakData> getStreakData();

  /// Record a completed fast
  Future<StreakData> recordCompletedFast(int durationMinutes);

  /// Reset streak (for testing or user request)
  Future<void> resetStreak();
}
