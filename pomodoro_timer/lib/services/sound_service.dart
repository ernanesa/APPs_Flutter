import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import '../utils/logger.dart';

/// Service for managing sound and haptic feedback.
class SoundService {
  static SoundService? _instance;
  static SoundService get instance => _instance ??= SoundService._();
  
  SoundService._();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  /// Sets whether sound is enabled.
  void setSoundEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  /// Sets whether vibration is enabled.
  void setVibrationEnabled(bool enabled) {
    _vibrationEnabled = enabled;
  }

  /// Plays the timer complete sound.
  Future<void> playTimerComplete() async {
    if (!_soundEnabled) return;
    
    try {
      // Using a built-in notification sound
      await _audioPlayer.play(
        AssetSource('sounds/timer_complete.mp3'),
        volume: 0.8,
      );
    } catch (e) {
      logDebug('Error playing sound: $e');
      // Fallback to system sound
      await _playSystemSound();
    }
  }

  /// Plays a tick sound (for countdown if enabled).
  Future<void> playTick() async {
    if (!_soundEnabled) return;
    
    try {
      await _audioPlayer.play(
        AssetSource('sounds/tick.mp3'),
        volume: 0.3,
      );
    } catch (e) {
      logDebug('Error playing tick: $e');
    }
  }

  /// Plays a button click sound.
  Future<void> playClick() async {
    if (!_soundEnabled) return;
    
    try {
      await _audioPlayer.play(
        AssetSource('sounds/click.mp3'),
        volume: 0.5,
      );
    } catch (e) {
      // Ignore errors for click sound
    }
  }

  Future<void> _playSystemSound() async {
    try {
      await SystemSound.play(SystemSoundType.alert);
    } catch (_) {
      // Ignore system sound errors
    }
  }

  /// Triggers haptic feedback for timer completion.
  Future<void> vibrateOnComplete() async {
    if (!_vibrationEnabled) return;
    
    try {
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 200));
      await HapticFeedback.heavyImpact();
      await Future.delayed(const Duration(milliseconds: 200));
      await HapticFeedback.heavyImpact();
    } catch (e) {
      logDebug('Vibration error: $e');
    }
  }

  /// Triggers light haptic feedback for button press.
  Future<void> vibrateOnPress() async {
    if (!_vibrationEnabled) return;
    
    try {
      await HapticFeedback.lightImpact();
    } catch (_) {
      // Ignore haptic errors
    }
  }

  /// Triggers medium haptic feedback.
  Future<void> vibrateMedium() async {
    if (!_vibrationEnabled) return;
    
    try {
      await HapticFeedback.mediumImpact();
    } catch (_) {
      // Ignore haptic errors
    }
  }

  /// Disposes the audio player.
  void dispose() {
    _audioPlayer.dispose();
  }
}
