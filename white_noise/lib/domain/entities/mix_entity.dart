import 'sound_entity.dart';

/// Entity representing a mix of up to 3 simultaneous sounds
/// Example: White noise + light rain for optimal children's sleep
class MixEntity {
  final List<MixSound> sounds;
  final bool isPlaying;

  const MixEntity({
    required this.sounds,
    this.isPlaying = false,
  });

  MixEntity copyWith({
    List<MixSound>? sounds,
    bool? isPlaying,
  }) {
    return MixEntity(
      sounds: sounds ?? this.sounds,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  /// Check if mix is valid (max 3 sounds)
  bool get isValid => sounds.length <= 3;

  /// Check if mix is empty
  bool get isEmpty => sounds.isEmpty;

  /// Check if sound is in the mix
  bool containsSound(String soundId) {
    return sounds.any((mixSound) => mixSound.sound.id == soundId);
  }

  /// Get sound from mix by ID
  MixSound? getSoundById(String soundId) {
    try {
      return sounds.firstWhere((mixSound) => mixSound.sound.id == soundId);
    } catch (_) {
      return null;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MixEntity &&
        other.sounds.length == sounds.length &&
        other.isPlaying == isPlaying;
  }

  @override
  int get hashCode => Object.hash(sounds.length, isPlaying);
}

/// Individual sound in a mix with volume control
class MixSound {
  final SoundEntity sound;
  final double volume; // 0.0 to 1.0

  const MixSound({
    required this.sound,
    this.volume = 0.7,
  });

  MixSound copyWith({
    SoundEntity? sound,
    double? volume,
  }) {
    return MixSound(
      sound: sound ?? this.sound,
      volume: volume ?? this.volume,
    );
  }

  /// Clamp volume to valid range
  MixSound withVolume(double newVolume) {
    return copyWith(volume: newVolume.clamp(0.0, 1.0));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MixSound &&
        other.sound.id == sound.id &&
        other.volume == volume;
  }

  @override
  int get hashCode => Object.hash(sound.id, volume);
}
