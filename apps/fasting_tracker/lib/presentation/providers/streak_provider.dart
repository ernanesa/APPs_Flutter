import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/streak_data.dart';
import '../../data/repositories/streak_repository_impl.dart';
import 'shared_prefs_provider.dart';

/// Streak state notifier
class StreakNotifier extends StateNotifier<StreakData> {
  final StreakRepositoryImpl _repository;

  StreakNotifier(this._repository) : super(const StreakData()) {
    _loadStreak();
  }

  Future<void> _loadStreak() async {
    final data = await _repository.getStreakData();
    state = data;
  }

  Future<void> recordCompletedFast(int durationMinutes) async {
    final updated = await _repository.recordCompletedFast(durationMinutes);
    state = updated;
  }

  Future<void> reset() async {
    await _repository.resetStreak();
    state = const StreakData();
  }
}

/// Streak provider
final streakProvider = StateNotifierProvider<StreakNotifier, StreakData>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StreakNotifier(StreakRepositoryImpl(prefs));
});
