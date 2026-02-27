import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../l10n/app_localizations.dart';

import '../../domain/entities/preset.dart';
import '../../services/ad_service.dart';
import '../../utils/formatters.dart';
import '../providers/calculation_provider.dart';
import '../providers/streak_provider.dart';
import '../providers/daily_goal_provider.dart';
import '../providers/achievement_provider.dart';
import '../providers/history_provider.dart';
import '../widgets/streak_widget.dart';
import '../widgets/daily_goal_widget.dart';
import '../widgets/calculation_chart.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _initialCapitalController = TextEditingController();
  final _rateController = TextEditingController();
  final _monthsController = TextEditingController();
  final _contributionController = TextEditingController();

  bool _isYearsMode = false;

  @override
  void initState() {
    super.initState();
    _initialCapitalController.text = '1000';
    _rateController.text = '10';
    _monthsController.text = '12';
    _contributionController.text = '0';
  }

  @override
  void dispose() {
    _initialCapitalController.dispose();
    _rateController.dispose();
    _monthsController.dispose();
    _contributionController.dispose();
    super.dispose();
  }

  void _selectPreset(InvestmentPreset preset) {
    setState(() {
      _rateController.text = preset.annualRate.toStringAsFixed(2);
    });
  }

  Future<void> _calculate() async {
    if (!_formKey.currentState!.validate()) return;

    final calculationNotifier = ref.read(calculationProvider.notifier);
    final streakNotifier = ref.read(streakProvider.notifier);
    final dailyGoalNotifier = ref.read(dailyGoalProvider.notifier);
    final achievementNotifier = ref.read(achievementProvider.notifier);
    final historyNotifier = ref.read(historyProvider.notifier);

    calculationNotifier.setInitialCapital(
      double.parse(_initialCapitalController.text),
    );
    calculationNotifier.setAnnualRate(double.parse(_rateController.text));
    final months =
        _isYearsMode
            ? int.parse(_monthsController.text) * 12
            : int.parse(_monthsController.text);
    calculationNotifier.setMonths(months);
    calculationNotifier.setMonthlyContribution(
      double.parse(_contributionController.text),
    );

    await calculationNotifier.calculate();

    // Update streak and daily goal
    await streakNotifier.recordActivity();
    await dailyGoalNotifier.incrementCompleted();

    // Check achievements
    final calcState = ref.read(calculationProvider);
    final streak = ref.read(streakProvider);
    final history = ref.read(historyProvider).valueOrNull ?? [];

    final newAchievements = await achievementNotifier.checkAndUnlock(
      totalCalculations: history.length + 1,
      currentStreak: streak.currentStreak,
      totalAmount: calcState.result?.totalAmount ?? 0,
      months: months,
    );

    // Show achievement toast
    if (newAchievements.isNotEmpty && mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${l10n.achievementUnlocked}: ${newAchievements.first.titleKey}',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _saveCalculation() async {
    final calcState = ref.read(calculationProvider);
    if (calcState.result == null) return;

    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController();

    final saved = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(l10n.save),
            content: TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: l10n.calculationName,
                hintText: l10n.calculationNameHint,
              ),
              autofocus: true,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.save),
              ),
            ],
          ),
    );

    if (saved == true && nameController.text.isNotEmpty) {
      await ref
          .read(calculationProvider.notifier)
          .saveCalculation(nameController.text);
      await ref.read(historyProvider.notifier).loadHistory();

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.calculationSaved)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final calcState = ref.watch(calculationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to history
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Row(
                children: [
                  Expanded(child: StreakWidget()),
                  SizedBox(width: 8),
                  Expanded(child: DailyGoalWidget()),
                ],
              ),
              const SizedBox(height: 24),

              // Preset selector
              Text(
                l10n.investmentPresets,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: BrazilianPresets.all.length,
                  itemBuilder: (context, index) {
                    final preset = BrazilianPresets.all[index];
                    return Card(
                      margin: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => _selectPreset(preset),
                        child: Container(
                          width: 120,
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _presetName(l10n, preset),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${preset.annualRate.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Input fields
              TextFormField(
                controller: _initialCapitalController,
                decoration: InputDecoration(
                  labelText: l10n.initialCapital,
                  prefixText: 'R\$ ',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return l10n.requiredField;
                  if (double.tryParse(value) == null) return l10n.invalidNumber;
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _rateController,
                decoration: InputDecoration(
                  labelText: l10n.interestRate,
                  suffixText: '%',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) return l10n.requiredField;
                  final rate = double.tryParse(value);
                  if (rate == null || rate < 0 || rate > 100) {
                    return l10n.invalidRate;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _monthsController,
                      decoration: InputDecoration(
                        labelText: _isYearsMode ? l10n.years : l10n.months,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.requiredField;
                        }
                        if (int.tryParse(value) == null) {
                          return l10n.invalidNumber;
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  SegmentedButton<bool>(
                    segments: [
                      ButtonSegment(value: false, label: Text(l10n.months)),
                      ButtonSegment(value: true, label: Text(l10n.years)),
                    ],
                    selected: {_isYearsMode},
                    onSelectionChanged: (Set<bool> selected) {
                      setState(() {
                        _isYearsMode = selected.first;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _contributionController,
                decoration: InputDecoration(
                  labelText: l10n.monthlyContribution,
                  prefixText: 'R\$ ',
                  helperText: l10n.optional,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
              const SizedBox(height: 24),

              // Calculate button
              FilledButton.icon(
                onPressed: calcState.isLoading ? null : _calculate,
                icon:
                    calcState.isLoading
                        ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.calculate),
                label: Text(l10n.calculate),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),

              // Results
              if (calcState.result != null) ...[
                const SizedBox(height: 24),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.result,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.totalAmount,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          formatCurrency(calcState.result!.totalAmount),
                          style: Theme.of(
                            context,
                          ).textTheme.headlineLarge?.copyWith(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${l10n.totalContributed}:'),
                            Text(
                              formatCurrency(
                                calcState.result!.totalContributed,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${l10n.totalInterest}:'),
                            Text(
                              formatCurrency(calcState.result!.totalInterest),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    calcState.result!.percentageGain > 10
                                        ? Colors.green
                                        : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        FilledButton.tonal(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder:
                                  (context) => SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height *
                                        0.8,
                                    child: CalculationChart(
                                      monthlyData:
                                          calcState.result!.monthlyBreakdown,
                                    ),
                                  ),
                            );
                          },
                          child: Text(l10n.viewChart),
                        ),
                        const SizedBox(height: 8),
                        OutlinedButton.icon(
                          onPressed: _saveCalculation,
                          icon: const Icon(Icons.save),
                          label: Text(l10n.save),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              // Banner ad
              const SizedBox(height: 80), // Space for banner
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 60,
          child:
              AdWidget(ad: AdService.createBannerAd()..load()),
        ),
      ),
    );
  }
}

String _presetName(AppLocalizations l10n, InvestmentPreset preset) {
  switch (preset.nameKey) {
    case 'presetPoupanca':
      return l10n.presetPoupanca;
    case 'presetCDI':
      return l10n.presetCDI;
    case 'presetTesouroSelic':
      return l10n.presetTesouroSelic;
    case 'presetTesouroIPCA':
      return l10n.presetTesouroIPCA;
    case 'presetCDB':
      return l10n.presetCDB;
    case 'presetLCILCA':
      return l10n.presetLCILCA;
    default:
      return preset.nameKey;
  }
}
