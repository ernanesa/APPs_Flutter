import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import 'calculator_screen.dart';
import 'history_screen.dart';
import 'evolution_screen.dart';
import '../widgets/info_dialog.dart';
import '../providers/locale_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const CalculatorScreen(),
    const HistoryScreen(),
    const EvolutionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            onSelected: (String code) {
              ref.read(localeProvider.notifier).setLocale(code);
            },
            itemBuilder:
                (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'en',
                    child: Text('English'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'zh',
                    child: Text('中文 (Chinese)'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'hi',
                    child: Text('हिन्दी (Hindi)'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'es',
                    child: Text('Español'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'fr',
                    child: Text('Français'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'ar',
                    child: Text('العربية (Arabic)'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'bn',
                    child: Text('বাংলা (Bengali)'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'ru',
                    child: Text('Русский (Russian)'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'pt',
                    child: Text('Português'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'ja',
                    child: Text('日本語 (Japanese)'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'de',
                    child: Text('Deutsch'),
                  ),
                ],
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const InfoDialog(),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.calculate_outlined),
            selectedIcon: const Icon(Icons.calculate),
            label: l10n.calculator,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history_outlined),
            selectedIcon: const Icon(Icons.history),
            label: l10n.history,
          ),
          NavigationDestination(
            icon: const Icon(Icons.show_chart_outlined),
            selectedIcon: const Icon(Icons.show_chart),
            label: l10n.evolution,
          ),
        ],
      ),
    );
  }
}
