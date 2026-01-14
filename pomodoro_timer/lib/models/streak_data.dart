/// Represents the user's streak data for consecutive days of practice.
class StreakData {
  /// Current streak (consecutive days).
  final int currentStreak;
  
  /// Best streak ever achieved.
  final int bestStreak;
  
  /// Last date when user completed at least one focus session.
  final DateTime? lastActiveDate;
  
  /// Total days the user has used the app.
  final int totalDaysActive;

  const StreakData({
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastActiveDate,
    this.totalDaysActive = 0,
  });

  /// Creates StreakData from JSON.
  factory StreakData.fromJson(Map<String, dynamic> json) {
    return StreakData(
      currentStreak: json['currentStreak'] as int? ?? 0,
      bestStreak: json['bestStreak'] as int? ?? 0,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.parse(json['lastActiveDate'] as String)
          : null,
      totalDaysActive: json['totalDaysActive'] as int? ?? 0,
    );
  }

  /// Converts to JSON for persistence.
  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'bestStreak': bestStreak,
      'lastActiveDate': lastActiveDate?.toIso8601String(),
      'totalDaysActive': totalDaysActive,
    };
  }

  /// Creates a copy with updated values.
  StreakData copyWith({
    int? currentStreak,
    int? bestStreak,
    DateTime? lastActiveDate,
    int? totalDaysActive,
  }) {
    return StreakData(
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      totalDaysActive: totalDaysActive ?? this.totalDaysActive,
    );
  }

  /// Checks if the streak is still valid (user was active yesterday or today).
  bool get isStreakActive {
    if (lastActiveDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActive = DateTime(
      lastActiveDate!.year,
      lastActiveDate!.month,
      lastActiveDate!.day,
    );
    final difference = today.difference(lastActive).inDays;
    return difference <= 1;
  }

  /// Checks if the user was active today.
  bool get wasActiveToday {
    if (lastActiveDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActive = DateTime(
      lastActiveDate!.year,
      lastActiveDate!.month,
      lastActiveDate!.day,
    );
    return today.isAtSameMomentAs(lastActive);
  }
}
