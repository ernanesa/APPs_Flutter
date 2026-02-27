import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/audio_player_service.dart';
import '../../data/datasources/local_data_source.dart';
import '../../data/repositories/achievement_repository_impl.dart';
import '../../data/repositories/mix_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/repositories/sound_repository_impl.dart';
import '../../data/repositories/streak_repository_impl.dart';
import '../../domain/repositories/achievement_repository.dart';
import '../../domain/repositories/mix_repository.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/repositories/sound_repository.dart';
import '../../domain/repositories/streak_repository.dart';
import 'package:core_logic/core_logic.dart';

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalDataSource(prefs);
});

final audioPlayerServiceProvider = Provider<AudioPlayerService>((ref) {
  final service = AudioPlayerService();
  ref.onDispose(service.dispose);
  return service;
});

final soundRepositoryProvider = Provider<SoundRepository>((ref) {
  return SoundRepositoryImpl(
    ref.watch(audioPlayerServiceProvider),
    ref.watch(localDataSourceProvider),
  );
});

final mixRepositoryProvider = Provider<MixRepository>((ref) {
  return MixRepositoryImpl(
    localDataSource: ref.watch(localDataSourceProvider),
    audioPlayerService: ref.watch(audioPlayerServiceProvider),
  );
});

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  return AchievementRepositoryImpl(
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

final streakRepositoryProvider = Provider<StreakRepository>((ref) {
  return StreakRepositoryImpl(
    localDataSource: ref.watch(localDataSourceProvider),
  );
});
