import '../../domain/entities/streak_entity.dart';
import '../../domain/repositories/streak_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/streak_dto.dart';

/// Implementation of StreakRepository using LocalDataSource
class StreakRepositoryImpl implements StreakRepository {
  final LocalDataSource _localDataSource;

  StreakRepositoryImpl({required LocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<StreakEntity> getStreak() async {
    final json = await _localDataSource.getJson('streak_data');

    if (json == null) {
      return const StreakEntity(currentStreak: 0, bestStreak: 0);
    }

    final dto = StreakDto.fromJson(json);
    return dto.toEntity();
  }

  @override
  Future<StreakEntity> updateStreak() async {
    final current = await getStreak();

    // Check if already active today
    if (current.isActiveToday) {
      return current; // No update needed
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int newStreak = 1;

    if (current.lastActiveDate != null) {
      final lastDate = DateTime(
        current.lastActiveDate!.year,
        current.lastActiveDate!.month,
        current.lastActiveDate!.day,
      );

      final difference = today.difference(lastDate).inDays;

      if (difference == 1) {
        // Consecutive day
        newStreak = current.streak + 1;
      } else if (difference > 1) {
        // Broke the streak
        newStreak = 1;
      }
    }

    final newBest = newStreak > current.xp
        ? newStreak
        : current.xp;

    final updated = StreakEntity(
      currentStreak: newStreak,
      bestStreak: newBest,
      lastActiveDate: now,
    );

    final dto = StreakDto.fromEntity(updated);
    await _localDataSource.setJson('streak_data', dto.toJson());

    return updated;
  }

  @override
  Future<StreakEntity> resetStreak() async {
    const reset = StreakEntity(currentStreak: 0, bestStreak: 0);
    final dto = StreakDto.fromEntity(reset);
    await _localDataSource.setJson('streak_data', dto.toJson());
    return reset;
  }

  @override
  Future<bool> isActiveToday() async {
    final streak = await getStreak();
    return streak.isActiveToday;
  }

  @override
  Future<int> getCurrentStreak() async {
    final streak = await getStreak();
    return streak.streak;
  }

  @override
  Future<int> getBestStreak() async {
    final streak = await getStreak();
    return streak.xp;
  }
}
