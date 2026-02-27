import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_logic/core_logic.dart';
import 'package:core_ui/core_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // App Factory Standard Setup
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
      child: const WaterTrackerApp(),
    ),
  );
}

class WaterTrackerApp extends ConsumerStatefulWidget {
  const WaterTrackerApp({super.key});

  @override
  ConsumerState<WaterTrackerApp> createState() => _WaterTrackerAppState();
}

class _WaterTrackerAppState extends ConsumerState<WaterTrackerApp>
    with WidgetsBindingObserver {
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Water Tracker',
      theme: AppTheme.lightTheme(Colors.blue),
      darkTheme: AppTheme.darkTheme(Colors.blue),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}

// Simple State Management
final waterIntakeProvider = NotifierProvider<WaterNotifier, int>(() {
  return WaterNotifier();
});

class WaterNotifier extends Notifier<int> {
  static const _key = 'daily_water';

  @override
  int build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getInt(_key) ?? 0;
  }

  Future<void> addGlass() async {
    state += 1;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_key, state);
    AdService.incrementActionAndShowIfNeeded();
  }
  
  Future<void> reset() async {
    state = 0;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_key, state);
  }
}

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBanner();
  }
  
  Future<void> _loadBanner() async {
    if (await ConsentService.canRequestAds()) {
      final width = MediaQuery.of(context).size.width.toInt();
      if (width <= 0) return;
      
      final ad = await AdService.createAdaptiveBannerAd(width: width);
      if (mounted && ad != null) {
        setState(() {
          _bannerAd = ad;
          _isBannerLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final intake = ref.watch(waterIntakeProvider);
    final double goal = 8.0;
    final progress = (intake / goal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(waterIntakeProvider.notifier).reset(),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.m),
              child: Column(
                children: [
                  BaseCard(
                    padding: const EdgeInsets.all(Spacing.l),
                    child: Column(
                      children: [
                        Text(
                          'Daily Goal',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 200,
                              height: 200,
                              child: CircularProgressIndicator(
                                value: progress,
                                strokeWidth: 12,
                                strokeCap: StrokeCap.round,
                                backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.water_drop,
                                  size: 48,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '$intake / ${goal.toInt()}',
                                  style: theme.textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'glasses',
                                  style: theme.textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    onPressed: () => ref.read(waterIntakeProvider.notifier).addGlass(),
                    text: 'Drink a Glass (+250ml)',
                  ),
                  const SizedBox(height: 16),
                  if (intake >= goal)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.withOpacity(0.5)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.emoji_events, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Goal reached! Great job!',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: _isBannerLoaded && _bannerAd != null
          ? SafeArea(
              child: SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
