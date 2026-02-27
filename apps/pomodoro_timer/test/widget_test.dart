import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_timer/widgets/timer_display.dart';
import 'package:pomodoro_timer/widgets/session_indicator.dart';
import 'package:pomodoro_timer/models/pomodoro_session.dart';

void main() {
  group('TimerDisplay Widget', () {
    testWidgets('displays formatted time correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerDisplay(
              remainingSeconds: 1500, // 25:00
              totalSeconds: 1500,
            ),
          ),
        ),
      );

      expect(find.text('25:00'), findsOneWidget);
    });

    testWidgets('displays single digit seconds with leading zero', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TimerDisplay(
              remainingSeconds: 65, // 01:05
              totalSeconds: 1500,
            ),
          ),
        ),
      );

      expect(find.text('01:05'), findsOneWidget);
    });
  });

  group('SessionIndicator Widget', () {
    testWidgets('renders correct number of indicators', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SessionIndicator(
              completedPomodoros: 2,
              sessionsUntilLongBreak: 4,
              currentSessionType: SessionType.focus,
            ),
          ),
        ),
      );

      // Should have 4 indicator containers
      final containers = find.byType(AnimatedContainer);
      expect(containers, findsNWidgets(4));
    });
  });
}
