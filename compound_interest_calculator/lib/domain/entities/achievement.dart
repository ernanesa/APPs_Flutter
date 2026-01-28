import 'package:equatable/equatable.dart';

enum AchievementCategory { calculations, streak, amounts, special }

class Achievement extends Equatable {
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
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id,
      titleKey: titleKey,
      descriptionKey: descriptionKey,
      icon: icon,
      category: category,
      requirement: requirement,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        titleKey,
        descriptionKey,
        icon,
        category,
        requirement,
        isUnlocked,
        unlockedAt,
      ];
}

/// Default achievements for the app
class DefaultAchievements {
  static const List<Achievement> all = [
    // Calculations
    Achievement(
      id: 'first_calc',
      titleKey: 'achievementFirstCalc',
      descriptionKey: 'achievementFirstCalcDesc',
      icon: '🎯',
      category: AchievementCategory.calculations,
      requirement: 1,
    ),
    Achievement(
      id: 'calc_10',
      titleKey: 'achievementCalc10',
      descriptionKey: 'achievementCalc10Desc',
      icon: '🔟',
      category: AchievementCategory.calculations,
      requirement: 10,
    ),
    Achievement(
      id: 'calc_50',
      titleKey: 'achievementCalc50',
      descriptionKey: 'achievementCalc50Desc',
      icon: '📊',
      category: AchievementCategory.calculations,
      requirement: 50,
    ),
    Achievement(
      id: 'calc_100',
      titleKey: 'achievementCalc100',
      descriptionKey: 'achievementCalc100Desc',
      icon: '💯',
      category: AchievementCategory.calculations,
      requirement: 100,
    ),
    
    // Streaks
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
      icon: '⭐',
      category: AchievementCategory.streak,
      requirement: 7,
    ),
    Achievement(
      id: 'streak_30',
      titleKey: 'achievementStreak30',
      descriptionKey: 'achievementStreak30Desc',
      icon: '🏆',
      category: AchievementCategory.streak,
      requirement: 30,
    ),
    
    // Amounts
    Achievement(
      id: 'million',
      titleKey: 'achievementMillion',
      descriptionKey: 'achievementMillionDesc',
      icon: '💰',
      category: AchievementCategory.amounts,
      requirement: 1000000,
    ),
    Achievement(
      id: 'ten_million',
      titleKey: 'achievementTenMillion',
      descriptionKey: 'achievementTenMillionDesc',
      icon: '💎',
      category: AchievementCategory.amounts,
      requirement: 10000000,
    ),
    
    // Special
    Achievement(
      id: 'long_term',
      titleKey: 'achievementLongTerm',
      descriptionKey: 'achievementLongTermDesc',
      icon: '⏳',
      category: AchievementCategory.special,
      requirement: 120, // 10 years
    ),
  ];
}
