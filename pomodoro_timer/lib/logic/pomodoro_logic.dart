import '../models/pomodoro_session.dart';
import '../models/pomodoro_settings.dart';
import '../models/timer_state.dart';

/// Pure business logic for Pomodoro timer calculations.
class PomodoroLogic {
  /// Gets the duration in seconds for a given session type.
  static int getDurationForSessionType(
    SessionType type,
    PomodoroSettings settings,
  ) {
    switch (type) {
      case SessionType.focus:
        return settings.focusDurationMinutes * 60;
      case SessionType.shortBreak:
        return settings.shortBreakMinutes * 60;
      case SessionType.longBreak:
        return settings.longBreakMinutes * 60;
    }
  }

  /// Determines the next session type based on current state.
  static SessionType getNextSessionType(
    SessionType currentType,
    int completedPomodoros,
    int sessionsUntilLongBreak,
  ) {
    if (currentType == SessionType.focus) {
      // After focus, check if it's time for a long break
      if ((completedPomodoros + 1) % sessionsUntilLongBreak == 0) {
        return SessionType.longBreak;
      }
      return SessionType.shortBreak;
    }
    // After any break, go back to focus
    return SessionType.focus;
  }

  /// Creates a new timer state for a given session type.
  static TimerState createStateForSession(
    SessionType type,
    PomodoroSettings settings, {
    int completedSessions = 0,
    int completedPomodoros = 0,
  }) {
    final duration = getDurationForSessionType(type, settings);
    return TimerState(
      currentSessionType: type,
      remainingSeconds: duration,
      totalSeconds: duration,
      isRunning: false,
      isPaused: false,
      completedSessions: completedSessions,
      completedPomodoros: completedPomodoros,
    );
  }

  /// Calculates statistics for a given day from sessions list.
  static DailyStats calculateDailyStats(
    List<PomodoroSession> sessions,
    DateTime date,
  ) {
    final daySessions = sessions.where((s) {
      return s.startTime.year == date.year &&
          s.startTime.month == date.month &&
          s.startTime.day == date.day &&
          s.type == SessionType.focus &&
          s.wasCompleted;
    }).toList();

    final totalMinutes = daySessions.fold<int>(
      0,
      (sum, s) => sum + s.durationMinutes,
    );

    return DailyStats(
      date: date,
      completedPomodoros: daySessions.length,
      totalFocusMinutes: totalMinutes,
    );
  }

  /// Calculates weekly statistics from sessions list.
  static WeeklyStats calculateWeeklyStats(List<PomodoroSession> sessions) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    
    final dailyStats = <DailyStats>[];
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      dailyStats.add(calculateDailyStats(sessions, date));
    }

    final totalPomodoros = dailyStats.fold<int>(
      0,
      (sum, d) => sum + d.completedPomodoros,
    );
    final totalMinutes = dailyStats.fold<int>(
      0,
      (sum, d) => sum + d.totalFocusMinutes,
    );

    return WeeklyStats(
      dailyStats: dailyStats,
      totalPomodoros: totalPomodoros,
      totalFocusMinutes: totalMinutes,
    );
  }

  /// Formats minutes as hours and minutes string.
  static String formatMinutesAsHoursAndMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }
}

/// Statistics for a single day.
class DailyStats {
  final DateTime date;
  final int completedPomodoros;
  final int totalFocusMinutes;

  const DailyStats({
    required this.date,
    required this.completedPomodoros,
    required this.totalFocusMinutes,
  });
}

/// Statistics for a week.
class WeeklyStats {
  final List<DailyStats> dailyStats;
  final int totalPomodoros;
  final int totalFocusMinutes;

  const WeeklyStats({
    required this.dailyStats,
    required this.totalPomodoros,
    required this.totalFocusMinutes,
  });
}
