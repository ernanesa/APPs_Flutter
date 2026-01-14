import 'dart:async';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../logic/pomodoro_logic.dart';
import '../models/pomodoro_session.dart';
import '../models/pomodoro_settings.dart';
import '../models/timer_state.dart';
import 'settings_provider.dart';

/// Provider for the timer state.
final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  final settings = ref.watch(settingsProvider);
  final prefs = ref.watch(sharedPreferencesProvider);
  return TimerNotifier(settings, prefs, ref);
});

/// Callback type for session completion.
typedef SessionCompleteCallback = void Function(SessionType type, bool wasCompleted);

/// Notifier for managing the Pomodoro timer.
class TimerNotifier extends StateNotifier<TimerState> {
  final PomodoroSettings _settings;
  final SharedPreferences _prefs;
  final Ref _ref;
  Timer? _timer;
  SessionCompleteCallback? onSessionComplete;

  static const _sessionsKey = 'pomodoro_sessions';

  TimerNotifier(this._settings, this._prefs, this._ref)
      : super(PomodoroLogic.createStateForSession(
          SessionType.focus,
          const PomodoroSettings(),
        )) {
    // Initialize with current settings
    _initializeWithSettings();
  }

  void _initializeWithSettings() {
    state = PomodoroLogic.createStateForSession(
      state.currentSessionType,
      _settings,
      completedSessions: state.completedSessions,
      completedPomodoros: state.completedPomodoros,
    );
  }

  /// Starts the timer.
  void start() {
    if (state.isRunning) return;

    state = state.copyWith(
      isRunning: true,
      isPaused: false,
      sessionStartTime: DateTime.now(),
    );

    _startTicking();
  }

  /// Pauses the timer.
  void pause() {
    if (!state.isRunning) return;

    _timer?.cancel();
    state = state.copyWith(
      isRunning: false,
      isPaused: true,
    );
  }

  /// Resumes a paused timer.
  void resume() {
    if (!state.isPaused) return;

    state = state.copyWith(
      isRunning: true,
      isPaused: false,
    );

    _startTicking();
  }

  /// Resets the timer to initial state for current session type.
  void reset() {
    _timer?.cancel();
    
    final duration = PomodoroLogic.getDurationForSessionType(
      state.currentSessionType,
      _settings,
    );

    state = state.copyWith(
      remainingSeconds: duration,
      totalSeconds: duration,
      isRunning: false,
      isPaused: false,
      clearSessionStartTime: true,
    );
  }

  /// Skips to the next session.
  void skip() {
    _timer?.cancel();
    
    final wasCompleted = state.remainingSeconds == 0;
    _recordSession(wasCompleted: wasCompleted);
    
    _moveToNextSession();
  }

  /// Starts the internal tick timer.
  void _startTicking() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(
          remainingSeconds: state.remainingSeconds - 1,
        );
      } else {
        _onTimerComplete();
      }
    });
  }

  /// Handles timer completion.
  void _onTimerComplete() {
    _timer?.cancel();
    
    _recordSession(wasCompleted: true);
    
    // Notify listeners
    onSessionComplete?.call(state.currentSessionType, true);

    // Check auto-start settings
    final shouldAutoStart = state.isFocusSession
        ? _settings.autoStartBreaks
        : _settings.autoStartFocus;

    _moveToNextSession();

    if (shouldAutoStart) {
      start();
    }
  }

  /// Moves to the next session type.
  void _moveToNextSession() {
    final currentSettings = _ref.read(settingsProvider);
    
    int newCompletedPomodoros = state.completedPomodoros;
    if (state.currentSessionType == SessionType.focus) {
      newCompletedPomodoros++;
    }

    final nextType = PomodoroLogic.getNextSessionType(
      state.currentSessionType,
      state.completedPomodoros,
      currentSettings.sessionsUntilLongBreak,
    );

    final duration = PomodoroLogic.getDurationForSessionType(
      nextType,
      currentSettings,
    );

    state = TimerState(
      currentSessionType: nextType,
      remainingSeconds: duration,
      totalSeconds: duration,
      isRunning: false,
      isPaused: false,
      completedSessions: state.completedSessions + 1,
      completedPomodoros: newCompletedPomodoros,
    );
  }

  /// Records the completed session.
  void _recordSession({required bool wasCompleted}) {
    if (state.sessionStartTime == null) return;

    final session = PomodoroSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: state.sessionStartTime!,
      endTime: DateTime.now(),
      type: state.currentSessionType,
      durationMinutes: state.totalSeconds ~/ 60,
      wasCompleted: wasCompleted,
    );

    _saveSession(session);
  }

  /// Saves a session to persistent storage.
  Future<void> _saveSession(PomodoroSession session) async {
    final sessions = await getSessions();
    sessions.add(session);
    
    // Keep only last 30 days of sessions
    final cutoff = DateTime.now().subtract(const Duration(days: 30));
    final filtered = sessions.where((s) => s.startTime.isAfter(cutoff)).toList();
    
    final json = filtered.map((s) => s.toJson()).toList();
    await _prefs.setString(_sessionsKey, jsonEncode(json));
  }

  /// Gets all stored sessions.
  Future<List<PomodoroSession>> getSessions() async {
    final json = _prefs.getString(_sessionsKey);
    if (json == null) return [];

    try {
      final list = jsonDecode(json) as List;
      return list
          .map((e) => PomodoroSession.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

/// Provider for sessions history.
final sessionsProvider = FutureProvider<List<PomodoroSession>>((ref) async {
  final timerNotifier = ref.watch(timerProvider.notifier);
  return timerNotifier.getSessions();
});

/// Provider for today's statistics.
final todayStatsProvider = FutureProvider<DailyStats>((ref) async {
  final sessions = await ref.watch(sessionsProvider.future);
  return PomodoroLogic.calculateDailyStats(sessions, DateTime.now());
});

/// Provider for weekly statistics.
final weeklyStatsProvider = FutureProvider<WeeklyStats>((ref) async {
  final sessions = await ref.watch(sessionsProvider.future);
  return PomodoroLogic.calculateWeeklyStats(sessions);
});
