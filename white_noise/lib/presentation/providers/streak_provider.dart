import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/streak_entity.dart';
import '../../domain/usecases/update_streak_usecase.dart';
import 'usecase_providers.dart';

class StreakController extends StateNotifier<StreakEntity> {
  final UpdateStreakUseCase _updateStreakUseCase;

  StreakController({required UpdateStreakUseCase updateStreakUseCase})
    : _updateStreakUseCase = updateStreakUseCase,
      super(const StreakEntity()) {
    _load();
  }

  Future<void> _load() async {
    final streak = await _updateStreakUseCase.getCurrentStreak();
    state = streak;
  }

  Future<void> refresh() async {
    final streak = await _updateStreakUseCase.getCurrentStreak();
    state = streak;
  }

  Future<void> reset() async {
    final streak = await _updateStreakUseCase.resetStreak();
    state = streak;
  }
}

final streakProvider = StateNotifierProvider<StreakController, StreakEntity>((
  ref,
) {
  return StreakController(
    updateStreakUseCase: ref.watch(updateStreakUseCaseProvider),
  );
});
