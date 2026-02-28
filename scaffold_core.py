import os

# --- CORE LOGIC ---
core_logic_dir = "packages/core_logic/lib/src"
os.makedirs(f"{core_logic_dir}/providers", exist_ok=True)
os.makedirs(f"{core_logic_dir}/services", exist_ok=True)

# 1. Theme Provider
with open(f"{core_logic_dir}/providers/theme_provider.dart", "w") as f:
    f.write("""import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_prefs_provider.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});

class ThemeState {
  final ThemeMode mode;
  final Color seedColor;
  ThemeState({required this.mode, required this.seedColor});
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  final SharedPreferences _prefs;
  ThemeNotifier(this._prefs) : super(ThemeState(
    mode: ThemeMode.values[_prefs.getInt('theme_mode') ?? 0],
    seedColor: Color(_prefs.getInt('theme_color') ?? Colors.deepPurple.value),
  ));

  void setThemeMode(ThemeMode mode) {
    _prefs.setInt('theme_mode', mode.index);
    state = ThemeState(mode: mode, seedColor: state.seedColor);
  }

  void setSeedColor(Color color) {
    _prefs.setInt('theme_color', color.value);
    state = ThemeState(mode: state.mode, seedColor: color);
  }
}
""")

# 2. Locale Provider
with open(f"{core_logic_dir}/providers/locale_provider.dart", "w") as f:
    f.write("""import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_prefs_provider.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocaleNotifier(prefs);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final SharedPreferences _prefs;
  LocaleNotifier(this._prefs) : super(Locale(
    _prefs.getString('app_locale') ?? 'en',
  ));

  void setLocale(String languageCode) {
    _prefs.setString('app_locale', languageCode);
    state = Locale(languageCode);
  }
}
""")

# 3. Gamification / Streak Provider
with open(f"{core_logic_dir}/providers/streak_provider.dart", "w") as f:
    f.write("""import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared_prefs_provider.dart';

final streakProvider = StateNotifierProvider<StreakNotifier, int>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return StreakNotifier(prefs);
});

class StreakNotifier extends StateNotifier<int> {
  final SharedPreferences _prefs;
  StreakNotifier(this._prefs) : super(_prefs.getInt('current_streak') ?? 0) {
    _checkStreak();
  }

  void _checkStreak() {
    final lastActive = _prefs.getInt('last_active_date') ?? 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final yesterday = today - 86400000;

    if (lastActive < yesterday) {
      state = 0; // Streak broken
      _prefs.setInt('current_streak', 0);
    }
  }

  void incrementStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
    final lastActive = _prefs.getInt('last_active_date') ?? 0;

    if (lastActive < today) {
      state++;
      _prefs.setInt('current_streak', state);
      _prefs.setInt('last_active_date', today);
    }
  }
}
""")

# 4. Global Notification Service
with open(f"{core_logic_dir}/services/global_notification_service.dart", "w") as f:
    f.write("""import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
}
""")

# Update core_logic export
with open("packages/core_logic/lib/core_logic.dart", "a") as f:
    f.write("\nexport 'src/providers/theme_provider.dart';\n")
    f.write("export 'src/providers/locale_provider.dart';\n")
    f.write("export 'src/providers/streak_provider.dart';\n")
    f.write("export 'src/services/global_notification_service.dart';\n")

# --- CORE UI ---
core_ui_dir = "packages/core_ui/lib/src"
os.makedirs(f"{core_ui_dir}/widgets/gamification", exist_ok=True)
os.makedirs(f"{core_ui_dir}/widgets/settings", exist_ok=True)

# 1. Streak Badge Widget
with open(f"{core_ui_dir}/widgets/gamification/global_streak_badge.dart", "w") as f:
    f.write("""import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_logic/core_logic.dart';

class GlobalStreakBadge extends ConsumerWidget {
  const GlobalStreakBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider);
    final isActive = streak > 0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive ? Colors.orange.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, color: isActive ? Colors.orange : Colors.grey, size: 20),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isActive ? Colors.orange : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
""")

# 2. Settings Panel Widget (Theme & Locale)
with open(f"{core_ui_dir}/widgets/settings/global_settings_panel.dart", "w") as f:
    f.write("""import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_logic/core_logic.dart';

class GlobalSettingsPanel extends ConsumerWidget {
  const GlobalSettingsPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: const Icon(Icons.brightness_6),
          title: const Text('Theme'),
          trailing: DropdownButton<ThemeMode>(
            value: themeState.mode,
            items: const [
              DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
              DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
              DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
            ],
            onChanged: (mode) {
              if (mode != null) ref.read(themeProvider.notifier).setThemeMode(mode);
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.language),
          title: const Text('Language'),
          trailing: DropdownButton<String>(
            value: locale.languageCode,
            items: const [
              DropdownMenuItem(value: 'en', child: Text('English')),
              DropdownMenuItem(value: 'pt', child: Text('Português')),
              DropdownMenuItem(value: 'es', child: Text('Español')),
            ],
            onChanged: (lang) {
              if (lang != null) ref.read(localeProvider.notifier).setLocale(lang);
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.color_lens),
          title: const Text('Color Theme'),
          trailing: Wrap(
            spacing: 8,
            children: [Colors.deepPurple, Colors.blue, Colors.green, Colors.orange].map((color) {
              return GestureDetector(
                onTap: () => ref.read(themeProvider.notifier).setSeedColor(color),
                child: CircleAvatar(backgroundColor: color, radius: 12),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
""")

# Update core_ui export
with open("packages/core_ui/lib/core_ui.dart", "a") as f:
    f.write("\nexport 'src/widgets/gamification/global_streak_badge.dart';\n")
    f.write("export 'src/widgets/settings/global_settings_panel.dart';\n")

print("Core Logic and Core UI fully scaffolded with Providers and Widgets.")
