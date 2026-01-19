import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wakelock_plus/wakelock_plus.dart';

import '../../data/datasources/audio_player_service.dart';
import '../../domain/entities/timer_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/set_timer_usecase.dart';
import 'repository_providers.dart';
import 'usecase_providers.dart';

class SettingsState {
  final double globalVolume;
  final bool isDarkMode;
  final bool keepScreenOn;
  final String languageCode;
  final TimerEntity timer;
  final bool isLoading;
  final String? errorMessage;

  const SettingsState({
    required this.globalVolume,
    required this.isDarkMode,
    required this.keepScreenOn,
    required this.languageCode,
    required this.timer,
    this.isLoading = false,
    this.errorMessage,
  });

  SettingsState copyWith({
    double? globalVolume,
    bool? isDarkMode,
    bool? keepScreenOn,
    String? languageCode,
    TimerEntity? timer,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SettingsState(
      globalVolume: globalVolume ?? this.globalVolume,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      languageCode: languageCode ?? this.languageCode,
      timer: timer ?? this.timer,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  factory SettingsState.initial() {
    return const SettingsState(
      globalVolume: 0.7,
      isDarkMode: false,
      keepScreenOn: false,
      languageCode: 'en',
      timer: TimerEntity(duration: Duration(minutes: 30), isEnabled: false),
      isLoading: true,
    );
  }
}

class SettingsController extends StateNotifier<SettingsState> {
  final SettingsRepository _settingsRepository;
  final AudioPlayerService _audioService;
  final SetTimerUseCase _setTimerUseCase;

  SettingsController({
    required SettingsRepository settingsRepository,
    required AudioPlayerService audioService,
    required SetTimerUseCase setTimerUseCase,
  })  : _settingsRepository = settingsRepository,
        _audioService = audioService,
        _setTimerUseCase = setTimerUseCase,
        super(SettingsState.initial()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final volume = await _settingsRepository.getGlobalVolume();
      final isDark = await _settingsRepository.isDarkMode();
      final keepOn = await _settingsRepository.isKeepScreenOn();
      final language = await _settingsRepository.getLanguageCode();
      final timer = await _settingsRepository.getTimerSettings();

      state = state.copyWith(
        globalVolume: volume,
        isDarkMode: isDark,
        keepScreenOn: keepOn,
        languageCode: language,
        timer: timer,
        isLoading: false,
      );

      if (keepOn) {
        await WakelockPlus.enable();
      } else {
        await WakelockPlus.disable();
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load settings: $e',
      );
    }
  }

  Future<void> setGlobalVolume(double volume) async {
    final clamped = volume.clamp(0.0, 1.0);
    state = state.copyWith(globalVolume: clamped);
    await _settingsRepository.saveGlobalVolume(clamped);
    await _audioService.setGlobalVolume(clamped);
  }

  Future<void> setDarkMode(bool isDark) async {
    state = state.copyWith(isDarkMode: isDark);
    await _settingsRepository.saveDarkMode(isDark);
  }

  Future<void> setKeepScreenOn(bool keepOn) async {
    state = state.copyWith(keepScreenOn: keepOn);
    await _settingsRepository.saveKeepScreenOn(keepOn);
    if (keepOn) {
      await WakelockPlus.enable();
    } else {
      await WakelockPlus.disable();
    }
  }

  Future<void> setLanguageCode(String languageCode) async {
    state = state.copyWith(languageCode: languageCode);
    await _settingsRepository.saveLanguageCode(languageCode);
  }

  Future<void> setTimer(Duration duration, {bool enabled = true}) async {
    final result = await _setTimerUseCase.setTimer(
      duration: duration,
      enabled: enabled,
      fadeOut: true,
    );
    if (result.isSuccess && result.timer != null) {
      state = state.copyWith(timer: result.timer!);
    }
  }

  Future<void> disableTimer() async {
    final result = await _setTimerUseCase.disableTimer();
    if (result.isSuccess && result.timer != null) {
      state = state.copyWith(timer: result.timer!);
    }
  }
}

final settingsProvider = StateNotifierProvider<SettingsController, SettingsState>((ref) {
  return SettingsController(
    settingsRepository: ref.watch(settingsRepositoryProvider),
    audioService: ref.watch(audioPlayerServiceProvider),
    setTimerUseCase: ref.watch(setTimerUseCaseProvider),
  );
});
