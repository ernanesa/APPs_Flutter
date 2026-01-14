import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/ambient_sound.dart';
import '../providers/ambient_sound_provider.dart';

/// Widget for selecting ambient sounds.
class AmbientSoundSelector extends ConsumerWidget {
  const AmbientSoundSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSound = ref.watch(selectedAmbientSoundProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            l10n.ambientSounds,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: AmbientSounds.all.length,
            itemBuilder: (context, index) {
              final sound = AmbientSounds.all[index];
              final isSelected = selectedSound.id == sound.id;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _SoundItem(
                  sound: sound,
                  isSelected: isSelected,
                  onTap: () {
                    ref.read(selectedAmbientSoundProvider.notifier)
                        .selectSound(sound);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SoundItem extends StatelessWidget {
  final AmbientSound sound;
  final bool isSelected;
  final VoidCallback onTap;

  const _SoundItem({
    required this.sound,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected
              ? sound.color.withOpacity(0.2)
              : theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? sound.color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              sound.icon,
              color: isSelected ? sound.color : theme.colorScheme.onSurface,
              size: 32,
            ),
            const SizedBox(height: 4),
            Text(
              _getLocalizedName(l10n, sound.nameKey),
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected ? sound.color : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedName(AppLocalizations l10n, String key) {
    final Map<String, String> names = {
      'soundSilence': l10n.soundSilence,
      'soundRain': l10n.soundRain,
      'soundForest': l10n.soundForest,
      'soundOcean': l10n.soundOcean,
      'soundCafe': l10n.soundCafe,
      'soundFireplace': l10n.soundFireplace,
      'soundWhiteNoise': l10n.soundWhiteNoise,
      'soundThunder': l10n.soundThunder,
    };
    return names[key] ?? key;
  }
}

/// Compact sound button for timer screen.
class AmbientSoundButton extends ConsumerWidget {
  const AmbientSoundButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedSound = ref.watch(selectedAmbientSoundProvider);
    final isPlaying = ref.watch(isAmbientPlayingProvider);
    final theme = Theme.of(context);

    return IconButton(
      onPressed: () => _showSoundPicker(context),
      icon: Stack(
        children: [
          Icon(
            selectedSound.icon,
            color: isPlaying ? selectedSound.color : theme.colorScheme.onSurface,
          ),
          if (isPlaying)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.surface,
                    width: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
      tooltip: 'Ambient Sound',
    );
  }

  void _showSoundPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: AmbientSoundSelector(),
      ),
    );
  }
}
