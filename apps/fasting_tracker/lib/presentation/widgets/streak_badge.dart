import 'package:flutter/material.dart';
import 'package:fasting_tracker/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_logic/core_logic.dart';



/// Streak badge widget showing current streak
class StreakBadge extends ConsumerWidget {
  const StreakBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streakData = ref.watch(streakProvider);
    final theme = Theme.of(context);
    // ignore: unused_local_variable - kept for future i18n use
    final _ = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: streakData.streak > 0
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            streakData.streak > 0 ? '🔥' : '💤',
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(width: 2),
          Text(
            '${streakData.streak}',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: streakData.streak > 0
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
