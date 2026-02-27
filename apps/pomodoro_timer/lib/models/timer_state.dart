import 'pomodoro_session.dart';

/// Represents the current state of the Pomodoro timer.
class TimerState {
  final SessionType currentSessionType;
  final int remainingSeconds;
  final int totalSeconds;
  final bool isRunning;
  final bool isPaused;
  final int completedSessions;
  final int completedPomodoros;
  final DateTime? sessionStartTime;

  const TimerState({
    this.currentSessionType = SessionType.focus,
    this.remainingSeconds = 25 * 60,
    this.totalSeconds = 25 * 60,
    this.isRunning = false,
    this.isPaused = false,
    this.completedSessions = 0,
    this.completedPomodoros = 0,
    this.sessionStartTime,
  });

  /// Returns true if the timer is active (running or paused).
  bool get isActive => isRunning || isPaused;

  /// Returns the progress as a value between 0.0 and 1.0.
  double get progress {
    if (totalSeconds == 0) return 0.0;
    return 1.0 - (remainingSeconds / totalSeconds);
  }

  /// Returns the remaining time formatted as MM:SS.
  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Returns true if this is a focus session.
  bool get isFocusSession => currentSessionType == SessionType.focus;

  /// Returns true if this is any type of break.
  bool get isBreakSession =>
      currentSessionType == SessionType.shortBreak ||
      currentSessionType == SessionType.longBreak;

  /// Creates a copy with modified values.
  TimerState copyWith({
    SessionType? currentSessionType,
    int? remainingSeconds,
    int? totalSeconds,
    bool? isRunning,
    bool? isPaused,
    int? completedSessions,
    int? completedPomodoros,
    DateTime? sessionStartTime,
    bool clearSessionStartTime = false,
  }) {
    return TimerState(
      currentSessionType: currentSessionType ?? this.currentSessionType,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      isRunning: isRunning ?? this.isRunning,
      isPaused: isPaused ?? this.isPaused,
      completedSessions: completedSessions ?? this.completedSessions,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      sessionStartTime:
          clearSessionStartTime
              ? null
              : (sessionStartTime ?? this.sessionStartTime),
    );
  }
}
