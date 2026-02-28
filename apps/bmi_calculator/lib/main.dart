import 'package:flutter/material.dart';
import 'package:core_logic/core_logic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'l10n/app_localizations.dart';
import 'screens/home_screen.dart';

import 'package:core_ui/core_ui.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // GDPR/UE: coletar consentimento antes de inicializar/carregar anúncios.
  await ConsentService.gatherConsent();
  final canRequestAds = await ConsentService.canRequestAds();

  if (canRequestAds) {
    // Inicializar AdMob SDK
    await AdService.initialize();

    // Pré-carregar App Open Ad em background
    AdService.loadAppOpenAd();

    // Pré-carregar Interstitial Ad
    AdService.preloadInterstitialAd();
  } else {
    AdService.disableAds();
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
    AdService.dispose(); // Limpar recursos de ads
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Mostrar App Open Ad quando app volta ao foreground
      AdService.showAppOpenAdIfAvailable();
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          theme: AppTheme.lightTheme(Colors.blue, dynamicColorScheme: lightDynamic),
          darkTheme: AppTheme.darkTheme(Colors.blue, dynamicColorScheme: darkDynamic),
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('zh'), // Chinese (Mandarin)
            Locale('hi'), // Hindi
            Locale('es'), // Spanish
            Locale('fr'), // French
            Locale('ar'), // Arabic
            Locale('bn'), // Bengali
            Locale('ru'), // Russian
            Locale('pt'), // Portuguese
            Locale('ja'), // Japanese
            Locale('de'), // German
          ],
          home: const HomeScreen(),
        );
      },
    );
  }
}
