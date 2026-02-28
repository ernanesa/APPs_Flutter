import 'package:flutter/material.dart';
import 'package:core_logic/core_logic.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:core_ui/core_ui.dart';
import 'l10n/app_localizations.dart';
import 'providers/settings_provider.dart';


import 'screens/timer_screen.dart';


import 'services/sound_service.dart';
import 'utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize consent and ads
  await _initializeAds();

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const PomodoroApp(),
    ),
  );
}

Future<void> _initializeAds() async {
  // Initialize AdMob
  await AdService.initialize();

  // Gather consent (GDPR)
  await ConsentService.gatherConsent();
}

class PomodoroApp extends ConsumerStatefulWidget {
  const PomodoroApp({super.key});

  @override
  ConsumerState<PomodoroApp> createState() => _PomodoroAppState();
}

class _PomodoroAppState extends ConsumerState<PomodoroApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    SoundService.instance.dispose();
    AdService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AdService.showAppOpenAdIfAvailable();
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final selectedTheme = ref.watch(selectedThemeProvider);
    final locale = ref.watch(localeProvider);

    // Update sound service with settings
    SoundService.instance.setSoundEnabled(settings.soundEnabled);
    SoundService.instance.setVibrationEnabled(settings.vibrationEnabled);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro Timer',
      locale: locale,
      theme: AppTheme.lightTheme(selectedTheme.seedColor),
      darkTheme: AppTheme.darkTheme(selectedTheme.seedColor),
      themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const TimerScreen(),
    );
  }
}
