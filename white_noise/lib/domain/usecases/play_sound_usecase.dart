import '../entities/sound_entity.dart';
import '../repositories/sound_repository.dart';
import '../repositories/achievement_repository.dart';
import '../repositories/streak_repository.dart';

/// Use case for playing a single sound
class PlaySoundUseCase {
  final SoundRepository soundRepository;
  final AchievementRepository achievementRepository;
  final StreakRepository streakRepository;

  PlaySoundUseCase({
    required this.soundRepository,
    required this.achievementRepository,
    required this.streakRepository,
  });

  /// Execute: Play a sound and track achievements
  Future<PlaySoundResult> execute(String soundId) async {
    try {
      // Validate sound exists
      final sound = await soundRepository.getSoundById(soundId);
      if (sound == null) {
        return PlaySoundResult.failure('Sound not found');
      }

      // Stop all other sounds first (single play mode)
      await soundRepository.stopAll();

      // Play the sound
      await soundRepository.play(soundId);

      // Track activity
      await _trackActivity(soundId);

      return PlaySoundResult.success(sound);
    } catch (e) {
      return PlaySoundResult.failure('Failed to play sound: $e');
    }
  }

  Future<void> _trackActivity(String soundId) async {
    // Record sound played for achievements
    await achievementRepository.recordSoundPlayed(soundId);

    // Increment session count
    await achievementRepository.incrementSessions();

    // Update streak
    await streakRepository.updateStreak();
  }
}

/// Result of play sound operation
class PlaySoundResult {
  final bool isSuccess;
  final SoundEntity? sound;
  final String? errorMessage;

  PlaySoundResult._({
    required this.isSuccess,
    this.sound,
    this.errorMessage,
  });

  factory PlaySoundResult.success(SoundEntity sound) {
    return PlaySoundResult._(
      isSuccess: true,
      sound: sound,
    );
  }

  factory PlaySoundResult.failure(String message) {
    return PlaySoundResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }
}
