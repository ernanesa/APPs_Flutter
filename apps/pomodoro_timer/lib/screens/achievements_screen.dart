import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/achievement.dart';

import '../providers/settings_provider.dart';
import '../widgets/achievement_badge.dart';
import '../widgets/pomodoro_scaffold.dart';
import '../widgets/glass_container.dart';
import 'package:core_logic/core_logic.dart';

/// Screen displaying all achievements.
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievements = ref.watch(achievementsProvider);
    final settings = ref.watch(settingsProvider);
    final unlockedCount = achievements.where((a) => a.isUnlocked).length;
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isColorful = settings.colorfulMode;

    // Group achievements by category
    final sessionAchievements = achievements
        .where((a) => a.category == AchievementCategory.sessions)
        .toList();
    final streakAchievements = achievements
        .where((a) => a.category == AchievementCategory.streak)
        .toList();
    final timeAchievements = achievements
        .where((a) => a.category == AchievementCategory.time)
        .toList();
    final specialAchievements = achievements
        .where((a) => a.category == AchievementCategory.special)
        .toList();

    return PomodoroScaffold(
      appBar: AppBar(title: Text(l10n.achievements), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress header
            _buildProgressHeader(
              context,
              unlockedCount,
              achievements.length,
              l10n,
              theme,
              isColorful,
            ),
            const SizedBox(height: 24),

            // Sessions category
            if (sessionAchievements.isNotEmpty) ...[
              _buildCategoryHeader(
                context,
                l10n.categorySession,
                Icons.timer,
                theme,
                isColorful,
              ),
              const SizedBox(height: 12),
              _buildAchievementGrid(sessionAchievements, isColorful),
              const SizedBox(height: 24),
            ],

            // Streak category
            if (streakAchievements.isNotEmpty) ...[
              _buildCategoryHeader(
                context,
                l10n.categoryStreak,
                Icons.local_fire_department,
                theme,
                isColorful,
              ),
              const SizedBox(height: 12),
              _buildAchievementGrid(streakAchievements, isColorful),
              const SizedBox(height: 24),
            ],

            // Time category
            if (timeAchievements.isNotEmpty) ...[
              _buildCategoryHeader(
                context,
                l10n.categoryTime,
                Icons.schedule,
                theme,
                isColorful,
              ),
              const SizedBox(height: 12),
              _buildAchievementGrid(timeAchievements, isColorful),
              const SizedBox(height: 24),
            ],

            // Special category
            if (specialAchievements.isNotEmpty) ...[
              _buildCategoryHeader(
                context,
                l10n.categorySpecial,
                Icons.star,
                theme,
                isColorful,
              ),
              const SizedBox(height: 12),
              _buildAchievementGrid(specialAchievements, isColorful),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader(
    BuildContext context,
    int unlocked,
    int total,
    AppLocalizations l10n,
    ThemeData theme,
    bool isColorful,
  ) {
    final progress = total > 0 ? unlocked / total : 0.0;

    if (isColorful) {
      return GlassContainer(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Text(
                  l10n.achievementsProgress(unlocked, total),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Progress bar
            Stack(
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress,
                  child: Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withValues(alpha: 0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${(progress * 100).toInt()}%',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events,
                color: theme.colorScheme.primary,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                l10n.achievementsProgress(unlocked, total),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              FractionallySizedBox(
                widthFactor: progress,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primary,
                        theme.colorScheme.tertiary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toInt()}%',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(
    BuildContext context,
    String title,
    IconData icon,
    ThemeData theme,
    bool isColorful,
  ) {
    final color = isColorful ? Colors.white : theme.colorScheme.primary;
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementGrid(
    List<Achievement> achievements,
    bool isColorful,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return AchievementBadge(
          achievement: achievement,
          onTap: () => _showAchievementDetails(context, achievement),
          // We can optionally pass isColorful to badge if we update it
        );
      },
    );
  }

  void _showAchievementDetails(BuildContext context, Achievement achievement) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: achievement.isUnlocked
                    ? achievement.color.withValues(alpha: 0.2)
                    : theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievement.icon,
                size: 48,
                color: achievement.isUnlocked
                    ? achievement.color
                    : theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _getTitle(l10n, achievement.titleKey),
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: achievement.isUnlocked
                    ? achievement.color
                    : theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getDescription(l10n, achievement.descriptionKey),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (!achievement.isUnlocked) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 16,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    l10n.notUnlockedYet,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ] else if (achievement.unlockedAt != null) ...[
              const SizedBox(height: 16),
              Text(
                l10n.unlockedOn(_formatDate(achievement.unlockedAt!)),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getTitle(AppLocalizations l10n, String key) {
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

  String _getDescription(AppLocalizations l10n, String key) {
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
    return descriptions[key] ?? key;
  }
}
