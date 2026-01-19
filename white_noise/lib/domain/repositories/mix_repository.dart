import '../entities/mix_entity.dart';

/// Abstract repository for sound mixing operations
abstract class MixRepository {
  /// Get current mix
  Future<MixEntity> getCurrentMix();

  /// Save current mix
  Future<void> saveMix(MixEntity mix);

  /// Add sound to mix (max 3 sounds)
  Future<MixEntity> addSound(String soundId, double volume);

  /// Remove sound from mix
  Future<MixEntity> removeSound(String soundId);

  /// Update volume for a sound in mix
  Future<MixEntity> updateVolume(String soundId, double volume);

  /// Clear all sounds from mix
  Future<MixEntity> clearMix();

  /// Play current mix
  Future<void> playMix();

  /// Stop current mix
  Future<void> stopMix();

  /// Check if mix is playing
  Future<bool> isMixPlaying();
}
