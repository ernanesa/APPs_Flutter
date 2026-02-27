/// Tracks user's fasting streak data
class StreakData {
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastCompletedDate;
  final int totalCompletedFasts;
  final int totalFastingMinutes;

  const StreakData({
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastCompletedDate,
    this.totalCompletedFasts = 0,
    this.totalFastingMinutes = 0,
  });

  /// Check if user completed a fast today
  bool get completedToday {
    if (lastCompletedDate == null) return false;
    final now = DateTime.now();
    return lastCompletedDate!.year == now.year &&
        lastCompletedDate!.month == now.month &&
        lastCompletedDate!.day == now.day;
  }

  /// Total fasting hours
  double get totalFastingHours => totalFastingMinutes / 60.0;

  /// Average fasting duration in hours
  double get averageFastingHours {
    if (totalCompletedFasts == 0) return 0;
    return totalFastingHours / totalCompletedFasts;
  }

  StreakData copyWith({
    int? currentStreak,
    int? bestStreak,
    DateTime? lastCompletedDate,
    int? totalCompletedFasts,
    int? totalFastingMinutes,
  }) {
    return StreakData(
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastCompletedDate: lastCompletedDate ?? this.lastCompletedDate,
      totalCompletedFasts: totalCompletedFasts ?? this.totalCompletedFasts,
      totalFastingMinutes: totalFastingMinutes ?? this.totalFastingMinutes,
    );
  }
}
