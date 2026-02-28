import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_logic/core_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:feature_water/water_tracker_app.dart';

Future<void> main() async {
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
