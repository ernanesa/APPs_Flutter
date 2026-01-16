/// Represents an achievement/badge in the app
class Achievement {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String icon;
  final AchievementCategory category;
  final int requirement;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.category,
    required this.requirement,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Achievement copyWith({
    String? id,
    String? titleKey,
    String? descriptionKey,
    String? icon,
    AchievementCategory? category,
    int? requirement,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      requirement: requirement ?? this.requirement,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  /// Default achievements for fasting tracker
  static const List<Achievement> defaultAchievements = [
    // Session achievements
    Achievement(
      id: 'first_fast',
      titleKey: 'achievementFirstFast',
      descriptionKey: 'achievementFirstFastDesc',
      icon: '🎯',
      category: AchievementCategory.sessions,
      requirement: 1,
    ),
    Achievement(
      id: 'fasts_10',
      titleKey: 'achievement10Fasts',
      descriptionKey: 'achievement10FastsDesc',
      icon: '🌟',
      category: AchievementCategory.sessions,
      requirement: 10,
    ),
    Achievement(
      id: 'fasts_25',
      titleKey: 'achievement25Fasts',
      descriptionKey: 'achievement25FastsDesc',
      icon: '💎',
      category: AchievementCategory.sessions,
      requirement: 25,
    ),
    Achievement(
      id: 'fasts_50',
      titleKey: 'achievement50Fasts',
      descriptionKey: 'achievement50FastsDesc',
      icon: '🏆',
      category: AchievementCategory.sessions,
      requirement: 50,
    ),
    Achievement(
      id: 'fasts_100',
      titleKey: 'achievement100Fasts',
      descriptionKey: 'achievement100FastsDesc',
      icon: '👑',
      category: AchievementCategory.sessions,
      requirement: 100,
    ),
    // Streak achievements
    Achievement(
      id: 'streak_3',
      titleKey: 'achievementStreak3',
      descriptionKey: 'achievementStreak3Desc',
      icon: '🔥',
      category: AchievementCategory.streak,
      requirement: 3,
    ),
    Achievement(
      id: 'streak_7',
      titleKey: 'achievementStreak7',
      descriptionKey: 'achievementStreak7Desc',
      icon: '🔥🔥',
      category: AchievementCategory.streak,
      requirement: 7,
    ),
    Achievement(
      id: 'streak_14',
      titleKey: 'achievementStreak14',
      descriptionKey: 'achievementStreak14Desc',
      icon: '🔥🔥🔥',
      category: AchievementCategory.streak,
      requirement: 14,
    ),
    Achievement(
      id: 'streak_30',
      titleKey: 'achievementStreak30',
      descriptionKey: 'achievementStreak30Desc',
      icon: '🌋',
      category: AchievementCategory.streak,
      requirement: 30,
    ),
    // Time achievements (total hours)
    Achievement(
      id: 'hours_24',
      titleKey: 'achievement24Hours',
      descriptionKey: 'achievement24HoursDesc',
      icon: '⏱️',
      category: AchievementCategory.time,
      requirement: 24,
    ),
    Achievement(
      id: 'hours_100',
      titleKey: 'achievement100Hours',
      descriptionKey: 'achievement100HoursDesc',
      icon: '⌛',
      category: AchievementCategory.time,
      requirement: 100,
    ),
    Achievement(
      id: 'hours_500',
      titleKey: 'achievement500Hours',
      descriptionKey: 'achievement500HoursDesc',
      icon: '🕐',
      category: AchievementCategory.time,
      requirement: 500,
    ),
    // Special achievements
    Achievement(
      id: 'ketosis_reached',
      titleKey: 'achievementKetosis',
      descriptionKey: 'achievementKetosisDesc',
      icon: '⚡',
      category: AchievementCategory.special,
      requirement: 18,
    ),
    Achievement(
      id: 'autophagy_reached',
      titleKey: 'achievementAutophagy',
      descriptionKey: 'achievementAutophagyDesc',
      icon: '🧬',
      category: AchievementCategory.special,
      requirement: 48,
    ),
  ];
}

enum AchievementCategory {
  sessions,
  streak,
  time,
  special,
}
