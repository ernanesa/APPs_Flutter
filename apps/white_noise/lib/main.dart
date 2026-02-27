import 'package:flutter/material.dart';
import 'package:core_logic/core_logic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';

import 'l10n/app_localizations.dart';
import 'presentation/providers/settings_provider.dart';

import 'presentation/screens/home_screen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConsentService.gatherConsent();
  final canReq = await ConsentService.canRequestAds();
  if (canReq) {
    await AdService.initialize();
    AdService.loadAppOpenAd();
    AdService.preloadInterstitialAd();
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
    return const _AppRoot();
  }
}

class _AppRoot extends ConsumerWidget {
  const _AppRoot();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final locale = Locale(settings.languageCode);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      theme: AppTheme.lightTheme(Colors.teal),
      darkTheme: AppTheme.darkTheme(Colors.teal),
      themeMode: settings.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomeScreen(),
    );
  }
}
