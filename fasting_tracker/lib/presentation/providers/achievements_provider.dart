import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/achievement.dart';
import '../../data/repositories/achievements_repository_impl.dart';
import 'shared_prefs_provider.dart';
import 'streak_provider.dart';

/// Achievements state
class AchievementsState {
  final List<Achievement> achievements;
  final bool isLoading;

  const AchievementsState({
    this.achievements = const [],
    this.isLoading = false,
  });

  int get unlockedCount => achievements.where((a) => a.isUnlocked).length;
  int get totalCount => achievements.length;
  double get progress => totalCount > 0 ? unlockedCount / totalCount : 0;

  AchievementsState copyWith({
    List<Achievement>? achievements,
    bool? isLoading,
  }) {
    return AchievementsState(
      achievements: achievements ?? this.achievements,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Achievements notifier
class AchievementsNotifier extends StateNotifier<AchievementsState> {
  final AchievementsRepositoryImpl _repository;
  final Ref _ref;

  AchievementsNotifier(this._repository, this._ref) : super(const AchievementsState()) {
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    state = state.copyWith(isLoading: true);
    final achievements = await _repository.getAchievements();
    state = state.copyWith(achievements: achievements, isLoading: false);
  }

  Future<List<Achievement>> checkAndUnlock() async {
    final streakData = _ref.read(streakProvider);
    
    final newlyUnlocked = await _repository.checkAndUnlock(
      totalFasts: streakData.totalCompletedFasts,
      currentStreak: streakData.currentStreak,
      totalHours: streakData.totalFastingHours.round(),
      longestFastHours: 0, // TODO: Track longest single fast
    );

    if (newlyUnlocked.isNotEmpty) {
      await _loadAchievements();
    }

    return newlyUnlocked;
  }

  Future<void> reset() async {
    await _repository.resetAchievements();
    await _loadAchievements();
  }
}

/// Achievements provider
final achievementsProvider = StateNotifierProvider<AchievementsNotifier, AchievementsState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AchievementsNotifier(AchievementsRepositoryImpl(prefs), ref);
});
