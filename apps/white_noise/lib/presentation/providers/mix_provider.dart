import 'package:core_logic/core_logic.dart';
import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/timer_entity.dart';
import '../../domain/entities/mix_entity.dart';
import '../../domain/usecases/mix_sounds_usecase.dart';
import '../../domain/usecases/set_timer_usecase.dart';
import '../../domain/usecases/track_achievements_usecase.dart';
import '../../domain/usecases/update_streak_usecase.dart';

import 'usecase_providers.dart';

class MixState {
  final MixEntity mix;
  final bool isPlaying;
  final bool isLoading;
  final String? errorMessage;

  const MixState({
    required this.mix,
    this.isPlaying = false,
    this.isLoading = false,
    this.errorMessage,
  });

  MixState copyWith({
    MixEntity? mix,
    bool? isPlaying,
    bool? isLoading,
    String? errorMessage,
  }) {
    return MixState(
      mix: mix ?? this.mix,
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  factory MixState.initial() {
    return const MixState(mix: MixEntity(sounds: []));
  }
}

class MixController extends StateNotifier<MixState> {
  final MixSoundsUseCase _mixSoundsUseCase;
  final SetTimerUseCase _setTimerUseCase;
  final TrackAchievementsUseCase _trackAchievementsUseCase;
  final UpdateStreakUseCase _updateStreakUseCase;
  Timer? _autoStopTimer;

  MixController({
    required MixSoundsUseCase mixSoundsUseCase,
    required SetTimerUseCase setTimerUseCase,
    required TrackAchievementsUseCase trackAchievementsUseCase,
    required UpdateStreakUseCase updateStreakUseCase,
  }) : _mixSoundsUseCase = mixSoundsUseCase,
       _setTimerUseCase = setTimerUseCase,
       _trackAchievementsUseCase = trackAchievementsUseCase,
       _updateStreakUseCase = updateStreakUseCase,
       super(MixState.initial()) {
    _load();
  }

  Future<void> _load() async {
    final mix = await _mixSoundsUseCase.mixRepository.getCurrentMix();
    state = state.copyWith(mix: mix);
  }

  Future<void> toggleSound(String soundId) async {
    if (state.mix.containsSound(soundId)) {
      final result = await _mixSoundsUseCase.removeSound(soundId);
      if (result.isSuccess && result.mix != null) {
        state = state.copyWith(mix: result.mix!, errorMessage: null);
      } else {
        state = state.copyWith(errorMessage: result.errorMessage);
      }
      return;
    }

    final result = await _mixSoundsUseCase.addSound(soundId, volume: 0.7);
    if (result.isSuccess && result.mix != null) {
      state = state.copyWith(mix: result.mix!, errorMessage: null);
    } else {
      state = state.copyWith(errorMessage: result.errorMessage);
    }
  }

  Future<void> updateVolume(String soundId, double volume) async {
    final result = await _mixSoundsUseCase.updateVolume(soundId, volume);
    if (result.isSuccess && result.mix != null) {
      state = state.copyWith(mix: result.mix!, errorMessage: null);
    } else {
      state = state.copyWith(errorMessage: result.errorMessage);
    }
  }

  Future<void> playMix() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    final result = await _mixSoundsUseCase.playMix();
    if (!result.isSuccess) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: result.errorMessage,
      );
      return;
    }

    final mix = result.mix ?? state.mix;
    state = state.copyWith(mix: mix, isPlaying: true, isLoading: false);

    await _trackAchievementsUseCase.checkAndUnlockAll();
    await _updateStreakUseCase.updateStreak();

    final now = DateTime.now();
    if (now.hour >= 0 && now.hour < 5) {
      await _trackAchievementsUseCase.unlockNightOwl();
    }

    final timer = await _setTimerUseCase.getCurrentTimer();
    if (timer.isEnabled) {
      _scheduleAutoStop(timer);
    }

    AdService.incrementActionAndShowIfNeeded();
  }

  Future<void> stopMix() async {
    _autoStopTimer?.cancel();
    await _mixSoundsUseCase.mixRepository.stopMix();
    state = state.copyWith(isPlaying: false);
  }

  Future<void> clearMix() async {
    _autoStopTimer?.cancel();
    final result = await _mixSoundsUseCase.clearMix();
    if (result.isSuccess && result.mix != null) {
      state = state.copyWith(
        mix: result.mix!,
        isPlaying: false,
        errorMessage: null,
      );
    }
  }

  void _scheduleAutoStop(TimerEntity timer) {
    _autoStopTimer?.cancel();
    _autoStopTimer = Timer(timer.duration, () {
      _setTimerUseCase.onTimerComplete(fadeOut: timer.fadeOut);
      state = state.copyWith(isPlaying: false);
    });
  }

  @override
  void dispose() {
    _autoStopTimer?.cancel();
    super.dispose();
  }
}

final mixProvider = StateNotifierProvider<MixController, MixState>((ref) {
  return MixController(
    mixSoundsUseCase: ref.watch(mixSoundsUseCaseProvider),
    setTimerUseCase: ref.watch(setTimerUseCaseProvider),
    trackAchievementsUseCase: ref.watch(trackAchievementsUseCaseProvider),
    updateStreakUseCase: ref.watch(updateStreakUseCaseProvider),
  );
});
