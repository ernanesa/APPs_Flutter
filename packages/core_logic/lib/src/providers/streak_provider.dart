import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_prefs_provider.dart';
import '../services/global_notification_service.dart';

class StreakData {
  final int streak;
  final int xp;
  final int level;
  StreakData({required this.streak, required this.xp, required this.level});
}

final streakProvider = NotifierProvider<StreakNotifier, StreakData>(() {
  return StreakNotifier();
});

class StreakNotifier extends Notifier<StreakData> {
  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);
  GlobalNotificationService get _notifs => ref.read(globalNotificationProvider);
  
  @override
  StreakData build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final data = StreakData(
      streak: prefs.getInt('current_streak') ?? 0,
      xp: prefs.getInt('current_xp') ?? 0,
      level: prefs.getInt('current_level') ?? 1,
    );
    
    // We can't call _checkStreak directly here because it modifies state.
    // In Notifier, we should do it in build or use Future.microtask.
    return data;
  }

  // To maintain the logic of checking streak on start
  void checkStreakOnStart() {
    final lastActive = _prefs.getInt('last_active_date') ?? 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final yesterday = today - 86400000;

    if (lastActive < yesterday) {
      state = StreakData(streak: 0, xp: state.xp, level: state.level);
      _prefs.setInt('current_streak', 0);
    }
    
    _notifs.scheduleDailyEngagementReminder();
  }

  void incrementStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final lastActive = _prefs.getInt('last_active_date') ?? 0;

    if (lastActive < today) {
      int newStreak = state.streak + 1;
      int newXp = state.xp + 50; 
      int newLevel = (newXp / 500).floor() + 1;
      
      state = StreakData(streak: newStreak, xp: newXp, level: newLevel);
      _prefs.setInt('current_streak', newStreak);
      _prefs.setInt('current_xp', newXp);
      _prefs.setInt('current_level', newLevel);
      _prefs.setInt('last_active_date', today);
    }
  }

  void reportActivity({int xpReward = 10}) {
    int newXp = state.xp + xpReward;
    int newLevel = (newXp / 500).floor() + 1;
    state = StreakData(streak: state.streak, xp: newXp, level: newLevel);
    _prefs.setInt('current_xp', newXp);
    _prefs.setInt('current_level', newLevel);
  }
  
  void recordFocusSessionCompleted() {
    reportActivity(xpReward: 20);
  }
}
