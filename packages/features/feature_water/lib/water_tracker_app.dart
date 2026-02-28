import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_logic/core_logic.dart';
import 'package:core_ui/core_ui.dart';
import 'package:dynamic_color/dynamic_color.dart';
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
    final themeState = ref.watch(themeProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Water Tracker',
          theme: AppTheme.lightTheme(themeState.seedColor, dynamicColorScheme: lightDynamic),
          darkTheme: AppTheme.darkTheme(themeState.seedColor, dynamicColorScheme: darkDynamic),
          themeMode: themeState.mode,
          home: const HomeScreen(),
        );
      },
    );
  }
}
