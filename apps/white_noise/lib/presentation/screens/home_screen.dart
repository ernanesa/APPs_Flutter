import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/sound_entity.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/i18n_keys.dart';
import '../providers/mix_provider.dart';
import '../providers/sounds_provider.dart';
import '../widgets/ad_banner_widget.dart';
import '../widgets/mix_panel.dart';
import '../widgets/sound_tile.dart';
import '../widgets/streak_badge.dart';
import '../widgets/timer_selector.dart';
import 'achievements_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final mixState = ref.watch(mixProvider);
    final soundsAsync = ref.watch(soundsProvider);

    ref.listen<MixState>(mixProvider, (prev, next) {
      final message = next.errorMessage;
      if (message == null || message == prev?.errorMessage) return;

      String displayMessage = message;
      if (message.contains('Maximum 3')) {
        displayMessage = loc.mixLimitReached;
      } else if (message.contains('Mix is empty')) {
        displayMessage = loc.mixEmpty;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(displayMessage)));
    });

    final categories = [
      SoundCategory.rain,
      SoundCategory.nature,
      SoundCategory.water,
      SoundCategory.ambient,
      SoundCategory.noise,
    ];

    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const StreakBadge(),
              const SizedBox(width: 8),
              Flexible(child: Text(loc.appTitle)),
            ],
          ),
          leading: null,
          actions: [
            IconButton(
              icon: const Icon(Icons.emoji_events_outlined),
              tooltip: loc.achievements,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AchievementsScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings_outlined),
              tooltip: loc.settings,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (final category in categories)
                Tab(text: categoryName(loc, category)),
            ],
          ),
        ),
        body: Column(
          children: [
            const MixPanel(),
            const TimerSelector(),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: AdBannerWidget(),
            ),
            Expanded(
              child: soundsAsync.when(
                data: (sounds) {
                  return TabBarView(
                    children: [
                      for (final category in categories)
                        _SoundList(
                          sounds:
                              sounds
                                  .where((s) => s.category == category)
                                  .toList(),
                          selectedSoundIds:
                              mixState.mix.sounds
                                  .map((s) => s.sound.id)
                                  .toSet(),
                        ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error:
                    (error, _) =>
                        const Center(child: Icon(Icons.error_outline)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoundList extends ConsumerWidget {
  final List<SoundEntity> sounds;
  final Set<String> selectedSoundIds;

  const _SoundList({required this.sounds, required this.selectedSoundIds});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (sounds.isEmpty) {
      return const SizedBox.shrink();
    }

    return ListView.builder(
      itemCount: sounds.length,
      itemBuilder: (context, index) {
        final sound = sounds[index];
        final isSelected = selectedSoundIds.contains(sound.id);
        return SoundTile(
          sound: sound,
          isSelected: isSelected,
          onToggle: () => ref.read(mixProvider.notifier).toggleSound(sound.id),
        );
      },
    );
  }
}
