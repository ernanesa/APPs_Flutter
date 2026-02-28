import os
import re

APPS_DIR = 'apps'
FEATURES_DIR = 'packages/features'
CORE_LOGIC_DIR = 'packages/core_logic'

# 1. Expandir GlobalNotificationService
notification_code = """import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalNotificationProvider = Provider<GlobalNotificationService>((ref) {
  return GlobalNotificationService();
});

class GlobalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(requestBadgePermission: false);
    const initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
    
    await _plugin.initialize(initSettings);
  }

  Future<void> requestPermissions() async {
    await _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    await _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> showNotification({required int id, required String title, required String body}) async {
    const androidDetails = AndroidNotificationDetails('gamification_channel', 'Engagement', importance: Importance.max, priority: Priority.high);
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);
    await _plugin.show(id, title, body, details);
  }

  // NOVO: Agendamento de Engajamento
  Future<void> scheduleDailyEngagementReminder() async {
    // Implementação simplificada para demonstração de engajamento
    // Em um cenário real, usaria timezone e cron.
    await showNotification(
      id: 999,
      title: '🔥 Não perca sua ofensiva!',
      body: 'Volte ao app para manter seu Streak e ganhar mais XP hoje.',
    );
  }
}
"""

with open(f'{CORE_LOGIC_DIR}/lib/src/services/global_notification_service.dart', 'w') as f:
    f.write(notification_code)

# 2. Expandir StreakProvider (Gamificação com XP)
streak_code = """import 'package:flutter_riverpod/flutter_riverpod.dart';
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
"""

with open(f'{CORE_LOGIC_DIR}/lib/src/providers/streak_provider.dart', 'w') as f:
    f.write(streak_code)


# 3. Remover provedores locais e consertar imports
providers_to_delete = ['theme_provider.dart', 'streak_provider.dart', 'achievements_provider.dart']
import_pattern = re.compile(r"import\s+['\"].*?(theme_provider|streak_provider|achievements_provider)\.dart['\"];")
core_import = "import 'package:core_logic/core_logic.dart';"

def process_directory(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file in providers_to_delete:
                filepath = os.path.join(root, file)
                print(f"Deletando {filepath}")
                os.remove(filepath)
            elif file.endswith('.dart'):
                filepath = os.path.join(root, file)
                with open(filepath, 'r') as f:
                    content = f.read()
                
                if import_pattern.search(content):
                    # Remove old imports
                    new_content = import_pattern.sub('', content)
                    # Add core import if not exists
                    if core_import not in new_content:
                        # Find the last import
                        lines = new_content.split('\n')
                        last_import_idx = -1
                        for i, line in enumerate(lines):
                            if line.startswith('import '):
                                last_import_idx = i
                        
                        if last_import_idx != -1:
                            lines.insert(last_import_idx + 1, core_import)
                            new_content = '\n'.join(lines)
                        else:
                            new_content = core_import + '\n' + new_content
                    
                    # Consertar AppThemeType -> ThemeMode (Adaptação básica)
                    new_content = new_content.replace('AppThemeType', 'ThemeMode')
                    
                    with open(filepath, 'w') as f:
                        f.write(new_content)

process_directory(APPS_DIR)
process_directory(FEATURES_DIR)

print("Refatoração em massa concluída com sucesso.")
