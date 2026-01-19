import '../entities/achievement_entity.dart';

/// Abstract repository for achievement operations
abstract class AchievementRepository {
  /// Get all achievements
  Future<List<AchievementEntity>> getAllAchievements();

  /// Get unlocked achievements
  Future<List<AchievementEntity>> getUnlockedAchievements();

  /// Get locked achievements
  Future<List<AchievementEntity>> getLockedAchievements();

  /// Get achievements by category
  Future<List<AchievementEntity>> getAchievementsByCategory(
    AchievementCategory category,
  );

  /// Unlock an achievement
  Future<AchievementEntity> unlockAchievement(String achievementId);

  /// Check if achievement is unlocked
  Future<bool> isUnlocked(String achievementId);

  /// Get total sessions count
  Future<int> getTotalSessions();

  /// Increment total sessions
  Future<void> incrementSessions();

  /// Get total listening time (in minutes)
  Future<int> getTotalListeningTime();

  /// Add listening time
  Future<void> addListeningTime(int minutes);

  /// Get count of unique sounds played
  Future<int> getUniqueSoundsPlayed();

  /// Record sound played
  Future<void> recordSoundPlayed(String soundId);

  /// Get count of times mixed 3 sounds
  Future<int> getThreeSoundMixCount();

  /// Increment three sound mix count
  Future<void> incrementThreeSoundMix();
}
