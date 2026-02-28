import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:fasting_tracker/l10n/app_localizations.dart';
import '../../domain/entities/achievement.dart';
import 'package:core_logic/core_logic.dart';


/// Achievements screen
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final achievementsState = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.achievements)),
      body: achievementsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Progress header
                Container(
                  padding: const EdgeInsets.all(24),
                  color: theme.colorScheme.primaryContainer,
                  child: Column(
                    children: [
                      Text('🏆', style: const TextStyle(fontSize: 48)),
                      const SizedBox(height: 8),
                      Text(
                        '${achievementsState.unlockedCount}/${achievementsState.totalCount}',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.achievementsProgress(
                          achievementsState.unlockedCount,
                          achievementsState.totalCount,
                        ),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: achievementsState.progress,
                        backgroundColor: theme.colorScheme.onPrimaryContainer
                            .withValues(alpha: 0.2),
                        color: theme.colorScheme.onPrimaryContainer,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                // Achievements list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: achievementsState.achievements.length,
                    itemBuilder: (context, index) {
                      final achievement = achievementsState.achievements[index];
                      return _AchievementCard(
                        achievement: achievement,
                        l10n: l10n,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final AppLocalizations l10n;

  const _AchievementCard({required this.achievement, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnlocked = achievement.isUnlocked;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isUnlocked
          ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5)
          : theme.colorScheme.surfaceContainerHighest,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isUnlocked
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              isUnlocked ? achievement.icon : '🔒',
              style: TextStyle(
                fontSize: 24,
                color: isUnlocked ? null : Colors.grey,
              ),
            ),
          ),
        ),
        title: Text(
          _getTitle(achievement.titleKey),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isUnlocked ? null : theme.colorScheme.onSurfaceVariant,
          ),
        ),
        subtitle: Text(
          _getDescription(achievement.descriptionKey),
          style: TextStyle(
            color: isUnlocked ? null : theme.colorScheme.onSurfaceVariant,
          ),
        ),
        trailing: isUnlocked
            ? Icon(Icons.check_circle, color: theme.colorScheme.primary)
            : null,
      ),
    );
  }

  String _getTitle(String key) {
    switch (key) {
      case 'achievementFirstFast':
        return l10n.achievementFirstFast;
      case 'achievement10Fasts':
        return l10n.achievement10Fasts;
      case 'achievement25Fasts':
        return l10n.achievement25Fasts;
      case 'achievement50Fasts':
        return l10n.achievement50Fasts;
      case 'achievement100Fasts':
        return l10n.achievement100Fasts;
      case 'achievementStreak3':
        return l10n.achievementStreak3;
      case 'achievementStreak7':
        return l10n.achievementStreak7;
      case 'achievementStreak14':
        return l10n.achievementStreak14;
      case 'achievementStreak30':
        return l10n.achievementStreak30;
      case 'achievement24Hours':
        return l10n.achievement24Hours;
      case 'achievement100Hours':
        return l10n.achievement100Hours;
      case 'achievement500Hours':
        return l10n.achievement500Hours;
      case 'achievementKetosis':
        return l10n.achievementKetosis;
      case 'achievementAutophagy':
        return l10n.achievementAutophagy;
      default:
        return key;
    }
  }

  String _getDescription(String key) {
    switch (key) {
      case 'achievementFirstFastDesc':
        return l10n.achievementFirstFastDesc;
      case 'achievement10FastsDesc':
        return l10n.achievement10FastsDesc;
      case 'achievement25FastsDesc':
        return l10n.achievement25FastsDesc;
      case 'achievement50FastsDesc':
        return l10n.achievement50FastsDesc;
      case 'achievement100FastsDesc':
        return l10n.achievement100FastsDesc;
      case 'achievementStreak3Desc':
        return l10n.achievementStreak3Desc;
      case 'achievementStreak7Desc':
        return l10n.achievementStreak7Desc;
      case 'achievementStreak14Desc':
        return l10n.achievementStreak14Desc;
      case 'achievementStreak30Desc':
        return l10n.achievementStreak30Desc;
      case 'achievement24HoursDesc':
        return l10n.achievement24HoursDesc;
      case 'achievement100HoursDesc':
        return l10n.achievement100HoursDesc;
      case 'achievement500HoursDesc':
        return l10n.achievement500HoursDesc;
      case 'achievementKetosisDesc':
        return l10n.achievementKetosisDesc;
      case 'achievementAutophagyDesc':
        return l10n.achievementAutophagyDesc;
      default:
        return key;
    }
  }
}
