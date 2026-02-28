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

final streakProvider = StateNotifierProvider<StreakNotifier, StreakData>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  final notifs = ref.watch(globalNotificationProvider);
  return StreakNotifier(prefs, notifs);
});

class StreakNotifier extends StateNotifier<StreakData> {
  final SharedPreferences _prefs;
  final GlobalNotificationService _notifs;
  
  StreakNotifier(this._prefs, this._notifs) : super(StreakData(
    streak: _prefs.getInt('current_streak') ?? 0,
    xp: _prefs.getInt('current_xp') ?? 0,
    level: _prefs.getInt('current_level') ?? 1,
  )) {
    _checkStreak();
  }

  void _checkStreak() {
    final lastActive = _prefs.getInt('last_active_date') ?? 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final yesterday = today - 86400000;

    if (lastActive < yesterday) {
      state = StreakData(streak: 0, xp: state.xp, level: state.level);
      _prefs.setInt('current_streak', 0);
    }
    
    // Agendar notificação de engajamento diário
    _notifs.scheduleDailyEngagementReminder();
  }

  void incrementStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final lastActive = _prefs.getInt('last_active_date') ?? 0;

    if (lastActive < today) {
      int newStreak = state.streak + 1;
      int newXp = state.xp + 50; // Ganha 50 XP por dia
      int newLevel = (newXp / 500).floor() + 1; // A cada 500 XP sobe de nível
      
      state = StreakData(streak: newStreak, xp: newXp, level: newLevel);
      _prefs.setInt('current_streak', newStreak);
      _prefs.setInt('current_xp', newXp);
      _prefs.setInt('current_level', newLevel);
      _prefs.setInt('last_active_date', today);
    }
  }

  // Usado pelos apps para relatar atividade e ganhar pontos
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
