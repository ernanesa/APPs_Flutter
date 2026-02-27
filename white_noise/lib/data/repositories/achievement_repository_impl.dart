import '../../domain/entities/achievement_entity.dart';
import '../../domain/repositories/achievement_repository.dart';
import '../datasources/local_data_source.dart';
import '../models/achievement_dto.dart';

/// Implementation of AchievementRepository using LocalDataSource
class AchievementRepositoryImpl implements AchievementRepository {
  final LocalDataSource _localDataSource;

  // Use default achievements from entity

  AchievementRepositoryImpl({required LocalDataSource localDataSource})
    : _localDataSource = localDataSource;

  @override
  Future<List<AchievementEntity>> getAllAchievements() async {
    final json = await _localDataSource.getJson(
      LocalDataSource.keyAchievements,
    );

    if (json == null) {
      // Initialize with defaults
      await _saveAchievements(DefaultAchievements.all);
      return DefaultAchievements.all;
    }

    final List<dynamic> list = json['achievements'] as List<dynamic>;
    return list.map((item) {
      final dto = AchievementDto.fromJson(item as Map<String, dynamic>);
      return dto.toEntity();
    }).toList();
  }

  @override
  Future<List<AchievementEntity>> getUnlockedAchievements() async {
    final all = await getAllAchievements();
    return all.where((a) => a.isUnlocked).toList();
  }

  @override
  Future<List<AchievementEntity>> getLockedAchievements() async {
    final all = await getAllAchievements();
    return all.where((a) => !a.isUnlocked).toList();
  }

  @override
  Future<List<AchievementEntity>> getAchievementsByCategory(
    AchievementCategory category,
  ) async {
    final all = await getAllAchievements();
    return all.where((a) => a.category == category).toList();
  }

  @override
  Future<AchievementEntity> unlockAchievement(String achievementId) async {
    final all = await getAllAchievements();
    final index = all.indexWhere((a) => a.id == achievementId);

    if (index == -1) {
      throw Exception('Achievement not found: $achievementId');
    }

    if (all[index].isUnlocked) {
      return all[index]; // Already unlocked
    }

    final unlocked = all[index].copyWith(
      isUnlocked: true,
      unlockedAt: DateTime.now(),
    );

    all[index] = unlocked;
    await _saveAchievements(all);

    return unlocked;
  }

  @override
  Future<bool> isUnlocked(String achievementId) async {
    final all = await getAllAchievements();
    final achievement = all.firstWhere(
      (a) => a.id == achievementId,
      orElse: () => throw Exception('Achievement not found'),
    );
    return achievement.isUnlocked;
  }

  @override
  Future<int> getTotalSessions() async {
    final json = await _localDataSource.getJson(
      LocalDataSource.keyAchievements,
    );
    return (json?['totalSessions'] as int?) ?? 0;
  }

  @override
  Future<void> incrementSessions() async {
    final current = await getTotalSessions();
    await _updateStats({'totalSessions': current + 1});
  }

  @override
  Future<int> getTotalListeningTime() async {
    final json = await _localDataSource.getJson(
      LocalDataSource.keyAchievements,
    );
    return (json?['totalListeningTime'] as int?) ?? 0;
  }

  @override
  Future<void> addListeningTime(int minutes) async {
    final current = await getTotalListeningTime();
    await _updateStats({'totalListeningTime': current + minutes});
  }

  @override
  Future<int> getUniqueSoundsPlayed() async {
    final json = await _localDataSource.getJson(
      LocalDataSource.keyAchievements,
    );
    final List<dynamic>? soundsList =
        json?['uniqueSoundsPlayed'] as List<dynamic>?;
    return soundsList?.length ?? 0;
  }

  @override
  Future<void> recordSoundPlayed(String soundId) async {
    final json =
        await _localDataSource.getJson(LocalDataSource.keyAchievements) ?? {};
    final List<dynamic> soundsList =
        (json['uniqueSoundsPlayed'] as List<dynamic>?) ?? [];

    if (!soundsList.contains(soundId)) {
      soundsList.add(soundId);
      await _updateStats({'uniqueSoundsPlayed': soundsList});
    }
  }

  @override
  Future<int> getThreeSoundMixCount() async {
    final json = await _localDataSource.getJson(
      LocalDataSource.keyAchievements,
    );
    return (json?['threeSoundMixCount'] as int?) ?? 0;
  }

  @override
  Future<void> incrementThreeSoundMix() async {
    final current = await getThreeSoundMixCount();
    await _updateStats({'threeSoundMixCount': current + 1});
  }

  // Private helper methods
  Future<void> _saveAchievements(List<AchievementEntity> achievements) async {
    final json =
        await _localDataSource.getJson(LocalDataSource.keyAchievements) ?? {};
    json['achievements'] =
        achievements.map((a) {
          final dto = AchievementDto.fromEntity(a);
          return dto.toJson();
        }).toList();
    await _localDataSource.setJson(LocalDataSource.keyAchievements, json);
  }

  Future<void> _updateStats(Map<String, dynamic> updates) async {
    final json =
        await _localDataSource.getJson(LocalDataSource.keyAchievements) ?? {};
    json.addAll(updates);
    await _localDataSource.setJson(LocalDataSource.keyAchievements, json);
  }
}
