import 'dart:convert';
import '../../domain/entities/streak_data.dart';

/// Data model for StreakData with JSON serialization
class StreakDataModel extends StreakData {
  const StreakDataModel({
    super.currentStreak,
    super.bestStreak,
    super.lastCompletedDate,
    super.totalCompletedFasts,
    super.totalFastingMinutes,
  });

  factory StreakDataModel.fromJson(Map<String, dynamic> json) {
    return StreakDataModel(
      currentStreak: json['currentStreak'] as int? ?? 0,
      bestStreak: json['bestStreak'] as int? ?? 0,
      lastCompletedDate:
          json['lastCompletedDate'] != null
              ? DateTime.parse(json['lastCompletedDate'] as String)
              : null,
      totalCompletedFasts: json['totalCompletedFasts'] as int? ?? 0,
      totalFastingMinutes: json['totalFastingMinutes'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'lastCompletedDate': lastCompletedDate?.toIso8601String(),
      'totalCompletedFasts': totalCompletedFasts,
      'totalFastingMinutes': totalFastingMinutes,
    };
  }

  factory StreakDataModel.fromEntity(StreakData entity) {
    return StreakDataModel(
      currentStreak: entity.currentStreak,
      bestStreak: entity.bestStreak,
      lastCompletedDate: entity.lastCompletedDate,
      totalCompletedFasts: entity.totalCompletedFasts,
      totalFastingMinutes: entity.totalFastingMinutes,
    );
  }

  String encode() => jsonEncode(toJson());

  static StreakDataModel decode(String json) {
    return StreakDataModel.fromJson(jsonDecode(json));
  }
}
