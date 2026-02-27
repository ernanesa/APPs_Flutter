import 'package:flutter/material.dart';
import '../models/pomodoro_session.dart';

/// Widget showing session indicators (completed pomodoros).
class SessionIndicator extends StatelessWidget {
  final int completedPomodoros;
  final int sessionsUntilLongBreak;
  final SessionType currentSessionType;

  const SessionIndicator({
    super.key,
    required this.completedPomodoros,
    required this.sessionsUntilLongBreak,
    required this.currentSessionType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentInCycle = completedPomodoros % sessionsUntilLongBreak;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(sessionsUntilLongBreak, (index) {
        final isCompleted = index < currentInCycle;
        final isCurrent =
            index == currentInCycle && currentSessionType == SessionType.focus;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isCurrent ? 32 : 12,
            height: 12,
            decoration: BoxDecoration(
              color:
                  isCompleted
                      ? theme.colorScheme.primary
                      : (isCurrent
                          ? theme.colorScheme.primary.withValues(alpha: 0.5)
                          : theme.colorScheme.surfaceContainerHighest),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color:
                    isCompleted || isCurrent
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
          ),
        );
      }),
    );
  }
}
