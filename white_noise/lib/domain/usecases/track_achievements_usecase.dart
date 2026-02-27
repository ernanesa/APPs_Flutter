import '../entities/achievement_entity.dart';
import '../repositories/achievement_repository.dart';
import '../repositories/streak_repository.dart';

/// Use case for tracking and unlocking achievements
class TrackAchievementsUseCase {
  final AchievementRepository achievementRepository;
  final StreakRepository streakRepository;

  TrackAchievementsUseCase({
    required this.achievementRepository,
    required this.streakRepository,
  });

  /// Check all achievements and unlock if requirements met
  Future<List<AchievementEntity>> checkAndUnlockAll() async {
    final newlyUnlocked = <AchievementEntity>[];

    // Check sessions achievements
    final sessionsUnlocked = await _checkSessionsAchievements();
    newlyUnlocked.addAll(sessionsUnlocked);

    // Check time achievements
    final timeUnlocked = await _checkTimeAchievements();
    newlyUnlocked.addAll(timeUnlocked);

    // Check streak achievements
    final streakUnlocked = await _checkStreakAchievements();
    newlyUnlocked.addAll(streakUnlocked);

    // Check mixing achievements
    final mixingUnlocked = await _checkMixingAchievements();
    newlyUnlocked.addAll(mixingUnlocked);

    // Check special achievements
    final specialUnlocked = await _checkSpecialAchievements();
    newlyUnlocked.addAll(specialUnlocked);

    return newlyUnlocked;
  }

  /// Get all achievements with current progress
  Future<List<AchievementEntity>> getAllAchievements() async {
    return await achievementRepository.getAllAchievements();
  }

  Future<List<AchievementEntity>> _checkSessionsAchievements() async {
    final unlocked = <AchievementEntity>[];
    final totalSessions = await achievementRepository.getTotalSessions();

    final sessionsAchievements = await achievementRepository
        .getAchievementsByCategory(AchievementCategory.sessions);

    for (final achievement in sessionsAchievements) {
      if (!achievement.isUnlocked && totalSessions >= achievement.requirement) {
        final unlockedAchievement = await achievementRepository
            .unlockAchievement(achievement.id);
        unlocked.add(unlockedAchievement);
      }
    }

    return unlocked;
  }

  Future<List<AchievementEntity>> _checkTimeAchievements() async {
    final unlocked = <AchievementEntity>[];
    final totalTime = await achievementRepository.getTotalListeningTime();

    final timeAchievements = await achievementRepository
        .getAchievementsByCategory(AchievementCategory.time);

    for (final achievement in timeAchievements) {
      if (!achievement.isUnlocked && totalTime >= achievement.requirement) {
        final unlockedAchievement = await achievementRepository
            .unlockAchievement(achievement.id);
        unlocked.add(unlockedAchievement);
      }
    }

    return unlocked;
  }

  Future<List<AchievementEntity>> _checkStreakAchievements() async {
    final unlocked = <AchievementEntity>[];
    final currentStreak = await streakRepository.getCurrentStreak();

    final streakAchievements = await achievementRepository
        .getAchievementsByCategory(AchievementCategory.streak);

    for (final achievement in streakAchievements) {
      if (!achievement.isUnlocked && currentStreak >= achievement.requirement) {
        final unlockedAchievement = await achievementRepository
            .unlockAchievement(achievement.id);
        unlocked.add(unlockedAchievement);
      }
    }

    return unlocked;
  }

  Future<List<AchievementEntity>> _checkMixingAchievements() async {
    final unlocked = <AchievementEntity>[];
    final threeSoundMixes = await achievementRepository.getThreeSoundMixCount();

    final mixingAchievements = await achievementRepository
        .getAchievementsByCategory(AchievementCategory.mixing);

    for (final achievement in mixingAchievements) {
      if (!achievement.isUnlocked) {
        bool shouldUnlock = false;

        // First mix achievement
        if (achievement.id == 'first_mix' && threeSoundMixes >= 1) {
          shouldUnlock = true;
        }
        // Master mixer (3 sounds simultaneously)
        else if (achievement.id == 'master_mixer' && threeSoundMixes >= 1) {
          shouldUnlock = true;
        }

        if (shouldUnlock) {
          final unlockedAchievement = await achievementRepository
              .unlockAchievement(achievement.id);
          unlocked.add(unlockedAchievement);
        }
      }
    }

    return unlocked;
  }

  Future<List<AchievementEntity>> _checkSpecialAchievements() async {
    final unlocked = <AchievementEntity>[];
    final uniqueSounds = await achievementRepository.getUniqueSoundsPlayed();

    final specialAchievements = await achievementRepository
        .getAchievementsByCategory(AchievementCategory.special);

    for (final achievement in specialAchievements) {
      if (!achievement.isUnlocked) {
        bool shouldUnlock = false;

        // Night owl - checked in presentation layer based on time
        if (achievement.id == 'night_owl') {
          // Skip - requires time-based check in presentation layer
          continue;
        }
        // All sounds achievement
        else if (achievement.id == 'all_sounds' &&
            uniqueSounds >= achievement.requirement) {
          shouldUnlock = true;
        }

        if (shouldUnlock) {
          final unlockedAchievement = await achievementRepository
              .unlockAchievement(achievement.id);
          unlocked.add(unlockedAchievement);
        }
      }
    }

    return unlocked;
  }

  /// Unlock night owl achievement (called from presentation layer)
  Future<AchievementEntity?> unlockNightOwl() async {
    final isUnlocked = await achievementRepository.isUnlocked('night_owl');
    if (!isUnlocked) {
      return await achievementRepository.unlockAchievement('night_owl');
    }
    return null;
  }
}
