import '../entities/achievement.dart';

/// Repository interface for achievements
abstract class IAchievementsRepository {
  /// Get all achievements with unlock status
  Future<List<Achievement>> getAchievements();
  
  /// Unlock an achievement
  Future<Achievement> unlockAchievement(String achievementId);
  
  /// Check and unlock achievements based on current stats
  Future<List<Achievement>> checkAndUnlock({
    required int totalFasts,
    required int currentStreak,
    required int totalHours,
    required double longestFastHours,
  });
  
  /// Reset all achievements
  Future<void> resetAchievements();
}
