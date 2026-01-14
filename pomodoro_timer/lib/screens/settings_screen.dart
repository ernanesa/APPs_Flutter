import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import '../providers/locale_provider.dart';
import '../services/consent_service.dart';
import '../widgets/theme_selector.dart';
import '../widgets/ambient_sound_selector.dart';
import '../widgets/daily_goal_progress.dart';
import 'achievements_screen.dart';

/// Settings screen for customizing Pomodoro timer.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Timer settings section
          _buildSectionHeader(context, l10n.timer),
          _buildDurationTile(
            context,
            icon: Icons.psychology_outlined,
            title: l10n.focusDuration,
            value: settings.focusDurationMinutes,
            min: 1,
            max: 60,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateFocusDuration(value);
            },
            l10n: l10n,
          ),
          _buildDurationTile(
            context,
            icon: Icons.coffee_outlined,
            title: l10n.shortBreakDuration,
            value: settings.shortBreakMinutes,
            min: 1,
            max: 30,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateShortBreakDuration(value);
            },
            l10n: l10n,
          ),
          _buildDurationTile(
            context,
            icon: Icons.self_improvement_outlined,
            title: l10n.longBreakDuration,
            value: settings.longBreakMinutes,
            min: 5,
            max: 60,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateLongBreakDuration(value);
            },
            l10n: l10n,
          ),
          _buildDurationTile(
            context,
            icon: Icons.repeat_rounded,
            title: l10n.sessionsUntilLongBreak,
            value: settings.sessionsUntilLongBreak,
            min: 2,
            max: 8,
            suffix: l10n.sessions.toLowerCase(),
            onChanged: (value) {
              ref.read(settingsProvider.notifier).updateSessionsUntilLongBreak(value);
            },
            l10n: l10n,
          ),
          const Divider(height: 32),
          // Auto-start section
          _buildSectionHeader(context, 'Auto'),
          SwitchListTile(
            secondary: const Icon(Icons.play_circle_outline),
            title: Text(l10n.autoStartBreaks),
            value: settings.autoStartBreaks,
            onChanged: (_) {
              ref.read(settingsProvider.notifier).toggleAutoStartBreaks();
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.replay_rounded),
            title: Text(l10n.autoStartFocus),
            value: settings.autoStartFocus,
            onChanged: (_) {
              ref.read(settingsProvider.notifier).toggleAutoStartFocus();
            },
          ),
          const Divider(height: 32),
          // Feedback section
          _buildSectionHeader(context, l10n.notifications),
          SwitchListTile(
            secondary: const Icon(Icons.volume_up_outlined),
            title: Text(l10n.soundEnabled),
            value: settings.soundEnabled,
            onChanged: (_) {
              ref.read(settingsProvider.notifier).toggleSound();
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.vibration_rounded),
            title: Text(l10n.vibrationEnabled),
            value: settings.vibrationEnabled,
            onChanged: (_) {
              ref.read(settingsProvider.notifier).toggleVibration();
            },
          ),
          const Divider(height: 32),
          // Appearance section
          _buildSectionHeader(context, l10n.language),
          // Language selector
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            trailing: DropdownButton<String>(
              value: _getCurrentLocaleCode(ref),
              underline: const SizedBox(),
              onChanged: (String? code) {
                if (code != null) {
                  ref.read(localeProvider.notifier).setLocale(code);
                }
              },
              items: LocaleNotifier.supportedLocales.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(
                    entry.value,
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }).toList(),
            ),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: Text(l10n.darkMode),
            value: settings.darkMode,
            onChanged: (_) {
              ref.read(settingsProvider.notifier).toggleDarkMode();
            },
          ),
          SwitchListTile(
            secondary: Icon(
              Icons.palette_outlined,
              color: settings.colorfulMode ? theme.colorScheme.primary : null,
            ),
            title: Text(l10n.colorfulMode),
            subtitle: Text(
              l10n.colorfulModeDesc,
              style: theme.textTheme.bodySmall,
            ),
            value: settings.colorfulMode,
            onChanged: (_) {
              ref.read(settingsProvider.notifier).toggleColorfulMode();
            },
          ),
          const Divider(height: 32),
          // Theme section
          _buildSectionHeader(context, l10n.colorTheme),
          const ThemeSelector(),
          const Divider(height: 32),
          // Ambient sounds section
          _buildSectionHeader(context, l10n.ambientSounds),
          const AmbientSoundSelector(),
          const Divider(height: 32),
          // Daily goal section
          _buildSectionHeader(context, l10n.dailyGoal),
          const DailyGoalSetter(),
          const Divider(height: 32),
          // Achievements section
          _buildSectionHeader(context, l10n.achievements),
          ListTile(
            leading: const Icon(Icons.emoji_events_outlined),
            title: Text(l10n.achievements),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AchievementsScreen(),
                ),
              );
            },
          ),
          const Divider(height: 32),
          // About section
          _buildSectionHeader(context, l10n.about),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.version),
            trailing: Text(
              '1.0.0',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.privacyPolicy),
            trailing: const Icon(Icons.open_in_new, size: 20),
            onTap: () {
              // TODO: Open privacy policy URL
            },
          ),
          if (ConsentService.instance.isPrivacyOptionsRequired)
            ListTile(
              leading: const Icon(Icons.cookie_outlined),
              title: const Text('Privacy Options'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ConsentService.instance.showPrivacyOptionsForm(
                  onComplete: (error) {
                    if (error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${error.message}')),
                      );
                    }
                  },
                );
              },
            ),
          ListTile(
            leading: const Icon(Icons.star_outline),
            title: Text(l10n.rateApp),
            trailing: const Icon(Icons.open_in_new, size: 20),
            onTap: () {
              // TODO: Open Play Store
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _getCurrentLocaleCode(WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    if (locale != null) {
      return locale.languageCode;
    }
    return 'en';  // Default to English
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildDurationTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int value,
    required int min,
    required int max,
    required void Function(int) onChanged,
    required AppLocalizations l10n,
    String? suffix,
  }) {
    final theme = Theme.of(context);
    
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: value > min
                ? () => onChanged(value - 1)
                : null,
          ),
          SizedBox(
            width: 60,
            child: Text(
              '$value ${suffix ?? l10n.min}',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: value < max
                ? () => onChanged(value + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
