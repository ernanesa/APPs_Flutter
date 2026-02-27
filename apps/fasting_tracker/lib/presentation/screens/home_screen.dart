import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../widgets/ad_banner_widget.dart';
import '../providers/fasting_provider.dart';
import '../widgets/fasting_timer_widget.dart';
import '../widgets/streak_badge.dart';
import '../widgets/stages_timeline.dart';
import '../widgets/protocol_selector.dart';
import '../widgets/health_info_button.dart';
import 'settings_screen.dart';
import 'achievements_screen.dart';
import 'history_screen.dart';

/// Main home screen with fasting timer
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fastingState = ref.watch(fastingProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'history') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryScreen()),
                );
              } else if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              } else if (value == 'info') {
                const HealthInfoButton().showHealthInfoSheet(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'history',
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(l10n.history),
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              PopupMenuItem(
                value: 'info',
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.healthInfoTitle),
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(l10n.settings),
                  contentPadding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Quick actions bar (streak + achievements)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const StreakBadge(),
                  FilledButton.tonalIcon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AchievementsScreen(),
                      ),
                    ),
                    icon: const Icon(Icons.emoji_events, size: 18),
                    label: Text(l10n.achievements),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Timer widget
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: FastingTimerWidget(),
            ),

            const SizedBox(height: 24),

            // Control buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _buildControlButtons(context, ref, fastingState, l10n),
            ),

            const SizedBox(height: 24),

            // Protocol selector (disabled when fasting)
            if (!fastingState.isFasting) ...[
              ProtocolSelector(
                selectedProtocol: fastingState.selectedProtocol,
                onProtocolSelected: (protocol) {
                  HapticFeedback.selectionClick();
                  ref.read(fastingProvider.notifier).selectProtocol(protocol);
                },
                enabled: !fastingState.isFasting,
              ),
              const SizedBox(height: 16),
            ],

            // Stages timeline
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StagesTimeline(
                currentSession: fastingState.currentSession,
              ),
            ),

            const SizedBox(height: 24),
            const AdBannerWidget(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons(
    BuildContext context,
    WidgetRef ref,
    FastingState state,
    AppLocalizations l10n,
  ) {
    final theme = Theme.of(context);

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isFasting) {
      final goalAchieved = state.currentSession?.goalAchieved ?? false;

      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                HapticFeedback.mediumImpact();
                _showCancelDialog(context, ref, l10n);
              },
              icon: const Icon(Icons.close),
              label: Text(l10n.cancel),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                foregroundColor: theme.colorScheme.error,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: FilledButton.icon(
              onPressed: () {
                HapticFeedback.heavyImpact();
                ref.read(fastingProvider.notifier).endFasting();
              },
              icon: Icon(goalAchieved ? Icons.check : Icons.stop),
              label: Text(goalAchieved ? l10n.complete : l10n.endEarly),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: goalAchieved
                    ? theme.colorScheme.primary
                    : theme.colorScheme.secondary,
              ),
            ),
          ),
        ],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: () {
          HapticFeedback.heavyImpact();
          ref
              .read(fastingProvider.notifier)
              .startFasting(
                notificationTitle: l10n.notificationGoalReachedTitle,
                notificationBody: l10n.notificationGoalReachedBody,
              );
        },
        icon: const Icon(Icons.play_arrow),
        label: Text(l10n.startFasting),
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  void _showCancelDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cancelFasting),
        content: Text(l10n.cancelFastingConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.no),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(fastingProvider.notifier).cancelFasting();
            },
            child: Text(l10n.yes),
          ),
        ],
      ),
    );
  }
}
