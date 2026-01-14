import 'package:flutter/material.dart';

/// Represents an achievement/badge that can be unlocked.
class Achievement {
  final String id;
  final String titleKey; // i18n key
  final String descriptionKey; // i18n key
  final IconData icon;
  final Color color;
  final AchievementCategory category;
  final int targetValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const Achievement({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.icon,
    required this.color,
    required this.category,
    required this.targetValue,
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
      color: color,
      category: category,
      targetValue: targetValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }
}

/// Categories of achievements.
enum AchievementCategory {
  sessions,
  streak,
  time,
  special,
}

/// Predefined achievements list.
class Achievements {
  static List<Achievement> get all => [
    // Session-based achievements
    const Achievement(
      id: 'first_session',
      titleKey: 'achievementFirstSession',
      descriptionKey: 'achievementFirstSessionDesc',
      icon: Icons.play_circle_filled,
      color: Colors.green,
      category: AchievementCategory.sessions,
      targetValue: 1,
    ),
    const Achievement(
      id: 'sessions_10',
      titleKey: 'achievementSessions10',
      descriptionKey: 'achievementSessions10Desc',
      icon: Icons.star,
      color: Colors.blue,
      category: AchievementCategory.sessions,
      targetValue: 10,
    ),
    const Achievement(
      id: 'sessions_50',
      titleKey: 'achievementSessions50',
      descriptionKey: 'achievementSessions50Desc',
      icon: Icons.star_half,
      color: Colors.purple,
      category: AchievementCategory.sessions,
      targetValue: 50,
    ),
    const Achievement(
      id: 'sessions_100',
      titleKey: 'achievementSessions100',
      descriptionKey: 'achievementSessions100Desc',
      icon: Icons.stars,
      color: Colors.amber,
      category: AchievementCategory.sessions,
      targetValue: 100,
    ),
    const Achievement(
      id: 'sessions_500',
      titleKey: 'achievementSessions500',
      descriptionKey: 'achievementSessions500Desc',
      icon: Icons.emoji_events,
      color: Colors.orange,
      category: AchievementCategory.sessions,
      targetValue: 500,
    ),
    
    // Streak-based achievements
    const Achievement(
      id: 'streak_3',
      titleKey: 'achievementStreak3',
      descriptionKey: 'achievementStreak3Desc',
      icon: Icons.local_fire_department,
      color: Colors.deepOrange,
      category: AchievementCategory.streak,
      targetValue: 3,
    ),
    const Achievement(
      id: 'streak_7',
      titleKey: 'achievementStreak7',
      descriptionKey: 'achievementStreak7Desc',
      icon: Icons.local_fire_department,
      color: Colors.red,
      category: AchievementCategory.streak,
      targetValue: 7,
    ),
    const Achievement(
      id: 'streak_30',
      titleKey: 'achievementStreak30',
      descriptionKey: 'achievementStreak30Desc',
      icon: Icons.whatshot,
      color: Colors.redAccent,
      category: AchievementCategory.streak,
      targetValue: 30,
    ),
    
    // Time-based achievements
    const Achievement(
      id: 'time_1h',
      titleKey: 'achievementTime1h',
      descriptionKey: 'achievementTime1hDesc',
      icon: Icons.timer,
      color: Colors.teal,
      category: AchievementCategory.time,
      targetValue: 60, // minutes
    ),
    const Achievement(
      id: 'time_10h',
      titleKey: 'achievementTime10h',
      descriptionKey: 'achievementTime10hDesc',
      icon: Icons.hourglass_bottom,
      color: Colors.indigo,
      category: AchievementCategory.time,
      targetValue: 600, // minutes
    ),
    const Achievement(
      id: 'time_100h',
      titleKey: 'achievementTime100h',
      descriptionKey: 'achievementTime100hDesc',
      icon: Icons.hourglass_full,
      color: Colors.pink,
      category: AchievementCategory.time,
      targetValue: 6000, // minutes
    ),
    
    // Special achievements
    const Achievement(
      id: 'early_bird',
      titleKey: 'achievementEarlyBird',
      descriptionKey: 'achievementEarlyBirdDesc',
      icon: Icons.wb_sunny,
      color: Colors.yellow,
      category: AchievementCategory.special,
      targetValue: 1, // Complete session before 7 AM
    ),
    const Achievement(
      id: 'night_owl',
      titleKey: 'achievementNightOwl',
      descriptionKey: 'achievementNightOwlDesc',
      icon: Icons.nightlight_round,
      color: Colors.deepPurple,
      category: AchievementCategory.special,
      targetValue: 1, // Complete session after 10 PM
    ),
    const Achievement(
      id: 'weekend_warrior',
      titleKey: 'achievementWeekendWarrior',
      descriptionKey: 'achievementWeekendWarriorDesc',
      icon: Icons.weekend,
      color: Colors.cyan,
      category: AchievementCategory.special,
      targetValue: 5, // 5 sessions on weekend
    ),
  ];
}
