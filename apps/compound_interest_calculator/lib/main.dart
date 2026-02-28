import 'package:flutter/material.dart';
import 'package:core_logic/core_logic.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';



import 'presentation/screens/calculator_screen.dart';

import 'package:core_ui/core_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // GDPR consent FIRST
  await ConsentService.gatherConsent();

  // Initialize ads only if consent allows
  final canReq = await ConsentService.canRequestAds();
  if (canReq) {
    await AdService.initialize();
    AdService.loadAppOpenAd();
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ConsentService.canRequestAds().then((canRequest) {
        if (canRequest) {
          AdService.showAppOpenAdIfAvailable();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTheme = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Compound Interest Calculator',
      theme: AppTheme.lightTheme(selectedTheme.seedColor),
      darkTheme: AppTheme.darkTheme(selectedTheme.seedColor),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('pt'), // Portuguese
        Locale('es'), // Spanish
        Locale('de'), // German
        Locale('fr'), // French
        Locale('zh'), // Chinese
        Locale('ru'), // Russian
        Locale('ja'), // Japanese
        Locale('ar'), // Arabic
        Locale('hi'), // Hindi
        Locale('bn'), // Bengali
        Locale('it'), // Italian
      ],
      home: const CalculatorScreen(),
    );
  }
}
