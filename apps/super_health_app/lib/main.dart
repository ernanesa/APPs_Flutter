import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_logic/core_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:core_ui/core_ui.dart';

import 'package:feature_bmi/screens/home_screen.dart' as bmi;
import 'package:feature_water/presentation/screens/home_screen.dart' as water;
import 'package:feature_fasting/presentation/screens/home_screen.dart' as fasting;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  await ConsentService.gatherConsent();
  
  if (await ConsentService.canRequestAds()) {
    await AdService.initialize();
    AdService.loadAppOpenAd();
    AdService.preloadInterstitialAd();
  }

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const SuperHealthApp(),
    ),
  );
}

class SuperHealthApp extends ConsumerWidget {
  const SuperHealthApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Super Health App',
      themeMode: themeState.mode,
      theme: ThemeData.light().copyWith(primaryColor: themeState.seedColor),
      darkTheme: ThemeData.dark().copyWith(primaryColor: themeState.seedColor),
      locale: locale,
      home: const SuperHealthHub(),
    );
  }
}

class SuperHealthHub extends ConsumerStatefulWidget {
  const SuperHealthHub({super.key});

  @override
  ConsumerState<SuperHealthHub> createState() => _SuperHealthHubState();
}

class _SuperHealthHubState extends ConsumerState<SuperHealthHub> {
  int _currentIndex = 0;

  final List<Widget> _features = [
    const fasting.HomeScreen(),
    const water.HomeScreen(),
    const bmi.HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _features,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Fasting',
          ),
          NavigationDestination(
            icon: Icon(Icons.water_drop_outlined),
            selectedIcon: Icon(Icons.water_drop),
            label: 'Water',
          ),
          NavigationDestination(
            icon: Icon(Icons.calculate_outlined),
            selectedIcon: Icon(Icons.calculate),
            label: 'BMI',
          ),
        ],
      ),
    );
  }
}
