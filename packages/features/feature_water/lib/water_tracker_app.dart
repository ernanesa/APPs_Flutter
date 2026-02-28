import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_logic/core_logic.dart';
import 'package:core_ui/core_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/screens/home_screen.dart';

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
