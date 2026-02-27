import '../../domain/entities/mix_entity.dart';
import '../../domain/entities/sound_entity.dart';
import '../../domain/repositories/mix_repository.dart';
import '../datasources/audio_player_service.dart';
import '../datasources/local_data_source.dart';
import '../models/mix_dto.dart';

/// Implementation of MixRepository using LocalDataSource and AudioPlayerService
class MixRepositoryImpl implements MixRepository {
  final LocalDataSource _localDataSource;
  final AudioPlayerService _audioPlayerService;

  MixRepositoryImpl({
    required LocalDataSource localDataSource,
    required AudioPlayerService audioPlayerService,
  }) : _localDataSource = localDataSource,
       _audioPlayerService = audioPlayerService;

  @override
  Future<MixEntity> getCurrentMix() async {
    final json = await _localDataSource.getJson(LocalDataSource.keyCurrentMix);
    if (json == null) {
      return const MixEntity(sounds: []);
    }
    final dto = MixDto.fromJson(json);
    return dto.toEntity(DefaultSounds.all);
  }

  @override
  Future<void> saveMix(MixEntity mix) async {
    final dto = MixDto.fromEntity(mix);
    await _localDataSource.setJson(LocalDataSource.keyCurrentMix, dto.toJson());
  }

  @override
  Future<MixEntity> addSound(String soundId, double volume) async {
    final currentMix = await getCurrentMix();

    // Check max 3 sounds limit
    if (currentMix.sounds.length >= 3 && !currentMix.containsSound(soundId)) {
      throw Exception('Maximum 3 sounds in mix');
    }

    // Find sound entity
    final sound = DefaultSounds.findById(soundId);
    if (sound == null) throw Exception('Sound not found: $soundId');

    // Remove if exists, then add with new volume
    final updatedSounds = currentMix.sounds
        .where((ms) => ms.sound.id != soundId)
        .toList();
    updatedSounds.add(MixSound(sound: sound, volume: volume.clamp(0.0, 1.0)));

    final updatedMix = currentMix.copyWith(sounds: updatedSounds);
    await saveMix(updatedMix);

    return updatedMix;
  }

  @override
  Future<MixEntity> removeSound(String soundId) async {
    final currentMix = await getCurrentMix();

    final updatedSounds = currentMix.sounds
        .where((ms) => ms.sound.id != soundId)
        .toList();

    final updatedMix = currentMix.copyWith(sounds: updatedSounds);
    await saveMix(updatedMix);

    // Stop the sound if playing
    final sound = DefaultSounds.findById(soundId);
    if (sound != null) {
      await _audioPlayerService.stop(sound.assetPath);
    }

    return updatedMix;
  }

  @override
  Future<MixEntity> updateVolume(String soundId, double volume) async {
    final currentMix = await getCurrentMix();

    if (!currentMix.containsSound(soundId)) {
      throw Exception('Sound not in mix');
    }

    final updatedSounds = currentMix.sounds.map((ms) {
      if (ms.sound.id == soundId) {
        return ms.withVolume(volume);
      }
      return ms;
    }).toList();

    final updatedMix = currentMix.copyWith(sounds: updatedSounds);
    await saveMix(updatedMix);

    // Update volume if sound is playing
    final sound = DefaultSounds.findById(soundId);
    if (sound != null && _audioPlayerService.isPlaying(sound.assetPath)) {
      await _audioPlayerService.setVolume(sound.assetPath, volume);
    }

    return updatedMix;
  }

  @override
  Future<MixEntity> clearMix() async {
    const emptyMix = MixEntity(sounds: []);
    await saveMix(emptyMix);
    await stopMix();
    return emptyMix;
  }

  @override
  Future<void> playMix() async {
    final currentMix = await getCurrentMix();

    // Play all sounds in the mix
    for (final mixSound in currentMix.sounds) {
      await _audioPlayerService.play(
        mixSound.sound.assetPath,
        volume: mixSound.volume,
        loop: true,
      );
    }
  }

  @override
  Future<void> stopMix() async {
    await _audioPlayerService.stopAll();
  }

  @override
  Future<bool> isMixPlaying() async {
    return _audioPlayerService.playingCount > 0;
  }
}
