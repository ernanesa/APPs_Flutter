import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'providers/settings_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'screens/timer_screen.dart';
import 'services/ad_service.dart';
import 'services/consent_service.dart';
import 'services/sound_service.dart';

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
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const PomodoroApp(),
    ),
  );
}

Future<void> _initializeAds() async {
  // Initialize AdMob
  await AdService.instance.initialize();

  // Gather consent (GDPR)
  ConsentService.instance.gatherConsent(
    onConsentComplete: (error) {
      if (error != null) {
        debugPrint('Consent error: ${error.message}');
      }
    },
  );
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
    AdService.instance.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AdService.instance.showAppOpenAdIfAvailable();
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: selectedTheme.primaryColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: selectedTheme.primaryColor,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
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
