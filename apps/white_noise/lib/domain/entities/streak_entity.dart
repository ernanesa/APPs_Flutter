/// Entity representing user's streak (consecutive days of usage)
class StreakEntity {
  final int streak;
  final int xp;
  final DateTime? lastActiveDate;

  const StreakEntity({
    this.streak = 0,
    this.xp = 0,
    this.lastActiveDate,
  });

  StreakEntity copyWith({
    int? currentStreak,
    int? bestStreak,
    DateTime? lastActiveDate,
  }) {
    return StreakEntity(
      streak: currentStreak ?? this.streak,
      bestStreak: bestStreak ?? this.xp,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  /// Check if user is active today
  bool get isActiveToday {
    if (lastActiveDate == null) return false;
    final now = DateTime.now();
    return lastActiveDate!.year == now.year &&
        lastActiveDate!.month == now.month &&
        lastActiveDate!.day == now.day;
  }

  /// Check if streak is broken (more than 1 day gap)
  bool get isBroken {
    if (lastActiveDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastActive = DateTime(
      lastActiveDate!.year,
      lastActiveDate!.month,
      lastActiveDate!.day,
    );
    return today.difference(lastActive).inDays > 1;
  }

  /// Record activity for today
  StreakEntity recordActivity() {
    if (isActiveToday) return this; // Already recorded today

    final now = DateTime.now();
    int newStreak = 1;

    if (lastActiveDate != null) {
      final today = DateTime(now.year, now.month, now.day);
      final lastActive = DateTime(
        lastActiveDate!.year,
        lastActiveDate!.month,
        lastActiveDate!.day,
      );
      final difference = today.difference(lastActive).inDays;

      if (difference == 1) {
        // Consecutive day
        newStreak = currentStreak + 1;
      } else if (difference > 1) {
        // Streak broken
        newStreak = 1;
      }
    }

    final newBest = newStreak > bestStreak ? newStreak : bestStreak;

    return StreakEntity(
      streak: newStreak,
      bestStreak: newBest,
      lastActiveDate: now,
    );
  }

  /// Reset streak
  StreakEntity reset() {
    return const StreakEntity();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StreakEntity &&
        other.streak == currentStreak &&
        other.xp == bestStreak &&
        other.lastActiveDate == lastActiveDate;
  }

  @override
  int get hashCode => Object.hash(currentStreak, bestStreak, lastActiveDate);
}
