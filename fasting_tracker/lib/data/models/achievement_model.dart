import 'dart:convert';
import '../../domain/entities/achievement.dart';

/// Data model for Achievement with JSON serialization
class AchievementModel extends Achievement {
  const AchievementModel({
    required super.id,
    required super.titleKey,
    required super.descriptionKey,
    required super.icon,
    required super.category,
    required super.requirement,
    super.isUnlocked,
    super.unlockedAt,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    return AchievementModel(
      id: json['id'] as String,
      titleKey: json['titleKey'] as String,
      descriptionKey: json['descriptionKey'] as String,
      icon: json['icon'] as String,
      category: AchievementCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => AchievementCategory.sessions,
      ),
      requirement: json['requirement'] as int,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleKey': titleKey,
      'descriptionKey': descriptionKey,
      'icon': icon,
      'category': category.name,
      'requirement': requirement,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
    };
  }

  factory AchievementModel.fromEntity(Achievement entity) {
    return AchievementModel(
      id: entity.id,
      titleKey: entity.titleKey,
      descriptionKey: entity.descriptionKey,
      icon: entity.icon,
      category: entity.category,
      requirement: entity.requirement,
      isUnlocked: entity.isUnlocked,
      unlockedAt: entity.unlockedAt,
    );
  }

  static String encodeMap(Map<String, bool> unlockStatus) {
    return jsonEncode(unlockStatus);
  }

  static Map<String, dynamic> decodeMap(String json) {
    return jsonDecode(json);
  }
}
