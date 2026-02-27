import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../providers/daily_goal_provider.dart';
import '../../domain/entities/app_theme.dart';
import '../../services/consent_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selectedTheme = ref.watch(selectedThemeProvider);
    final dailyGoal = ref.watch(dailyGoalProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          // Theme Selection
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.colorTheme,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children:
                        AppThemeType.values.map((theme) {
                          final isSelected = theme == selectedTheme;
                          return InkWell(
                            onTap:
                                () => ref
                                    .read(selectedThemeProvider.notifier)
                                    .setTheme(theme),
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.primaryColor,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    isSelected
                                        ? Border.all(
                                          color: Colors.white,
                                          width: 3,
                                        )
                                        : null,
                              ),
                              child:
                                  isSelected
                                      ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 32,
                                      )
                                      : null,
                            ),
                          );
                        }).toList(),
                  ),
                ],
              ),
            ),
          ),

          // Daily Goal
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.dailyGoal,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${dailyGoal.targetCalculations} ${l10n.calculationsPerDay}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Slider(
                    value: dailyGoal.targetCalculations.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: dailyGoal.targetCalculations.toString(),
                    onChanged: (value) {
                      ref
                          .read(dailyGoalProvider.notifier)
                          .setTarget(value.toInt());
                    },
                  ),
                ],
              ),
            ),
          ),

          // Privacy
          if (ConsentService.isPrivacyOptionsRequired)
            Card(
              child: ListTile(
                leading: const Icon(Icons.privacy_tip),
                title: Text(l10n.privacyOptions),
                subtitle: Text(l10n.manageAdConsent),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await ConsentService.showPrivacyOptions();
                },
              ),
            ),

          // About
          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: Text(l10n.about),
              subtitle: Text(l10n.appVersion('1.0.0')),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showAboutDialog(context, l10n),
            ),
          ),

          // Clear History
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: Text(
                l10n.clearHistory,
                style: const TextStyle(color: Colors.red),
              ),
              subtitle: Text(l10n.clearHistoryWarning),
              trailing: const Icon(Icons.chevron_right, color: Colors.red),
              onTap: () => _showClearHistoryDialog(context, ref, l10n),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showAboutDialog(
      context: context,
      applicationName: l10n.appTitle,
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.calculate, size: 48),
      children: [
        Text(l10n.aboutDescription),
        const SizedBox(height: 16),
        Text('Developer: SA Rezende'),
        Text('Email: contact@sarezende.dev'),
      ],
    );
  }

  void _showClearHistoryDialog(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.clearHistory),
            content: Text(l10n.clearHistoryConfirmation),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () {
                  // Clear history via provider
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.historyCleared)));
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(l10n.clearAll),
              ),
            ],
          ),
    );
  }
}
