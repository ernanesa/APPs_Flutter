import '../entities/sound_entity.dart';

/// Abstract repository for sound operations
/// Implementation will be in Data Layer
abstract class SoundRepository {
  /// Get all available sounds
  Future<List<SoundEntity>> getAllSounds();

  /// Get sound by ID
  Future<SoundEntity?> getSoundById(String id);

  /// Get sounds by category
  Future<List<SoundEntity>> getSoundsByCategory(SoundCategory category);

  /// Play a sound
  Future<void> play(String soundId);

  /// Stop a sound
  Future<void> stop(String soundId);

  /// Pause a sound
  Future<void> pause(String soundId);

  /// Resume a sound
  Future<void> resume(String soundId);

  /// Set volume for a sound (0.0 to 1.0)
  Future<void> setVolume(String soundId, double volume);

  /// Check if a sound is currently playing
  Future<bool> isPlaying(String soundId);

  /// Stop all sounds
  Future<void> stopAll();
}
