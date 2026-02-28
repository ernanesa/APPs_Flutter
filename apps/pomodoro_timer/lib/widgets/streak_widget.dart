import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import 'package:core_logic/core_logic.dart';


/// Widget displaying the current streak with fire icon.
class StreakWidget extends ConsumerWidget {
  final bool showLabel;
  final double iconSize;

  const StreakWidget({super.key, this.showLabel = true, this.iconSize = 24});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: streak.streak > 0
              ? Colors.orange
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            color: streak.streak > 0
                ? Colors.orange
                : theme.colorScheme.outline,
            size: iconSize,
          ),
          const SizedBox(width: 4),
          Text(
            '${streak.streak}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: streak.streak > 0
                  ? Colors.orange
                  : theme.colorScheme.onSurface,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              l10n.streakDays,
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

/// Compact streak display for app bar.
class StreakBadge extends ConsumerWidget {
  const StreakBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: streak.streak > 0
            ? Colors.orange.withValues(alpha: 0.2)
            : Colors.grey.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.local_fire_department,
            color: streak.streak > 0 ? Colors.orange : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 2),
          Text(
            '${streak.streak}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: streak.streak > 0 ? Colors.orange : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
