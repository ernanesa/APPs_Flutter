import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/achievement_entity.dart';
import '../../domain/usecases/track_achievements_usecase.dart';
import 'usecase_providers.dart';

class AchievementsState {
  final List<AchievementEntity> achievements;
  final bool isLoading;
  final String? errorMessage;

  const AchievementsState({
    required this.achievements,
    this.isLoading = false,
    this.errorMessage,
  });

  AchievementsState copyWith({
    List<AchievementEntity>? achievements,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AchievementsState(
      achievements: achievements ?? this.achievements,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  factory AchievementsState.initial() {
    return const AchievementsState(achievements: [], isLoading: true);
  }
}

class AchievementsController extends StateNotifier<AchievementsState> {
  final TrackAchievementsUseCase _trackAchievementsUseCase;

  AchievementsController({
    required TrackAchievementsUseCase trackAchievementsUseCase,
  }) : _trackAchievementsUseCase = trackAchievementsUseCase,
       super(AchievementsState.initial()) {
    _load();
  }

  Future<void> _load() async {
    try {
      final achievements = await _trackAchievementsUseCase.getAllAchievements();
      state = state.copyWith(achievements: achievements, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: '$e');
    }
  }

  Future<void> refresh() async {
    await _load();
  }

  Future<List<AchievementEntity>> checkAndUnlock() async {
    final unlocked = await _trackAchievementsUseCase.checkAndUnlockAll();
    await _load();
    return unlocked;
  }
}

final achievementsProvider =
    StateNotifierProvider<AchievementsController, AchievementsState>((ref) {
      return AchievementsController(
        trackAchievementsUseCase: ref.watch(trackAchievementsUseCaseProvider),
      );
    });
