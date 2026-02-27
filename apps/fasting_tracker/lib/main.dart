import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:core_ui/core_ui.dart';
import 'presentation/providers/shared_prefs_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/providers/locale_provider.dart';
import 'presentation/screens/home_screen.dart';
import 'services/ad_service.dart';
import 'services/consent_service.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final sharedPrefs = await SharedPreferences.getInstance();

  // Initialize Consent (GDPR)
  await ConsentService.gatherConsent();

  // Initialize Ads only if allowed
  if (ConsentService.canRequestAds) {
    await AdService.initialize();
    AdService.loadAppOpenAd();
  }

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(sharedPrefs)],
      child: const FastingTrackerApp(),
    ),
  );
}

class FastingTrackerApp extends ConsumerStatefulWidget {
  const FastingTrackerApp({super.key});

  @override
  ConsumerState<FastingTrackerApp> createState() => _FastingTrackerAppState();
}

class _FastingTrackerAppState extends ConsumerState<FastingTrackerApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationServiceProvider).initialize().then((_) {
        ref.read(notificationServiceProvider).requestPermissions();
      });
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
    final selectedTheme = ref.watch(themeProvider);
    final selectedLocale = ref.watch(localeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fasting Tracker',
      locale: selectedLocale,
      theme: AppTheme.lightTheme(selectedTheme.primaryColor),
      darkTheme: AppTheme.darkTheme(selectedTheme.primaryColor),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
    );
  }
}
