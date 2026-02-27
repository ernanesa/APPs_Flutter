/// Entity representing an achievement for gamification
class AchievementEntity {
  final String id;
  final String titleKey; // i18n key
  final String descriptionKey; // i18n key
  final AchievementCategory category;
  final int requirement;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const AchievementEntity({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.category,
    required this.requirement,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  AchievementEntity copyWith({
    String? id,
    String? titleKey,
    String? descriptionKey,
    AchievementCategory? category,
    int? requirement,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return AchievementEntity(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      category: category ?? this.category,
      requirement: requirement ?? this.requirement,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  /// Unlock achievement
  AchievementEntity unlock() {
    return copyWith(isUnlocked: true, unlockedAt: DateTime.now());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AchievementEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum AchievementCategory {
  sessions, // Number of listening sessions
  time, // Total listening time
  streak, // Consecutive days
  mixing, // Sound mixing usage
  special, // Special achievements
}

/// Default achievements for the app
class DefaultAchievements {
  // Sessions
  static const firstSession = AchievementEntity(
    id: 'first_session',
    titleKey: 'achievementFirstSession',
    descriptionKey: 'achievementFirstSessionDesc',
    category: AchievementCategory.sessions,
    requirement: 1,
  );

  static const sessions10 = AchievementEntity(
    id: 'sessions_10',
    titleKey: 'achievement10Sessions',
    descriptionKey: 'achievement10SessionsDesc',
    category: AchievementCategory.sessions,
    requirement: 10,
  );

  static const sessions50 = AchievementEntity(
    id: 'sessions_50',
    titleKey: 'achievement50Sessions',
    descriptionKey: 'achievement50SessionsDesc',
    category: AchievementCategory.sessions,
    requirement: 50,
  );

  static const sessions100 = AchievementEntity(
    id: 'sessions_100',
    titleKey: 'achievement100Sessions',
    descriptionKey: 'achievement100SessionsDesc',
    category: AchievementCategory.sessions,
    requirement: 100,
  );

  static const sessions500 = AchievementEntity(
    id: 'sessions_500',
    titleKey: 'achievement500Sessions',
    descriptionKey: 'achievement500SessionsDesc',
    category: AchievementCategory.sessions,
    requirement: 500,
  );

  // Time-based
  static const time1Hour = AchievementEntity(
    id: 'time_1h',
    titleKey: 'achievement1Hour',
    descriptionKey: 'achievement1HourDesc',
    category: AchievementCategory.time,
    requirement: 60, // minutes
  );

  static const time10Hours = AchievementEntity(
    id: 'time_10h',
    titleKey: 'achievement10Hours',
    descriptionKey: 'achievement10HoursDesc',
    category: AchievementCategory.time,
    requirement: 600, // minutes
  );

  static const time100Hours = AchievementEntity(
    id: 'time_100h',
    titleKey: 'achievement100Hours',
    descriptionKey: 'achievement100HoursDesc',
    category: AchievementCategory.time,
    requirement: 6000, // minutes
  );

  // Streaks
  static const streak3 = AchievementEntity(
    id: 'streak_3',
    titleKey: 'achievementStreak3',
    descriptionKey: 'achievementStreak3Desc',
    category: AchievementCategory.streak,
    requirement: 3,
  );

  static const streak7 = AchievementEntity(
    id: 'streak_7',
    titleKey: 'achievementStreak7',
    descriptionKey: 'achievementStreak7Desc',
    category: AchievementCategory.streak,
    requirement: 7,
  );

  static const streak30 = AchievementEntity(
    id: 'streak_30',
    titleKey: 'achievementStreak30',
    descriptionKey: 'achievementStreak30Desc',
    category: AchievementCategory.streak,
    requirement: 30,
  );

  // Mixing
  static const firstMix = AchievementEntity(
    id: 'first_mix',
    titleKey: 'achievementFirstMix',
    descriptionKey: 'achievementFirstMixDesc',
    category: AchievementCategory.mixing,
    requirement: 1,
  );

  static const masterMixer = AchievementEntity(
    id: 'master_mixer',
    titleKey: 'achievementMasterMixer',
    descriptionKey: 'achievementMasterMixerDesc',
    category: AchievementCategory.mixing,
    requirement: 3, // Mix 3 sounds simultaneously
  );

  // Special
  static const nightOwl = AchievementEntity(
    id: 'night_owl',
    titleKey: 'achievementNightOwl',
    descriptionKey: 'achievementNightOwlDesc',
    category: AchievementCategory.special,
    requirement: 1, // Use app between 10 PM - 6 AM
  );

  static const allSounds = AchievementEntity(
    id: 'all_sounds',
    titleKey: 'achievementAllSounds',
    descriptionKey: 'achievementAllSoundsDesc',
    category: AchievementCategory.special,
    requirement: 12, // Try all 12 sounds
  );

  /// All achievements (14 total)
  static const List<AchievementEntity> all = [
    // Sessions (4)
    firstSession,
    sessions10,
    sessions50,
    sessions100,
    sessions500,
    // Time (3)
    time1Hour,
    time10Hours,
    time100Hours,
    // Streaks (3)
    streak3,
    streak7,
    streak30,
    // Mixing (2)
    firstMix,
    masterMixer,
    // Special (2)
    nightOwl,
    allSounds,
  ];

  /// Get achievements by category
  static List<AchievementEntity> getByCategory(AchievementCategory category) {
    return all
        .where((achievement) => achievement.category == category)
        .toList();
  }

  /// Find achievement by ID
  static AchievementEntity? findById(String id) {
    try {
      return all.firstWhere((achievement) => achievement.id == id);
    } catch (_) {
      return null;
    }
  }
}
