import 'package:white_noise/domain/entities/streak_entity.dart';

/// DTO for StreakEntity serialization
class StreakDto {
  final int currentStreak;
  final int bestStreak;
  final String? lastActiveDate; // DateTime as ISO8601 string

  const StreakDto({
    required this.currentStreak,
    required this.bestStreak,
    this.lastActiveDate,
  });

  StreakEntity toEntity() {
    return StreakEntity(
      currentStreak: currentStreak,
      bestStreak: bestStreak,
      lastActiveDate:
          lastActiveDate != null ? DateTime.parse(lastActiveDate!) : null,
    );
  }

  factory StreakDto.fromEntity(StreakEntity entity) {
    return StreakDto(
      currentStreak: entity.currentStreak,
      bestStreak: entity.bestStreak,
      lastActiveDate: entity.lastActiveDate?.toIso8601String(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'lastActiveDate': lastActiveDate,
    };
  }

  factory StreakDto.fromJson(Map<String, dynamic> json) {
    return StreakDto(
      currentStreak: json['currentStreak'] as int? ?? 0,
      bestStreak: json['bestStreak'] as int? ?? 0,
      lastActiveDate: json['lastActiveDate'] as String?,
    );
  }
}
