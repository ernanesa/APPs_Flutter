import 'package:flutter/material.dart';

import '../../domain/entities/achievement_entity.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/i18n_keys.dart';

class AchievementTile extends StatelessWidget {
  final AchievementEntity achievement;

  const AchievementTile({super.key, required this.achievement});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isUnlocked = achievement.isUnlocked;

    return ListTile(
      leading: Icon(
        isUnlocked ? Icons.emoji_events : Icons.lock_outline,
        color: isUnlocked ? theme.colorScheme.primary : theme.disabledColor,
      ),
      title: Text(achievementTitle(loc, achievement.titleKey)),
      subtitle: Text(achievementDescription(loc, achievement.descriptionKey)),
      trailing: isUnlocked
          ? Text(
              loc.achievementUnlocked,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            )
          : null,
    );
  }
}
