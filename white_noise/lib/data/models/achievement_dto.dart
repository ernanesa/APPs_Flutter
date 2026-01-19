import 'package:white_noise/domain/entities/achievement_entity.dart';

/// DTO for AchievementEntity serialization (Data layer only)
class AchievementDto {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final String category; // Enum as string
  final int requirement;
  final bool isUnlocked;
  final String? unlockedAt; // DateTime as ISO8601 string

  const AchievementDto({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.category,
    required this.requirement,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  /// Convert DTO to domain entity
  AchievementEntity toEntity() {
    return AchievementEntity(
      id: id,
      titleKey: titleKey,
      descriptionKey: descriptionKey,
      category: AchievementCategory.values.firstWhere(
        (e) => e.name == category,
        orElse: () => AchievementCategory.sessions,
      ),
      requirement: requirement,
      isUnlocked: isUnlocked,
      unlockedAt: unlockedAt != null ? DateTime.parse(unlockedAt!) : null,
    );
  }

  /// Create DTO from domain entity
  factory AchievementDto.fromEntity(AchievementEntity entity) {
    return AchievementDto(
      id: entity.id,
      titleKey: entity.titleKey,
      descriptionKey: entity.descriptionKey,
      category: entity.category.name, // Enum to string
      requirement: entity.requirement,
      isUnlocked: entity.isUnlocked,
      unlockedAt: entity.unlockedAt?.toIso8601String(),
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titleKey': titleKey,
      'descriptionKey': descriptionKey,
      'category': category,
      'requirement': requirement,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt,
    };
  }

  /// Deserialize from JSON
  factory AchievementDto.fromJson(Map<String, dynamic> json) {
    return AchievementDto(
      id: json['id'] as String,
      titleKey: json['titleKey'] as String,
      descriptionKey: json['descriptionKey'] as String,
      category: json['category'] as String,
      requirement: json['requirement'] as int,
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      unlockedAt: json['unlockedAt'] as String?,
    );
  }

  AchievementDto copyWith({
    String? id,
    String? titleKey,
    String? descriptionKey,
    String? category,
    int? requirement,
    bool? isUnlocked,
    String? unlockedAt,
  }) {
    return AchievementDto(
      id: id ?? this.id,
      titleKey: titleKey ?? this.titleKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      category: category ?? this.category,
      requirement: requirement ?? this.requirement,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
    );
  }
}
