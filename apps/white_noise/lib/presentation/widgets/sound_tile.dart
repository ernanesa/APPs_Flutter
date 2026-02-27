import 'package:flutter/material.dart';

import '../../domain/entities/sound_entity.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/i18n_keys.dart';

class SoundTile extends StatelessWidget {
  final SoundEntity sound;
  final bool isSelected;
  final VoidCallback onToggle;

  const SoundTile({
    super.key,
    required this.sound,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return ListTile(
      title: Text(soundName(loc, sound.nameKey)),
      subtitle: Text(categoryName(loc, sound.category)),
      trailing: IconButton(
        onPressed: onToggle,
        icon: Icon(isSelected ? Icons.remove_circle : Icons.add_circle),
        tooltip: isSelected ? loc.stop : loc.mix,
        color: isSelected ? theme.colorScheme.error : theme.colorScheme.primary,
      ),
    );
  }
}
