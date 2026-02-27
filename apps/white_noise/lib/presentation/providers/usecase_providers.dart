import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecases/mix_sounds_usecase.dart';
import '../../domain/usecases/play_sound_usecase.dart';
import '../../domain/usecases/set_timer_usecase.dart';
import '../../domain/usecases/track_achievements_usecase.dart';
import '../../domain/usecases/update_streak_usecase.dart';
import 'repository_providers.dart';

final playSoundUseCaseProvider = Provider<PlaySoundUseCase>((ref) {
  return PlaySoundUseCase(
    soundRepository: ref.watch(soundRepositoryProvider),
    achievementRepository: ref.watch(achievementRepositoryProvider),
    streakRepository: ref.watch(streakRepositoryProvider),
  );
});

final mixSoundsUseCaseProvider = Provider<MixSoundsUseCase>((ref) {
  return MixSoundsUseCase(
    soundRepository: ref.watch(soundRepositoryProvider),
    mixRepository: ref.watch(mixRepositoryProvider),
    achievementRepository: ref.watch(achievementRepositoryProvider),
    streakRepository: ref.watch(streakRepositoryProvider),
  );
});

final setTimerUseCaseProvider = Provider<SetTimerUseCase>((ref) {
  return SetTimerUseCase(
    settingsRepository: ref.watch(settingsRepositoryProvider),
    soundRepository: ref.watch(soundRepositoryProvider),
    mixRepository: ref.watch(mixRepositoryProvider),
  );
});

final trackAchievementsUseCaseProvider = Provider<TrackAchievementsUseCase>((
  ref,
) {
  return TrackAchievementsUseCase(
    achievementRepository: ref.watch(achievementRepositoryProvider),
    streakRepository: ref.watch(streakRepositoryProvider),
  );
});

final updateStreakUseCaseProvider = Provider<UpdateStreakUseCase>((ref) {
  return UpdateStreakUseCase(
    streakRepository: ref.watch(streakRepositoryProvider),
  );
});
