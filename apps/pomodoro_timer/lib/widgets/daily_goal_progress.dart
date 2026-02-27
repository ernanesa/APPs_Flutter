import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/daily_goal_provider.dart';

/// Widget displaying daily goal progress.
class DailyGoalProgress extends ConsumerWidget {
  final bool compact;

  const DailyGoalProgress({super.key, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyGoal = ref.watch(dailyGoalProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (compact) {
      return _buildCompact(context, dailyGoal, l10n, theme);
    }

    return _buildFull(context, dailyGoal, l10n, theme);
  }

  Widget _buildCompact(
    BuildContext context,
    dynamic dailyGoal,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: dailyGoal.isGoalReached
            ? Colors.green.withValues(alpha: 0.2)
            : theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: dailyGoal.isGoalReached
              ? Colors.green
              : theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            dailyGoal.isGoalReached ? Icons.check_circle : Icons.flag,
            color: dailyGoal.isGoalReached
                ? Colors.green
                : theme.colorScheme.primary,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            '${dailyGoal.completedSessions}/${dailyGoal.targetSessions}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: dailyGoal.isGoalReached
                  ? Colors.green
                  : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFull(
    BuildContext context,
    dynamic dailyGoal,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.flag, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.dailyGoal,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (dailyGoal.isGoalReached)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.goalReached,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          Stack(
            children: [
              Container(
                height: 12,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              FractionallySizedBox(
                widthFactor: dailyGoal.progress,
                child: Container(
                  height: 12,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: dailyGoal.isGoalReached
                          ? [Colors.green, Colors.greenAccent]
                          : [
                              theme.colorScheme.primary,
                              theme.colorScheme.secondary,
                            ],
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.sessionsProgress(
                  dailyGoal.completedSessions,
                  dailyGoal.targetSessions,
                ),
                style: theme.textTheme.bodyMedium,
              ),
              Text(
                '${(dailyGoal.progress * 100).toInt()}%',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          if (dailyGoal.focusMinutesToday > 0) ...[
            const SizedBox(height: 4),
            Text(
              l10n.focusTimeToday(dailyGoal.focusMinutesToday),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Widget for setting daily goal target.
class DailyGoalSetter extends ConsumerWidget {
  const DailyGoalSetter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyGoal = ref.watch(dailyGoalProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(Icons.flag, color: theme.colorScheme.primary),
      title: Text(l10n.sessionsPerDay(dailyGoal.targetSessions)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: dailyGoal.targetSessions > 1
                ? () {
                    ref
                        .read(dailyGoalProvider.notifier)
                        .setTargetSessions(dailyGoal.targetSessions - 1);
                  }
                : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          Text(
            '${dailyGoal.targetSessions}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: dailyGoal.targetSessions < 20
                ? () {
                    ref
                        .read(dailyGoalProvider.notifier)
                        .setTargetSessions(dailyGoal.targetSessions + 1);
                  }
                : null,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }
}
