import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/i18n_keys.dart';
import '../providers/mix_provider.dart';
import '../providers/settings_provider.dart';
import 'section_header.dart';

class MixPanel extends ConsumerWidget {
  const MixPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final mixState = ref.watch(mixProvider);
    final settings = ref.watch(settingsProvider);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: loc.mix,
              trailing: IconButton(
                onPressed: mixState.mix.sounds.isEmpty
                    ? null
                    : () => ref.read(mixProvider.notifier).clearMix(),
                icon: const Icon(Icons.clear_all),
                tooltip: loc.stop,
              ),
            ),
            const SizedBox(height: 8),
            if (mixState.mix.sounds.isEmpty)
              Text(loc.mixEmpty)
            else
              Column(
                children: mixState.mix.sounds.map((mixSound) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(soundName(loc, mixSound.sound.nameKey)),
                        ),
                        Expanded(
                          child: Slider(
                            value: mixSound.volume,
                            onChanged: (value) => ref
                                .read(mixProvider.notifier)
                                .updateVolume(mixSound.sound.id, value),
                          ),
                        ),
                        IconButton(
                          onPressed: () => ref
                              .read(mixProvider.notifier)
                              .toggleSound(mixSound.sound.id),
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: mixState.isLoading
                        ? null
                        : (mixState.isPlaying
                            ? () => ref.read(mixProvider.notifier).stopMix()
                            : () => ref.read(mixProvider.notifier).playMix()),
                    icon: Icon(
                      mixState.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                    label: Text(
                      mixState.isPlaying ? loc.pause : loc.play,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: mixState.isLoading
                        ? null
                        : () => ref.read(mixProvider.notifier).stopMix(),
                    icon: const Icon(Icons.stop),
                    label: Text(loc.stop),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(loc.volume, style: theme.textTheme.labelLarge),
                const SizedBox(width: 12),
                Expanded(
                  child: Slider(
                    value: settings.globalVolume,
                    onChanged: settings.isLoading
                        ? null
                        : (value) => ref
                            .read(settingsProvider.notifier)
                            .setGlobalVolume(value),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
