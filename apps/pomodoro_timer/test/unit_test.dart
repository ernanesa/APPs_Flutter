import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_timer/logic/pomodoro_logic.dart';
import 'package:pomodoro_timer/models/pomodoro_session.dart';
import 'package:pomodoro_timer/models/pomodoro_settings.dart';
import 'package:pomodoro_timer/models/timer_state.dart';

void main() {
  group('PomodoroLogic', () {
    const settings = PomodoroSettings(
      focusDurationMinutes: 25,
      shortBreakMinutes: 5,
      longBreakMinutes: 15,
      sessionsUntilLongBreak: 4,
    );

    test('getDurationForSessionType returns correct durations', () {
      expect(
        PomodoroLogic.getDurationForSessionType(SessionType.focus, settings),
        equals(25 * 60),
      );
      expect(
        PomodoroLogic.getDurationForSessionType(SessionType.shortBreak, settings),
        equals(5 * 60),
      );
      expect(
        PomodoroLogic.getDurationForSessionType(SessionType.longBreak, settings),
        equals(15 * 60),
      );
    });

    test('getNextSessionType after focus returns short break', () {
      final nextType = PomodoroLogic.getNextSessionType(
        SessionType.focus,
        0, // completedPomodoros
        4, // sessionsUntilLongBreak
      );
      expect(nextType, equals(SessionType.shortBreak));
    });

    test('getNextSessionType after 4 focus sessions returns long break', () {
      final nextType = PomodoroLogic.getNextSessionType(
        SessionType.focus,
        3, // completedPomodoros (4th will complete)
        4, // sessionsUntilLongBreak
      );
      expect(nextType, equals(SessionType.longBreak));
    });

    test('getNextSessionType after break returns focus', () {
      expect(
        PomodoroLogic.getNextSessionType(SessionType.shortBreak, 1, 4),
        equals(SessionType.focus),
      );
      expect(
        PomodoroLogic.getNextSessionType(SessionType.longBreak, 4, 4),
        equals(SessionType.focus),
      );
    });

    test('createStateForSession creates correct initial state', () {
      final state = PomodoroLogic.createStateForSession(
        SessionType.focus,
        settings,
      );

      expect(state.currentSessionType, equals(SessionType.focus));
      expect(state.remainingSeconds, equals(25 * 60));
      expect(state.totalSeconds, equals(25 * 60));
      expect(state.isRunning, isFalse);
      expect(state.isPaused, isFalse);
    });

    test('formatMinutesAsHoursAndMinutes formats correctly', () {
      expect(PomodoroLogic.formatMinutesAsHoursAndMinutes(30), equals('30m'));
      expect(PomodoroLogic.formatMinutesAsHoursAndMinutes(60), equals('1h 0m'));
      expect(PomodoroLogic.formatMinutesAsHoursAndMinutes(90), equals('1h 30m'));
      expect(PomodoroLogic.formatMinutesAsHoursAndMinutes(125), equals('2h 5m'));
    });
  });

  group('TimerState', () {
    test('progress calculates correctly', () {
      const state = TimerState(
        remainingSeconds: 750, // 12.5 minutes
        totalSeconds: 1500, // 25 minutes
      );
      expect(state.progress, closeTo(0.5, 0.001));
    });

    test('formattedTime formats correctly', () {
      const state1 = TimerState(remainingSeconds: 1500);
      expect(state1.formattedTime, equals('25:00'));

      const state2 = TimerState(remainingSeconds: 65);
      expect(state2.formattedTime, equals('01:05'));

      const state3 = TimerState(remainingSeconds: 0);
      expect(state3.formattedTime, equals('00:00'));
    });

    test('isFocusSession returns correct value', () {
      const focusState = TimerState(currentSessionType: SessionType.focus);
      const breakState = TimerState(currentSessionType: SessionType.shortBreak);

      expect(focusState.isFocusSession, isTrue);
      expect(breakState.isFocusSession, isFalse);
    });

    test('isBreakSession returns correct value', () {
      const shortBreak = TimerState(currentSessionType: SessionType.shortBreak);
      const longBreak = TimerState(currentSessionType: SessionType.longBreak);
      const focus = TimerState(currentSessionType: SessionType.focus);

      expect(shortBreak.isBreakSession, isTrue);
      expect(longBreak.isBreakSession, isTrue);
      expect(focus.isBreakSession, isFalse);
    });

    test('copyWith creates new state with modified values', () {
      const original = TimerState(
        remainingSeconds: 1000,
        isRunning: false,
      );

      final modified = original.copyWith(
        remainingSeconds: 500,
        isRunning: true,
      );

      expect(modified.remainingSeconds, equals(500));
      expect(modified.isRunning, isTrue);
      expect(modified.totalSeconds, equals(original.totalSeconds));
    });
  });

  group('PomodoroSettings', () {
    test('default values are correct', () {
      const settings = PomodoroSettings();

      expect(settings.focusDurationMinutes, equals(25));
      expect(settings.shortBreakMinutes, equals(5));
      expect(settings.longBreakMinutes, equals(15));
      expect(settings.sessionsUntilLongBreak, equals(4));
      expect(settings.soundEnabled, isTrue);
      expect(settings.vibrationEnabled, isTrue);
    });

    test('fromJson and toJson are symmetric', () {
      const original = PomodoroSettings(
        focusDurationMinutes: 30,
        shortBreakMinutes: 10,
        soundEnabled: false,
      );

      final json = original.toJson();
      final restored = PomodoroSettings.fromJson(json);

      expect(restored.focusDurationMinutes, equals(30));
      expect(restored.shortBreakMinutes, equals(10));
      expect(restored.soundEnabled, isFalse);
    });

    test('copyWith creates new settings with modified values', () {
      const original = PomodoroSettings();

      final modified = original.copyWith(
        focusDurationMinutes: 45,
        darkMode: true,
      );

      expect(modified.focusDurationMinutes, equals(45));
      expect(modified.darkMode, isTrue);
      expect(modified.shortBreakMinutes, equals(original.shortBreakMinutes));
    });
  });

  group('PomodoroSession', () {
    test('fromJson and toJson are symmetric', () {
      final now = DateTime.now();
      final original = PomodoroSession(
        id: 'test-id',
        startTime: now,
        endTime: now.add(const Duration(minutes: 25)),
        type: SessionType.focus,
        durationMinutes: 25,
        wasCompleted: true,
      );

      final json = original.toJson();
      final restored = PomodoroSession.fromJson(json);

      expect(restored.id, equals('test-id'));
      expect(restored.type, equals(SessionType.focus));
      expect(restored.durationMinutes, equals(25));
      expect(restored.wasCompleted, isTrue);
    });

    test('actualDuration calculates correctly', () {
      final start = DateTime(2025, 1, 1, 10, 0);
      final end = DateTime(2025, 1, 1, 10, 25);

      final session = PomodoroSession(
        id: 'test',
        startTime: start,
        endTime: end,
        type: SessionType.focus,
        durationMinutes: 25,
        wasCompleted: true,
      );

      expect(session.actualDuration.inMinutes, equals(25));
    });
  });
}
