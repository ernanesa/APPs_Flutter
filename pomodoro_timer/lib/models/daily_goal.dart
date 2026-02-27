/// Represents the user's daily goal and progress.
class DailyGoal {
  /// Target number of focus sessions per day.
  final int targetSessions;

  /// Number of sessions completed today.
  final int completedSessions;

  /// The date for which this goal applies.
  final DateTime date;

  /// Total focus minutes completed today.
  final int focusMinutesToday;

  const DailyGoal({
    this.targetSessions = 8,
    this.completedSessions = 0,
    required this.date,
    this.focusMinutesToday = 0,
  });

  /// Progress percentage (0.0 to 1.0).
  double get progress {
    if (targetSessions == 0) return 0.0;
    return (completedSessions / targetSessions).clamp(0.0, 1.0);
  }

  /// Whether the daily goal has been reached.
  bool get isGoalReached => completedSessions >= targetSessions;

  /// Remaining sessions to reach the goal.
  int get remainingSessions =>
      (targetSessions - completedSessions).clamp(0, targetSessions);

  /// Creates DailyGoal from JSON.
  factory DailyGoal.fromJson(Map<String, dynamic> json) {
    return DailyGoal(
      targetSessions: json['targetSessions'] as int? ?? 8,
      completedSessions: json['completedSessions'] as int? ?? 0,
      date: DateTime.parse(json['date'] as String),
      focusMinutesToday: json['focusMinutesToday'] as int? ?? 0,
    );
  }

  /// Converts to JSON for persistence.
  Map<String, dynamic> toJson() {
    return {
      'targetSessions': targetSessions,
      'completedSessions': completedSessions,
      'date': date.toIso8601String(),
      'focusMinutesToday': focusMinutesToday,
    };
  }

  /// Creates a copy with updated values.
  DailyGoal copyWith({
    int? targetSessions,
    int? completedSessions,
    DateTime? date,
    int? focusMinutesToday,
  }) {
    return DailyGoal(
      targetSessions: targetSessions ?? this.targetSessions,
      completedSessions: completedSessions ?? this.completedSessions,
      date: date ?? this.date,
      focusMinutesToday: focusMinutesToday ?? this.focusMinutesToday,
    );
  }

  /// Checks if this goal is for today.
  bool get isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }
}
