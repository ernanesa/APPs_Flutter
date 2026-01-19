import '../entities/timer_entity.dart';
import '../repositories/settings_repository.dart';
import '../repositories/sound_repository.dart';
import '../repositories/mix_repository.dart';

/// Use case for setting auto-stop timer
/// IMPORTANT: For children's sleep - stop sounds after they fall asleep
class SetTimerUseCase {
  final SettingsRepository settingsRepository;
  final SoundRepository soundRepository;
  final MixRepository mixRepository;

  SetTimerUseCase({
    required this.settingsRepository,
    required this.soundRepository,
    required this.mixRepository,
  });

  /// Set timer duration and enable/disable
  Future<TimerResult> setTimer({
    required Duration duration,
    required bool enabled,
    bool fadeOut = true,
  }) async {
    try {
      final timer = TimerEntity(
        duration: duration,
        isEnabled: enabled,
        fadeOut: fadeOut,
      );

      await settingsRepository.saveTimerSettings(timer);

      return TimerResult.success(timer);
    } catch (e) {
      return TimerResult.failure('Failed to set timer: $e');
    }
  }

  /// Quick set with common duration
  Future<TimerResult> quickSet(Duration duration) async {
    return setTimer(
      duration: duration,
      enabled: true,
      fadeOut: true,
    );
  }

  /// Disable timer
  Future<TimerResult> disableTimer() async {
    try {
      final currentTimer = await settingsRepository.getTimerSettings();
      final disabledTimer = currentTimer.copyWith(isEnabled: false);
      await settingsRepository.saveTimerSettings(disabledTimer);

      return TimerResult.success(disabledTimer);
    } catch (e) {
      return TimerResult.failure('Failed to disable timer: $e');
    }
  }

  /// Get current timer settings
  Future<TimerEntity> getCurrentTimer() async {
    return await settingsRepository.getTimerSettings();
  }

  /// Execute timer completion (called by timer service)
  Future<void> onTimerComplete({required bool fadeOut}) async {
    if (fadeOut) {
      // Gradually reduce volume (handled by audio service)
      await Future.delayed(const Duration(seconds: 5));
    }

    // Stop all sounds
    await soundRepository.stopAll();

    // Stop mix if playing
    final isMixPlaying = await mixRepository.isMixPlaying();
    if (isMixPlaying) {
      await mixRepository.stopMix();
    }
  }
}

/// Result of timer operation
class TimerResult {
  final bool isSuccess;
  final TimerEntity? timer;
  final String? errorMessage;

  TimerResult._({
    required this.isSuccess,
    this.timer,
    this.errorMessage,
  });

  factory TimerResult.success(TimerEntity timer) {
    return TimerResult._(
      isSuccess: true,
      timer: timer,
    );
  }

  factory TimerResult.failure(String message) {
    return TimerResult._(
      isSuccess: false,
      errorMessage: message,
    );
  }
}
