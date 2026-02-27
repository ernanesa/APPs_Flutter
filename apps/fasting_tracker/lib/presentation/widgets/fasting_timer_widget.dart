import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../domain/entities/fasting_session.dart';
import '../providers/fasting_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

/// Circular timer widget showing fasting progress
class FastingTimerWidget extends ConsumerWidget {
  const FastingTimerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fastingState = ref.watch(fastingProvider);
    final session = fastingState.currentSession;
    final protocol = fastingState.selectedProtocol;
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, 320.0);

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Progress ring
              SizedBox(
                width: size,
                height: size,
                child: PieChart(
                  PieChartData(
                    startDegreeOffset: -90,
                    sectionsSpace: 0,
                    centerSpaceRadius: size * 0.35,
                    sections: _buildSections(context, session, protocol, size),
                  ),
                ),
              ),
              // Center content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (session != null) ...[
                    Text(
                      session.currentStage.icon,
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatDuration(session.elapsedMinutes),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${l10n.ofPreposition} ${protocol.fastingHours}h',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStageChip(context, session.currentStage, l10n),
                  ] else ...[
                    Icon(
                      Icons.restaurant_menu,
                      size: 48,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.readyToFast, style: theme.textTheme.titleLarge),
                    const SizedBox(height: 4),
                    Text(
                      '${protocol.icon} ${protocol.ratioString}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _buildSections(
    BuildContext context,
    FastingSession? session,
    dynamic protocol,
    double size,
  ) {
    final theme = Theme.of(context);
    final progress = session?.progress ?? 0.0;
    final clampedProgress = progress.clamp(0.0, 1.0);

    // Stage colors
    final stageColor = session != null
        ? _getStageColor(session.currentStage, theme)
        : theme.colorScheme.surfaceContainerHighest;

    return [
      // Progress section
      PieChartSectionData(
        value: clampedProgress * 100,
        color: stageColor,
        radius: size * 0.12,
        showTitle: false,
      ),
      // Remaining section
      PieChartSectionData(
        value: (1 - clampedProgress) * 100,
        color: theme.colorScheme.surfaceContainerHighest,
        radius: size * 0.1,
        showTitle: false,
      ),
    ];
  }

  Color _getStageColor(FastingStage stage, ThemeData theme) {
    switch (stage) {
      case FastingStage.fed:
        return Colors.grey;
      case FastingStage.earlyFasting:
        return Colors.blue;
      case FastingStage.fatBurning:
        return Colors.orange;
      case FastingStage.ketosis:
        return Colors.deepOrange;
      case FastingStage.deepKetosis:
        return Colors.red;
      case FastingStage.autophagy:
        return Colors.purple;
    }
  }

  Widget _buildStageChip(
    BuildContext context,
    FastingStage stage,
    AppLocalizations l10n,
  ) {
    final color = _getStageColor(stage, Theme.of(context));

    String stageName;
    switch (stage) {
      case FastingStage.fed:
        stageName = l10n.stageFed;
        break;
      case FastingStage.earlyFasting:
        stageName = l10n.stageEarlyFasting;
        break;
      case FastingStage.fatBurning:
        stageName = l10n.stageFatBurning;
        break;
      case FastingStage.ketosis:
        stageName = l10n.stageKetosis;
        break;
      case FastingStage.deepKetosis:
        stageName = l10n.stageDeepKetosis;
        break;
      case FastingStage.autophagy:
        stageName = l10n.stageAutophagy;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        stageName,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${mins.toString().padLeft(2, '0')}';
  }
}
