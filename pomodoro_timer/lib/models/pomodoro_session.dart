/// Represents a completed Pomodoro session for history tracking.
class PomodoroSession {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final SessionType type;
  final int durationMinutes;
  final bool wasCompleted;

  const PomodoroSession({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.durationMinutes,
    required this.wasCompleted,
  });

  /// Creates a new session from JSON (for persistence).
  factory PomodoroSession.fromJson(Map<String, dynamic> json) {
    return PomodoroSession(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      type: SessionType.values[json['type'] as int],
      durationMinutes: json['durationMinutes'] as int,
      wasCompleted: json['wasCompleted'] as bool,
    );
  }

  /// Converts session to JSON for persistence.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'type': type.index,
      'durationMinutes': durationMinutes,
      'wasCompleted': wasCompleted,
    };
  }

  /// Calculates the actual duration of the session.
  Duration get actualDuration => endTime.difference(startTime);
}

/// Types of Pomodoro sessions.
enum SessionType {
  focus,
  shortBreak,
  longBreak,
}
