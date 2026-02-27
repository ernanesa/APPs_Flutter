import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/timer_entity.dart';
import '../../l10n/app_localizations.dart';
import '../providers/settings_provider.dart';
import 'section_header.dart';

class TimerSelector extends ConsumerWidget {
  const TimerSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);

    final durations = TimerEntity.commonDurations;
    final selected = settings.timer.isEnabled ? settings.timer.duration : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            SectionHeader(title: loc.timer),
            const SizedBox(height: 8),
            DropdownButton<Duration?>(
              isExpanded: true,
              value: selected,
              items: [
                DropdownMenuItem<Duration?>(
                  value: null,
                  child: Text(loc.noTimer),
                ),
                ...durations.map((duration) {
                  return DropdownMenuItem<Duration?>(
                    value: duration,
                    child: Text('${duration.inMinutes} ${loc.minutes}'),
                  );
                }),
              ],
              onChanged:
                  settings.isLoading
                      ? null
                      : (value) {
                        if (value == null) {
                          ref.read(settingsProvider.notifier).disableTimer();
                        } else {
                          ref
                              .read(settingsProvider.notifier)
                              .setTimer(value, enabled: true);
                        }
                      },
            ),
          ],
        ),
      ),
    );
  }
}
