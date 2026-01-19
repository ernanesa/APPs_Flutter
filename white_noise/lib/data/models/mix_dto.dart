import 'package:white_noise/domain/entities/mix_entity.dart';
import 'package:white_noise/domain/entities/sound_entity.dart';

/// DTO for MixSound (stores sound ID instead of full object)
class MixSoundDto {
  final String soundId; // Reference by ID, not full object
  final double volume;

  const MixSoundDto({
    required this.soundId,
    required this.volume,
  });

  /// Convert to entity (requires sound catalog for lookup)
  MixSound toEntity(List<SoundEntity> soundCatalog) {
    final sound = soundCatalog.firstWhere(
      (s) => s.id == soundId,
      orElse: () => DefaultSounds.all.first, // Fallback to first sound
    );
    return MixSound(sound: sound, volume: volume);
  }

  factory MixSoundDto.fromEntity(MixSound mixSound) {
    return MixSoundDto(
      soundId: mixSound.sound.id,
      volume: mixSound.volume,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soundId': soundId,
      'volume': volume,
    };
  }

  factory MixSoundDto.fromJson(Map<String, dynamic> json) {
    return MixSoundDto(
      soundId: json['soundId'] as String,
      volume: (json['volume'] as num?)?.toDouble() ?? 0.7,
    );
  }
}

/// DTO for MixEntity serialization
class MixDto {
  final List<MixSoundDto> sounds;
  final bool isPlaying;

  const MixDto({
    required this.sounds,
    required this.isPlaying,
  });

  /// Convert to entity (requires sound catalog)
  MixEntity toEntity(List<SoundEntity> soundCatalog) {
    return MixEntity(
      sounds: sounds.map((dto) => dto.toEntity(soundCatalog)).toList(),
      isPlaying: isPlaying,
    );
  }

  factory MixDto.fromEntity(MixEntity entity) {
    return MixDto(
      sounds: entity.sounds.map((ms) => MixSoundDto.fromEntity(ms)).toList(),
      isPlaying: entity.isPlaying,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sounds': sounds.map((s) => s.toJson()).toList(),
      'isPlaying': isPlaying,
    };
  }

  factory MixDto.fromJson(Map<String, dynamic> json) {
    return MixDto(
      sounds: (json['sounds'] as List<dynamic>?)
              ?.map((s) => MixSoundDto.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      isPlaying: json['isPlaying'] as bool? ?? false,
    );
  }
}
