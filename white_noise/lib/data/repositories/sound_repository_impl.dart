import '../../domain/entities/sound_entity.dart';
import '../../domain/repositories/sound_repository.dart';
import '../datasources/audio_player_service.dart';
import '../datasources/local_data_source.dart';

class SoundRepositoryImpl implements SoundRepository {
  final AudioPlayerService _audioService;
  final LocalDataSource _localDataSource;

  SoundRepositoryImpl(this._audioService, this._localDataSource);

  @override
  Future<List<SoundEntity>> getAllSounds() async {
    return DefaultSounds.all;
  }

  @override
  Future<SoundEntity?> getSoundById(String id) async {
    return DefaultSounds.findById(id);
  }

  @override
  Future<List<SoundEntity>> getSoundsByCategory(SoundCategory category) async {
    return DefaultSounds.getByCategory(category);
  }

  @override
  Future<void> play(String soundId) async {
    final sound = await getSoundById(soundId);
    if (sound == null) throw Exception('Sound not found: $soundId');
    await _audioService.play(sound.assetPath, volume: 1.0, loop: true);
  }

  @override
  Future<void> stop(String soundId) async {
    final sound = await getSoundById(soundId);
    if (sound == null) return;
    await _audioService.stop(sound.assetPath);
  }

  @override
  Future<void> pause(String soundId) async {
    final sound = await getSoundById(soundId);
    if (sound == null) return;
    await _audioService.pause(sound.assetPath);
  }

  @override
  Future<void> resume(String soundId) async {
    final sound = await getSoundById(soundId);
    if (sound == null) return;
    await _audioService.resume(sound.assetPath);
  }

  @override
  Future<void> setVolume(String soundId, double volume) async {
    final sound = await getSoundById(soundId);
    if (sound == null) return;
    await _audioService.setVolume(sound.assetPath, volume);
  }

  @override
  Future<bool> isPlaying(String soundId) async {
    final sound = await getSoundById(soundId);
    if (sound == null) return false;
    return _audioService.isPlaying(sound.assetPath);
  }

  @override
  Future<void> stopAll() async {
    await _audioService.stopAll();
  }
}
