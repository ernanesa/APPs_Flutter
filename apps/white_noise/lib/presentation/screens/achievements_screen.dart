import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/app_localizations.dart';

import '../widgets/achievement_tile.dart';
import 'package:core_logic/core_logic.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final state = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(loc.achievements)),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: state.achievements.length,
              itemBuilder: (context, index) {
                final achievement = state.achievements[index];
                return AchievementTile(achievement: achievement);
              },
            ),
    );
  }
}
