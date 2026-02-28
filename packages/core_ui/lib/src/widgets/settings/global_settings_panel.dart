import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_logic/core_logic.dart';

class GlobalSettingsPanel extends ConsumerWidget {
  const GlobalSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.brightness_6),
          title: const Text('Theme'),
          trailing: DropdownButton<ThemeMode>(
            value: themeState.mode,
            items: const [
              DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
              DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
              DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
            ],
            onChanged: (mode) {
              if (mode != null) ref.read(themeProvider.notifier).setThemeMode(mode);
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          trailing: DropdownButton<String>(
            value: locale.languageCode,
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'pt', child: Text('Português')),
              DropdownMenuItem(value: 'es', child: Text('Español')),
            ],
            onChanged: (lang) {
              if (lang != null) ref.read(localeProvider.notifier).setLocale(lang);
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.color_lens),
          title: const Text('Color Theme'),
          trailing: Wrap(
            spacing: 8,
            children: [Colors.deepPurple, Colors.blue, Colors.green, Colors.orange].map((color) {
              return GestureDetector(
                onTap: () => ref.read(themeProvider.notifier).setSeedColor(color),
                child: CircleAvatar(backgroundColor: color, radius: 12),
              );
            }).toList(),
          ),
        ),
        const Divider(),
        SwitchListTile(
          secondary: const Icon(Icons.square_foot),
          title: const Text('Imperial Units'),
          subtitle: const Text('Use lbs/inches instead of kg/cm'),
          value: ref.watch(settingsProvider).useImperialUnits,
          onChanged: (val) => ref.read(settingsProvider.notifier).setUseImperialUnits(val),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.emoji_events),
          title: const Text('Gamification'),
          subtitle: const Text('Show streaks and badges'),
          value: ref.watch(settingsProvider).enableGamification,
          onChanged: (val) => ref.read(settingsProvider.notifier).setEnableGamification(val),
        ),
        SwitchListTile(
          secondary: const Icon(Icons.vibration),
          title: const Text('Haptic Feedback'),
          subtitle: const Text('Tactile response on interactions'),
          value: ref.watch(settingsProvider).hapticEnabled,
          onChanged: (val) => ref.read(settingsProvider.notifier).setHapticEnabled(val),
        ),
      ],
    );
  }
}
