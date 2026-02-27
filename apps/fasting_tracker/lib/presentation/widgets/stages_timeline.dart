import 'package:flutter/material.dart';
import 'package:fasting_tracker/l10n/app_localizations.dart';
import '../../domain/entities/fasting_session.dart';
import 'package:fasting_tracker/l10n/app_localizations.dart';

/// Widget showing all fasting stages as a timeline
class StagesTimeline extends StatelessWidget {
  final FastingSession? currentSession;

  const StagesTimeline({super.key, this.currentSession});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final currentHours = currentSession?.elapsedHours ?? 0;

    final stages = [
      _StageInfo(FastingStage.fed, l10n.stageFed, '0-4h', Colors.grey),
      _StageInfo(
        FastingStage.earlyFasting,
        l10n.stageEarlyFasting,
        '4-12h',
        Colors.blue,
      ),
      _StageInfo(
        FastingStage.fatBurning,
        l10n.stageFatBurning,
        '12-18h',
        Colors.orange,
      ),
      _StageInfo(
        FastingStage.ketosis,
        l10n.stageKetosis,
        '18-24h',
        Colors.deepOrange,
      ),
      _StageInfo(
        FastingStage.deepKetosis,
        l10n.stageDeepKetosis,
        '24-48h',
        Colors.red,
      ),
      _StageInfo(
        FastingStage.autophagy,
        l10n.stageAutophagy,
        '48h+',
        Colors.purple,
      ),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.metabolicStages,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...stages.asMap().entries.map((entry) {
              final index = entry.key;
              final stage = entry.value;
              final isActive =
                  currentSession != null &&
                  currentSession!.currentStage == stage.stage;
              final isPassed = currentHours >= stage.stage.endHour;

              return _buildStageRow(
                context,
                stage,
                isActive,
                isPassed,
                isLast: index == stages.length - 1,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStageRow(
    BuildContext context,
    _StageInfo stage,
    bool isActive,
    bool isPassed, {
    bool isLast = false,
  }) {
    final theme = Theme.of(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isActive
                      ? stage.color
                      : isPassed
                      ? stage.color.withValues(alpha: 0.5)
                      : theme.colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: stage.color,
                    width: isActive ? 3 : 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    stage.stage.icon,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isPassed
                        ? stage.color.withValues(alpha: 0.5)
                        : theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          // Stage info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        stage.name,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: isActive
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isActive ? stage.color : null,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        stage.timeRange,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StageInfo {
  final FastingStage stage;
  final String name;
  final String timeRange;
  final Color color;

  _StageInfo(this.stage, this.name, this.timeRange, this.color);
}
