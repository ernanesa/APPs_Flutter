import '../entities/streak_entity.dart';
import '../repositories/streak_repository.dart';

/// Use case for updating daily streak
class UpdateStreakUseCase {
  final StreakRepository streakRepository;

  UpdateStreakUseCase({
    required this.streakRepository,
  });

  /// Update streak for today (called on app usage)
  Future<StreakResult> updateStreak() async {
    try {
      // Check if already active today
      final isActive = await streakRepository.isActiveToday();
      if (isActive) {
        final currentStreak = await streakRepository.getStreak();
        return StreakResult.alreadyActive(currentStreak);
      }

      // Update streak
      final updatedStreak = await streakRepository.updateStreak();

      // Determine if this is a new milestone
      final milestone = _checkMilestone(updatedStreak.currentStreak);

      return StreakResult.updated(updatedStreak, milestone);
    } catch (e) {
      return StreakResult.failure('Failed to update streak: $e');
    }
  }

  /// Get current streak
  Future<StreakEntity> getCurrentStreak() async {
    return await streakRepository.getStreak();
  }

  /// Reset streak (e.g., user request)
  Future<StreakEntity> resetStreak() async {
    return await streakRepository.resetStreak();
  }

  StreakMilestone? _checkMilestone(int streak) {
    if (streak == 3) return StreakMilestone.threeDays;
    if (streak == 7) return StreakMilestone.oneWeek;
    if (streak == 14) return StreakMilestone.twoWeeks;
    if (streak == 30) return StreakMilestone.oneMonth;
    if (streak == 100) return StreakMilestone.hundredDays;
    return null;
  }
}

/// Result of streak update
class StreakResult {
  final bool isSuccess;
  final StreakEntity? streak;
  final StreakMilestone? milestone;
  final bool alreadyActiveToday;
  final String? errorMessage;

  StreakResult._({
    required this.isSuccess,
    this.streak,
    this.milestone,
    this.alreadyActiveToday = false,
    this.errorMessage,
  });

  factory StreakResult.updated(StreakEntity streak, StreakMilestone? milestone) {
    return StreakResult._(
      isSuccess: true,
      streak: streak,
      milestone: milestone,
    );
  }

  factory StreakResult.alreadyActive(StreakEntity streak) {
    return StreakResult._(
      isSuccess: true,
      streak: streak,
      alreadyActiveToday: true,
    );
  }

  factory StreakResult.failure(String message) {
    return StreakResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }

  bool get hasMilestone => milestone != null;
}

/// Streak milestones for user feedback
enum StreakMilestone {
  threeDays,
  oneWeek,
  twoWeeks,
  oneMonth,
  hundredDays,
}
