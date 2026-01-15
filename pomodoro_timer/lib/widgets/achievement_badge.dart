import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/achievement.dart';

/// Widget displaying a single achievement badge.
class AchievementBadge extends StatelessWidget {
  final Achievement achievement;
  final bool showDetails;
  final VoidCallback? onTap;

  const AchievementBadge({
    super.key,
    required this.achievement,
    this.showDetails = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isUnlocked = achievement.isUnlocked;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isUnlocked
              ? achievement.color.withOpacity(0.15)
              : theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnlocked
                ? achievement.color.withOpacity(0.5)
                : theme.colorScheme.outline.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with optional lock overlay
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? achievement.color.withOpacity(0.2)
                        : theme.colorScheme.surfaceContainerHighest,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    achievement.icon,
                    size: 20,
                    color: isUnlocked
                        ? achievement.color
                        : theme.colorScheme.outline.withOpacity(0.5),
                  ),
                ),
                if (!isUnlocked)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock,
                        size: 10,
                        color: theme.colorScheme.outline.withOpacity(0.7),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            // Title - expanded to take remaining space
            Expanded(
              child: Center(
                child: Text(
                  _getLocalizedTitle(l10n, achievement.titleKey),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 9,
                    height: 1.1,
                    color: isUnlocked
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLocalizedTitle(AppLocalizations l10n, String key) {
    // Map keys to localized strings
    final Map<String, String> titles = {
      'achievementFirstSession': l10n.achievementFirstSession,
      'achievementSessions10': l10n.achievementSessions10,
      'achievementSessions50': l10n.achievementSessions50,
      'achievementSessions100': l10n.achievementSessions100,
      'achievementSessions500': l10n.achievementSessions500,
      'achievementStreak3': l10n.achievementStreak3,
      'achievementStreak7': l10n.achievementStreak7,
      'achievementStreak30': l10n.achievementStreak30,
      'achievementTime1h': l10n.achievementTime1h,
      'achievementTime10h': l10n.achievementTime10h,
      'achievementTime100h': l10n.achievementTime100h,
      'achievementEarlyBird': l10n.achievementEarlyBird,
      'achievementNightOwl': l10n.achievementNightOwl,
      'achievementWeekendWarrior': l10n.achievementWeekendWarrior,
    };
    return titles[key] ?? key;
  }
}

/// Widget for displaying achievement unlock notification.
class AchievementUnlockedDialog extends StatelessWidget {
  final Achievement achievement;

  const AchievementUnlockedDialog({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Trophy animation placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: achievement.color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievement.icon,
                size: 48,
                color: achievement.color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.achievementUnlocked,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _getTitle(l10n),
              style: theme.textTheme.titleMedium?.copyWith(
                color: achievement.color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getDescription(l10n),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.greatJob),
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle(AppLocalizations l10n) {
    final Map<String, String> titles = {
      'achievementFirstSession': l10n.achievementFirstSession,
      'achievementSessions10': l10n.achievementSessions10,
      'achievementSessions50': l10n.achievementSessions50,
      'achievementSessions100': l10n.achievementSessions100,
      'achievementSessions500': l10n.achievementSessions500,
      'achievementStreak3': l10n.achievementStreak3,
      'achievementStreak7': l10n.achievementStreak7,
      'achievementStreak30': l10n.achievementStreak30,
      'achievementTime1h': l10n.achievementTime1h,
      'achievementTime10h': l10n.achievementTime10h,
      'achievementTime100h': l10n.achievementTime100h,
      'achievementEarlyBird': l10n.achievementEarlyBird,
      'achievementNightOwl': l10n.achievementNightOwl,
      'achievementWeekendWarrior': l10n.achievementWeekendWarrior,
    };
    return titles[achievement.titleKey] ?? achievement.titleKey;
  }

  String _getDescription(AppLocalizations l10n) {
    final Map<String, String> descriptions = {
      'achievementFirstSessionDesc': l10n.achievementFirstSessionDesc,
      'achievementSessions10Desc': l10n.achievementSessions10Desc,
      'achievementSessions50Desc': l10n.achievementSessions50Desc,
      'achievementSessions100Desc': l10n.achievementSessions100Desc,
      'achievementSessions500Desc': l10n.achievementSessions500Desc,
      'achievementStreak3Desc': l10n.achievementStreak3Desc,
      'achievementStreak7Desc': l10n.achievementStreak7Desc,
      'achievementStreak30Desc': l10n.achievementStreak30Desc,
      'achievementTime1hDesc': l10n.achievementTime1hDesc,
      'achievementTime10hDesc': l10n.achievementTime10hDesc,
      'achievementTime100hDesc': l10n.achievementTime100hDesc,
      'achievementEarlyBirdDesc': l10n.achievementEarlyBirdDesc,
      'achievementNightOwlDesc': l10n.achievementNightOwlDesc,
      'achievementWeekendWarriorDesc': l10n.achievementWeekendWarriorDesc,
    };
    return descriptions[achievement.descriptionKey] ?? achievement.descriptionKey;
  }
}
