import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import '../providers/achievements_provider.dart';
import '../../domain/entities/achievement.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final achievements = ref.watch(achievementsProvider);

    final unlockedCount = achievements.where((a) => a.isUnlocked).length;
    final progress = unlockedCount / achievements.length;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.achievements),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(90),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.achievementsProgress,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$unlockedCount/${achievements.length} ${l10n.unlocked}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(text: l10n.categoryCalculations),
                    Tab(text: l10n.categoryStreak),
                    Tab(text: l10n.categoryAmounts),
                    Tab(text: l10n.categorySpecial),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _buildAchievementGrid(
              context,
              l10n,
              achievements
                  .where((a) => a.category == AchievementCategory.calculations)
                  .toList(),
            ),
            _buildAchievementGrid(
              context,
              l10n,
              achievements
                  .where((a) => a.category == AchievementCategory.streak)
                  .toList(),
            ),
            _buildAchievementGrid(
              context,
              l10n,
              achievements
                  .where((a) => a.category == AchievementCategory.amounts)
                  .toList(),
            ),
            _buildAchievementGrid(
              context,
              l10n,
              achievements
                  .where((a) => a.category == AchievementCategory.special)
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementGrid(
    BuildContext context,
    AppLocalizations l10n,
    List<Achievement> achievements,
  ) {
    if (achievements.isEmpty) {
      return Center(
        child: Text(
          l10n.noAchievements,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _buildAchievementCard(context, l10n, achievement);
      },
    );
  }

  Widget _buildAchievementCard(
    BuildContext context,
    AppLocalizations l10n,
    Achievement achievement,
  ) {
    final isLocked = !achievement.isUnlocked;
    final theme = Theme.of(context);

    return Card(
      elevation: isLocked ? 1 : 4,
      child: InkWell(
        onTap: () => _showAchievementDetails(context, l10n, achievement),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getAchievementIcon(achievement.id),
                    size: 48,
                    color: isLocked ? Colors.grey : theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getAchievementTitle(l10n, achievement.id),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isLocked ? Colors.grey : null,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _getAchievementDescription(l10n, achievement.id),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isLocked ? Colors.grey : null,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (achievement.unlockedAt != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      DateFormat.yMd().format(achievement.unlockedAt!),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(Icons.lock, size: 32, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showAchievementDetails(
    BuildContext context,
    AppLocalizations l10n,
    Achievement achievement,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(_getAchievementIcon(achievement.id)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_getAchievementTitle(l10n, achievement.id)),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_getAchievementDescription(l10n, achievement.id)),
                if (achievement.isUnlocked &&
                    achievement.unlockedAt != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    '${l10n.unlockedOn}: ${DateFormat.yMd().format(achievement.unlockedAt!)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else ...[
                  const SizedBox(height: 16),
                  Text(
                    l10n.notUnlockedYet,
                    style: const TextStyle(color: Colors.grey),
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

  IconData _getAchievementIcon(String id) {
    switch (id) {
      case 'first_calculation':
        return Icons.rocket_launch;
      case 'calculation_10':
        return Icons.trending_up;
      case 'calculation_50':
        return Icons.bar_chart;
      case 'calculation_100':
        return Icons.emoji_events;
      case 'streak_3':
        return Icons.local_fire_department;
      case 'streak_7':
        return Icons.whatshot;
      case 'streak_30':
        return Icons.celebration;
      case 'million':
        return Icons.attach_money;
      case 'ten_million':
        return Icons.monetization_on;
      case 'long_term':
        return Icons.access_time;
      default:
        return Icons.star;
    }
  }

  String _getAchievementTitle(AppLocalizations l10n, String id) {
    switch (id) {
      case 'first_calculation':
        return l10n.achievementFirstCalc;
      case 'calculation_10':
        return l10n.achievement10Calcs;
      case 'calculation_50':
        return l10n.achievement50Calcs;
      case 'calculation_100':
        return l10n.achievement100Calcs;
      case 'streak_3':
        return l10n.achievementStreak3;
      case 'streak_7':
        return l10n.achievementStreak7;
      case 'streak_30':
        return l10n.achievementStreak30;
      case 'million':
        return l10n.achievementMillion;
      case 'ten_million':
        return l10n.achievementTenMillion;
      case 'long_term':
        return l10n.achievementLongTerm;
      default:
        return id;
    }
  }

  String _getAchievementDescription(AppLocalizations l10n, String id) {
    switch (id) {
      case 'first_calculation':
        return l10n.achievementFirstCalcDesc;
      case 'calculation_10':
        return l10n.achievement10CalcsDesc;
      case 'calculation_50':
        return l10n.achievement50CalcsDesc;
      case 'calculation_100':
        return l10n.achievement100CalcsDesc;
      case 'streak_3':
        return l10n.achievementStreak3Desc;
      case 'streak_7':
        return l10n.achievementStreak7Desc;
      case 'streak_30':
        return l10n.achievementStreak30Desc;
      case 'million':
        return l10n.achievementMillionDesc;
      case 'ten_million':
        return l10n.achievementTenMillionDesc;
      case 'long_term':
        return l10n.achievementLongTermDesc;
      default:
        return '';
    }
  }
}
