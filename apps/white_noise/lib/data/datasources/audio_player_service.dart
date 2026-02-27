import 'package:audioplayers/audioplayers.dart';

/// Service to manage multiple audio players for simultaneous sound playback
/// Supports up to 3 sounds playing at once for mix functionality
class AudioPlayerService {
  // Map of asset paths to their player instances
  final Map<String, AudioPlayer> _players = {};

  // Map to track which sounds are currently playing
  final Map<String, bool> _playingStates = {};

  /// Play a sound with specified volume and loop setting
  /// [assetPath] - Path to audio asset (e.g., 'audio/rain_light.mp3')
  /// [volume] - Volume level from 0.0 to 1.0
  /// [loop] - Whether to loop the sound (default: true for sleep app)
  Future<void> play(
    String assetPath, {
    double volume = 1.0,
    bool loop = true,
  }) async {
    try {
      // Get or create player for this asset
      final player = _getOrCreatePlayer(assetPath);

      // Configure player
      await player.setVolume(volume);
      await player.setReleaseMode(
        loop ? ReleaseMode.loop : ReleaseMode.release,
      );

      // Play the sound
      await player.play(AssetSource(assetPath));
      _playingStates[assetPath] = true;
    } catch (e) {
      throw Exception('Failed to play sound $assetPath: $e');
    }
  }

  /// Pause a currently playing sound
  Future<void> pause(String assetPath) async {
    final player = _players[assetPath];
    if (player != null) {
      await player.pause();
      _playingStates[assetPath] = false;
    }
  }

  /// Resume a paused sound
  Future<void> resume(String assetPath) async {
    final player = _players[assetPath];
    if (player != null) {
      await player.resume();
      _playingStates[assetPath] = true;
    }
  }

  /// Stop a sound and reset its position
  Future<void> stop(String assetPath) async {
    final player = _players[assetPath];
    if (player != null) {
      await player.stop();
      _playingStates[assetPath] = false;
    }
  }

  /// Stop all currently playing sounds
  Future<void> stopAll() async {
    final futures = _players.keys.map((assetPath) => stop(assetPath)).toList();
    await Future.wait(futures);
  }

  /// Check if a sound is currently playing
  bool isPlaying(String assetPath) {
    return _playingStates[assetPath] ?? false;
  }

  /// Set volume for a specific sound
  /// [volume] - Volume level from 0.0 to 1.0
  Future<void> setVolume(String assetPath, double volume) async {
    final player = _players[assetPath];
    if (player != null) {
      await player.setVolume(volume.clamp(0.0, 1.0));
    }
  }

  /// Get the current state of a sound player
  Future<PlayerState> getState(String assetPath) async {
    final player = _players[assetPath];
    if (player == null) return PlayerState.stopped;
    return player.state;
  }

  /// Dispose a specific player and remove it from the map
  Future<void> disposePlayer(String assetPath) async {
    final player = _players.remove(assetPath);
    if (player != null) {
      await player.stop();
      await player.dispose();
      _playingStates.remove(assetPath);
    }
  }

  /// Dispose all players and clean up resources
  Future<void> dispose() async {
    final futures = _players.values.map((player) async {
      await player.stop();
      await player.dispose();
    }).toList();

    await Future.wait(futures);
    _players.clear();
    _playingStates.clear();
  }

  /// Get or create a player instance for an asset
  AudioPlayer _getOrCreatePlayer(String assetPath) {
    if (!_players.containsKey(assetPath)) {
      _players[assetPath] = AudioPlayer();
      _playingStates[assetPath] = false;
    }
    return _players[assetPath]!;
  }

  /// Get list of currently playing sounds
  List<String> getPlayingSounds() {
    return _playingStates.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  /// Get count of active players
  int get activePlayersCount => _players.length;

  /// Get count of currently playing sounds
  int get playingCount =>
      _playingStates.values.where((playing) => playing).length;

  /// Check if service can accept more sounds (max 3 for mix)
  bool canAddSound() => playingCount < 3;

  /// Set global volume for all active sounds
  Future<void> setGlobalVolume(double volume) async {
    final clampedVolume = volume.clamp(0.0, 1.0);
    final futures = _players.values
        .map((player) => player.setVolume(clampedVolume))
        .toList();
    await Future.wait(futures);
  }
}
