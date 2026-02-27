import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/fasting_session.dart';
import '../providers/fasting_provider.dart';
import '../providers/streak_provider.dart';

/// History screen
class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final historyAsync = ref.watch(fastingHistoryProvider);
    final streakData = ref.watch(streakProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history),
      ),
      body: Column(
        children: [
          // Stats header
          Container(
            padding: const EdgeInsets.all(24),
            color: theme.colorScheme.primaryContainer,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: '🔥',
                  value: '${streakData.currentStreak}',
                  label: l10n.currentStreak,
                ),
                _StatItem(
                  icon: '🏆',
                  value: '${streakData.bestStreak}',
                  label: l10n.bestStreak,
                ),
                _StatItem(
                  icon: '⏱️',
                  value: '${streakData.totalFastingHours.round()}h',
                  label: l10n.totalHours,
                ),
                _StatItem(
                  icon: '✅',
                  value: '${streakData.totalCompletedFasts}',
                  label: l10n.totalFasts,
                ),
              ],
            ),
          ),
          // History list
          Expanded(
            child: historyAsync.when(
              data: (history) {
                if (history.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.history,
                          size: 64,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.noHistory,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: history.length,
                  itemBuilder: (context, index) {
                    final session = history[index];
                    return _HistoryCard(session: session, l10n: l10n);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String icon;
  final String value;
  final String label;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final FastingSession session;
  final AppLocalizations l10n;

  const _HistoryCard({required this.session, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat.yMMMd();
    final timeFormat = DateFormat.Hm();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: session.goalAchieved
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              session.goalAchieved ? '✅' : '⏹️',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(
          dateFormat.format(session.startTime),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${timeFormat.format(session.startTime)} - ${session.endTime != null ? timeFormat.format(session.endTime!) : "?"}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${(session.elapsedMinutes / 60).toStringAsFixed(1)}h',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '/${session.targetHours}h',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
