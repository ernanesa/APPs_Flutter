import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

import 'colorful_background.dart';
import 'package:core_logic/core_logic.dart';

class PomodoroScaffold extends ConsumerWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool extendBodyBehindAppBar;

  const PomodoroScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.extendBodyBehindAppBar = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(pomodoroSettingsProvider);
    final selectedTheme = ref.watch(selectedThemeProvider);
    final isColorful = settings.colorfulMode;

    if (!isColorful) {
      return Scaffold(
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
      );
    }

    // In colorful mode, we wrap with ColorfulBackground

    return ColorfulBackground(
      primaryColor: selectedTheme.seedColor,
      secondaryColor: selectedTheme.secondaryColor,
      accentColor: selectedTheme.accentColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar != null ? _wrapAppBar(appBar!, context) : null,
        body: body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        extendBodyBehindAppBar:
            false, // Don't extend - let Scaffold handle spacing
      ),
    );
  }

  PreferredSizeWidget _wrapAppBar(
    PreferredSizeWidget originalAppBar,
    BuildContext context,
  ) {
    // If it's a standard AppBar, we might want to make it transparent or semi-transparent
    if (originalAppBar is AppBar) {
      return AppBar(
        title: originalAppBar.title,
        actions: originalAppBar.actions,
        leading: originalAppBar.leading,
        leadingWidth: originalAppBar.leadingWidth,
        centerTitle: originalAppBar.centerTitle,
        backgroundColor: Colors.transparent, // Transparent for gradient
        elevation: 0,
        scrolledUnderElevation: 0, // Prevent shadow when scrolling
        iconTheme: const IconThemeData(
          color: Colors.white,
        ), // Force white icons on colorful bg
        titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: Colors.white, // Force white text
          fontWeight: FontWeight.bold,
        ),
        bottom: originalAppBar.bottom,
      );
    }
    return originalAppBar;
  }
}
