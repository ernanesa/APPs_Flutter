import 'package:flutter/material.dart';
import 'package:core_logic/core_logic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../logic/bmi_logic.dart';
import '../models/bmi_entry.dart';
import '../providers/bmi_provider.dart';


class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  final _weightController = TextEditingController(text: '70');
  final _heightController = TextEditingController(text: '170');
  double? _bmiResult;
  String? _category;

  double _currentWeight = 70;
  double _currentHeight = 170;

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
    _weightController.addListener(() {
      final val = double.tryParse(_weightController.text);
      if (val != null && val != _currentWeight) {
        setState(() => _currentWeight = val);
      }
    });
    _heightController.addListener(() {
      final val = double.tryParse(_heightController.text);
      if (val != null && val != _currentHeight) {
        setState(() => _currentHeight = val);
      }
    });
  }

  void _loadAd() {
    if (!AdService.adsEnabled) return;

    _bannerAd = AdService.createBannerAd(
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() {
            _isAdLoaded = true;
          });
        }
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
      },
    );
    _bannerAd?.load();
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }

  void _reset() {
    setState(() {
      _currentWeight = 70;
      _currentHeight = 170;
      _weightController.text = '70';
      _heightController.text = '170';
      _bmiResult = null;
      _category = null;
    });
  }

  void _calculate() {
    // Logic handles meters vs cm automatically now
    if (_currentWeight > 0 && _currentHeight > 0) {
      setState(() {
        _bmiResult = BmiLogic.calculateBmi(_currentWeight, _currentHeight);
        _category = BmiLogic.getCategoryKey(_bmiResult!);
      });
    }
  }

  void _save() {
    if (_bmiResult == null) return;

    final entry = BmiEntry(
      id: const Uuid().v4(),
      weight: _currentWeight,
      height: _currentHeight < 3
          ? _currentHeight * 100
          : _currentHeight, // Store as CM standard
      bmi: _bmiResult!,
      date: DateTime.now(),
    );

    ref.read(bmiHistoryProvider.notifier).addEntry(entry);

    AdService.showInterstitialAd();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.resultSaved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // WEIGHT CARD
            _buildInputCard(
              context,
              label: l10n.weight,
              value: _currentWeight,
              unit: 'kg',
              min: 30,
              max: 200,
              controller: _weightController,
              onChanged: (val) {
                setState(() {
                  _currentWeight = val;
                  _weightController.text = val.toStringAsFixed(1);
                });
              },
            ),
            const SizedBox(height: 16),
            // HEIGHT CARD
            _buildInputCard(
              context,
              label: l10n.height,
              value: _currentHeight,
              unit: 'cm', // Label says CM but logic handles meters too
              min: 100,
              max: 250,
              isHeight:
                  true, // Special handling for slider range if user types meters
              controller: _heightController,
              onChanged: (val) {
                setState(() {
                  _currentHeight = val;
                  _heightController.text = val.toStringAsFixed(0);
                });
              },
            ),
            const SizedBox(height: 24),

            // ACTION BUTTONS ROW
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: FilledButton(
                    onPressed: _calculate,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      l10n.calculate.toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: OutlinedButton(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Icon(Icons.refresh),
                  ),
                ),
              ],
            ),

            if (_bmiResult != null) ...[
              const SizedBox(height: 32),
              // RESULT CARD
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getCategoryColor(
                        context,
                        _category!,
                      ).withValues(alpha: 0.9),
                      _getCategoryColor(
                        context,
                        _category!,
                      ).withValues(alpha: 0.6),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: _getCategoryColor(
                        context,
                        _category!,
                      ).withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.result,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _bmiResult!.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getLocalizedString(context, _category!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: _getCategoryColor(context, _category!),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.save),
                      label: Text(l10n.save),
                    ),
                  ],
                ),
              ),
            ],

            if (_isAdLoaded && _bannerAd != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                height: _bannerAd!.size.height.toDouble(),
                width: _bannerAd!.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputCard(
    BuildContext context, {
    required String label,
    required double value,
    required String unit,
    required double min,
    required double max,
    required TextEditingController controller,
    required ValueChanged<double> onChanged,
    bool isHeight = false,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    // Adjust slider range dynamically if user is typing meters
    double sliderVal = value;
    double sliderMin = min;
    double sliderMax = max;

    if (isHeight && value < 3.0) {
      // User entered meters, adjust slider context
      sliderMin = 1.0;
      sliderMax = 2.5;
    }

    // Clamp slider value to avoid crash
    if (sliderVal < sliderMin) sliderVal = sliderMin;
    if (sliderVal > sliderMax) sliderVal = sliderMax;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: controller,
                    textAlign: TextAlign.end,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      suffixText: unit,
                    ),
                  ),
                ),
              ],
            ),
            Slider(
              value: sliderVal,
              min: sliderMin,
              max: sliderMax,
              activeColor: colorScheme.primary,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(BuildContext context, String key) {
    switch (key) {
      case 'underweight':
        return Colors.blue;
      case 'normal':
        return Colors.green;
      case 'overweight':
        return Colors.orange;
      case 'obesity1':
        return Colors.deepOrange;
      case 'obesity2':
        return Colors.red;
      case 'obesity3':
        return const Color(0xFF8B0000);
      default:
        return Colors.grey;
    }
  }

  String _getLocalizedString(BuildContext context, String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'underweight':
        return l10n.underweight;
      case 'normal':
        return l10n.normal;
      case 'overweight':
        return l10n.overweight;
      case 'obesity1':
        return l10n.obesity1;
      case 'obesity2':
        return l10n.obesity2;
      case 'obesity3':
        return l10n.obesity3;
      default:
        return '';
    }
  }
}
