import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_ui/core_ui.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:core_logic/core_logic.dart';
import '../providers/water_intake_provider.dart';
import '../domain/entities/app_theme.dart';




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
          Consumer(
            builder: (context, ref, child) {
              final streakData = ref.watch(waterStreakProvider);
              return streakData.streak > 0
                ? Chip(
                    avatar: const Icon(Icons.water_drop, color: Colors.blue, size: 16),
                    label: Text('${streakData.streak}'),
                    backgroundColor: Colors.blue.withOpacity(0.2),
                    side: BorderSide(color: Colors.blue.withOpacity(0.5)),
                  )
                : const SizedBox.shrink();
            },
          ),
          PopupMenuButton<ThemeMode>(
            icon: const Icon(Icons.palette),
            onSelected: (ThemeMode themeType) {
              ref.read(themeProvider.notifier).setThemeMode(themeType);
            },
            itemBuilder: (BuildContext context) => ThemeMode.values
                .map((themeType) => PopupMenuItem<ThemeMode>(
                      value: themeType,
                      child: Text(themeType.name.toUpperCase()),
                    ))
                .toList(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String code) {
              ref.read(localeProvider.notifier).setLocale(Locale(code));
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'en', child: Text('English')),
              const PopupMenuItem<String>(value: 'pt', child: Text('Português')),
            ],
          ),
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
