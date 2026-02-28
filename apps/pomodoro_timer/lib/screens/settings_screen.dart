import 'package:flutter/material.dart';
import 'package:core_logic/core_logic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';



import '../widgets/theme_selector.dart';
import '../widgets/ambient_sound_selector.dart';
import '../widgets/daily_goal_progress.dart';
import '../widgets/pomodoro_scaffold.dart';
import '../widgets/glass_container.dart';
import 'achievements_screen.dart';

/// Settings screen for customizing Pomodoro timer.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final isColorful = settings.colorfulMode;

    return PomodoroScaffold(
      appBar: AppBar(title: Text(l10n.settings), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: isColorful ? 16 : 0,
        ),
        children: [
          // Timer settings section
          _buildGroup(
            context,
            isColorful,
            title: l10n.timer,
            children: [
              _buildDurationTile(
                context,
                icon: Icons.psychology_outlined,
                title: l10n.focusDuration,
                value: settings.focusDurationMinutes,
                min: 1,
                max: 60,
                onChanged: (value) {
                  ref
                      .read(settingsProvider.notifier)
                      .updateFocusDuration(value);
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
                  ref
                      .read(settingsProvider.notifier)
                      .updateShortBreakDuration(value);
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
                  ref
                      .read(settingsProvider.notifier)
                      .updateLongBreakDuration(value);
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
                  ref
                      .read(settingsProvider.notifier)
                      .updateSessionsUntilLongBreak(value);
                },
                l10n: l10n,
              ),
            ],
          ),

          if (!isColorful)
            const Divider(height: 32)
          else
            const SizedBox(height: 16),

          // Auto-start section
          _buildGroup(
            context,
            isColorful,
            title: 'Auto',
            children: [
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
            ],
          ),

          if (!isColorful)
            const Divider(height: 32)
          else
            const SizedBox(height: 16),

          // Feedback section
          _buildGroup(
            context,
            isColorful,
            title: l10n.notifications,
            children: [
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
            ],
          ),

          if (!isColorful)
            const Divider(height: 32)
          else
            const SizedBox(height: 16),

          // Appearance section
          _buildGroup(
            context,
            isColorful,
            title: l10n.appearance,
            children: [
              // Language selector
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.language),
                trailing: DropdownButton<String>(
                  value: _getCurrentLocaleCode(ref, context),
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
                  color: (settings.colorfulMode && !isColorful)
                      ? theme.colorScheme.primary
                      : null,
                ),
                title: Text(l10n.colorfulMode),
                subtitle: Text(
                  l10n.colorfulModeDesc,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isColorful ? Colors.white70 : null,
                  ),
                ),
                value: settings.colorfulMode,
                onChanged: (_) {
                  ref.read(settingsProvider.notifier).toggleColorfulMode();
                },
              ),
            ],
          ),

          if (!isColorful)
            const Divider(height: 32)
          else
            const SizedBox(height: 16),

          // Theme section
          _buildGroup(
            context,
            isColorful,
            title: l10n.colorTheme,
            children: [const ThemeSelector()],
          ),

          if (!isColorful)
            const Divider(height: 32)
          else
            const SizedBox(height: 16),

          // Ambient sounds section
          _buildGroup(
            context,
            isColorful,
            title: l10n.ambientSounds,
            children: [const AmbientSoundSelector()],
          ),

          if (!isColorful)
            const Divider(height: 32)
          else
            const SizedBox(height: 16),

          // Daily goal section
          _buildGroup(
            context,
            isColorful,
            title: l10n.dailyGoal,
            children: [const DailyGoalSetter()],
          ),

          if (!isColorful)
            const Divider(height: 32)
          else
            const SizedBox(height: 16),

          // Achievements section
          _buildGroup(
            context,
            isColorful,
            title: l10n.achievements,
            children: [
              Builder(
                builder: (context) {
                  final achievements = null;
                  final unlocked = achievements
                      .where((a) => a.unlockedAt != null)
                      .length;
                  final total = achievements.length;
                  return ListTile(
                    leading: const Icon(Icons.emoji_events_outlined),
                    title: Text(l10n.achievementsProgress(unlocked, total)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AchievementsScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),

          if (!isColorful)
            const Divider(height: 32)
          else
            const SizedBox(height: 16),

          // About section
          _buildGroup(
            context,
            isColorful,
            title: l10n.about,
            children: [
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(l10n.version),
                trailing: Text(
                  '1.0.0',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isColorful
                        ? Colors.white70
                        : theme.colorScheme.onSurfaceVariant,
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
              ListTile(
                leading: const Icon(Icons.cookie_outlined),
                title: const Text('Privacy Options'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () async {
                  await ConsentService.showPrivacyOptionsForm();
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
            ],
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildGroup(
    BuildContext context,
    bool isColorful, {
    required String title,
    required List<Widget> children,
  }) {
    if (isColorful) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                fontSize: 12,
              ),
            ),
          ),
          GlassContainer(
            borderRadius: BorderRadius.circular(16),
            padding: EdgeInsets.zero,
            child: Column(children: children),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildSectionHeader(context, title), ...children],
      );
    }
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

  String _getCurrentLocaleCode(WidgetRef ref, BuildContext context) {
    final locale = ref.watch(localeProvider);
    if (locale != null) {
      if (LocaleNotifier.supportedLocales.containsKey(locale.languageCode)) {
        return locale.languageCode;
      }
    }
    // If explicit setting is null, try to match current active locale
    try {
      final current = Localizations.localeOf(context);
      if (LocaleNotifier.supportedLocales.containsKey(current.languageCode)) {
        return current.languageCode;
      }
    } catch (_) {}

    return 'en'; // Ultimate fallback
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
            onPressed: value > min ? () => onChanged(value - 1) : null,
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
            onPressed: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}
