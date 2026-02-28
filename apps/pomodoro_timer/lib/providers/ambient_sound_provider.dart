import 'package:core_logic/core_logic.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ambient_sound.dart';

/// Provider for the currently selected ambient sound.
final selectedAmbientSoundProvider =
    NotifierProvider<AmbientSoundNotifier, AmbientSound>(() {
  return AmbientSoundNotifier();
});

/// Provider for the audio player (singleton).
final ambientAudioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();
  ref.onDispose(() => player.dispose());
  return player;
});

/// Provider for whether ambient sound is currently playing.
final isAmbientPlayingProvider = StateProvider<bool>((ref) => false);

/// Notifier for managing ambient sound selection (Notifier API 2026).
class AmbientSoundNotifier extends Notifier<AmbientSound> {
  static const _key = 'selected_ambient_sound';

  @override
  AmbientSound build() {
    _loadSelectedSound();
    return AmbientSounds.silence;
  }

  void _loadSelectedSound() {
    final prefs = ref.read(sharedPreferencesProvider);
    final soundId = prefs.getString(_key);
    if (soundId != null) {
      state = AmbientSounds.all.firstWhere(
        (s) => s.id == soundId,
        orElse: () => AmbientSounds.silence,
      );
    }
  }

  Future<void> selectSound(AmbientSound sound) async {
    state = sound;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, sound.id);
  }
}

/// Service for controlling ambient sound playback.
class AmbientSoundService {
  final AudioPlayer _player;
  final Ref _ref;

  AmbientSoundService(this._player, this._ref);

  /// Starts playing the selected ambient sound.
  Future<void> play() async {
    final sound = _ref.read(selectedAmbientSoundProvider);

    if (sound.assetPath == null) {
      await stop();
      return;
    }

    try {
      await _player.setReleaseMode(ReleaseMode.loop);
      await _player.setVolume(0.5);
      await _player.play(
        AssetSource(sound.assetPath!.replaceFirst('assets/', '')),
      );
      _ref.read(isAmbientPlayingProvider.notifier).state = true;
    } catch (e) {
      // Handle error silently
    }
  }

  /// Stops ambient sound playback.
  Future<void> stop() async {
    await _player.stop();
    _ref.read(isAmbientPlayingProvider.notifier).state = false;
  }

  /// Pauses ambient sound playback.
  Future<void> pause() async {
    await _player.pause();
    _ref.read(isAmbientPlayingProvider.notifier).state = false;
  }

  /// Resumes ambient sound playback.
  Future<void> resume() async {
    await _player.resume();
    _ref.read(isAmbientPlayingProvider.notifier).state = true;
  }

  /// Sets volume (0.0 to 1.0).
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }
}

/// Provider for the ambient sound service.
final ambientSoundServiceProvider = Provider<AmbientSoundService>((ref) {
  final player = ref.watch(ambientAudioPlayerProvider);
  return AmbientSoundService(player, ref);
});
