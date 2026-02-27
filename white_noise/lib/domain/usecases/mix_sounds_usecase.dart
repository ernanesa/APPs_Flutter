import '../entities/mix_entity.dart';
import '../repositories/sound_repository.dart';
import '../repositories/mix_repository.dart';
import '../repositories/achievement_repository.dart';
import '../repositories/streak_repository.dart';

/// Use case for mixing up to 3 sounds simultaneously
/// PRIMARY FEATURE: Mix white noise + rain for children's sleep
class MixSoundsUseCase {
  final SoundRepository soundRepository;
  final MixRepository mixRepository;
  final AchievementRepository achievementRepository;
  final StreakRepository streakRepository;

  MixSoundsUseCase({
    required this.soundRepository,
    required this.mixRepository,
    required this.achievementRepository,
    required this.streakRepository,
  });

  /// Add sound to current mix
  Future<MixResult> addSound(String soundId, {double volume = 0.7}) async {
    try {
      final currentMix = await mixRepository.getCurrentMix();

      // Check if already in mix
      if (currentMix.containsSound(soundId)) {
        return MixResult.failure('Sound already in mix');
      }

      // Check mix limit (max 3 sounds)
      if (currentMix.sounds.length >= 3) {
        return MixResult.failure('Maximum 3 sounds allowed in mix');
      }

      // Validate sound exists
      final sound = await soundRepository.getSoundById(soundId);
      if (sound == null) {
        return MixResult.failure('Sound not found');
      }

      // Add to mix
      final updatedMix = await mixRepository.addSound(soundId, volume);

      // Track achievement if mixing 3 sounds
      if (updatedMix.sounds.length == 3) {
        await achievementRepository.incrementThreeSoundMix();
      }

      return MixResult.success(updatedMix);
    } catch (e) {
      return MixResult.failure('Failed to add sound: $e');
    }
  }

  /// Remove sound from mix
  Future<MixResult> removeSound(String soundId) async {
    try {
      final updatedMix = await mixRepository.removeSound(soundId);
      return MixResult.success(updatedMix);
    } catch (e) {
      return MixResult.failure('Failed to remove sound: $e');
    }
  }

  /// Update volume for a sound in mix
  Future<MixResult> updateVolume(String soundId, double volume) async {
    try {
      final updatedMix = await mixRepository.updateVolume(soundId, volume);
      return MixResult.success(updatedMix);
    } catch (e) {
      return MixResult.failure('Failed to update volume: $e');
    }
  }

  /// Play the current mix
  Future<MixResult> playMix() async {
    try {
      final currentMix = await mixRepository.getCurrentMix();

      if (currentMix.isEmpty) {
        return MixResult.failure('Mix is empty');
      }

      // Play mix
      await mixRepository.playMix();

      // Track activity
      await _trackActivity();

      return MixResult.success(currentMix);
    } catch (e) {
      return MixResult.failure('Failed to play mix: $e');
    }
  }

  /// Stop the current mix
  Future<MixResult> stopMix() async {
    try {
      await mixRepository.stopMix();
      final currentMix = await mixRepository.getCurrentMix();
      return MixResult.success(currentMix);
    } catch (e) {
      return MixResult.failure('Failed to stop mix: $e');
    }
  }

  /// Clear all sounds from mix
  Future<MixResult> clearMix() async {
    try {
      final clearedMix = await mixRepository.clearMix();
      return MixResult.success(clearedMix);
    } catch (e) {
      return MixResult.failure('Failed to clear mix: $e');
    }
  }

  Future<void> _trackActivity() async {
    // Increment session count
    await achievementRepository.incrementSessions();

    // Update streak
    await streakRepository.updateStreak();
  }
}

/// Result of mix operation
class MixResult {
  final bool isSuccess;
  final MixEntity? mix;
  final String? errorMessage;

  MixResult._({required this.isSuccess, this.mix, this.errorMessage});

  factory MixResult.success(MixEntity mix) {
    return MixResult._(isSuccess: true, mix: mix);
  }

  factory MixResult.failure(String message) {
    return MixResult._(isSuccess: false, errorMessage: message);
  }
}
