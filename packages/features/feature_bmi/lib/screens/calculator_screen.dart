import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import HapticFeedback
import 'package:core_logic/core_logic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../logic/bmi_logic.dart';
import '../models/bmi_entry.dart';
import '../providers/bmi_provider.dart';
import '../providers/bmi_calculation_provider.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({super.key});

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;

  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    final initialState = ref.read(bmiCalculationProvider);
    _weightController = TextEditingController(text: initialState.weight.toStringAsFixed(1));
    _heightController = TextEditingController(text: initialState.height.toStringAsFixed(0));
    
    _loadAd();

    _weightController.addListener(() {
      final val = double.tryParse(_weightController.text);
      if (val != null) {
        ref.read(bmiCalculationProvider.notifier).updateWeight(val);
      }
    });

    _heightController.addListener(() {
      final val = double.tryParse(_heightController.text);
      if (val != null) {
        ref.read(bmiCalculationProvider.notifier).updateHeight(val);
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
    HapticService.lightImpact(ref); // Otimização UX 2026: Tactile response respecting settings
    ref.read(bmiCalculationProvider.notifier).reset();
    final newState = ref.read(bmiCalculationProvider);
    _weightController.text = newState.weight.toStringAsFixed(1);
    _heightController.text = newState.height.toStringAsFixed(0);
  }

  void _save() {
    final state = ref.read(bmiCalculationProvider);
    if (state.bmi == null) return;

    HapticService.mediumImpact(ref); // Otimização UX 2026: Tactile confirmation respecting settings

    final entry = BmiEntry(
      id: const Uuid().v4(),
      weight: state.weight,
      height: state.height < 3 ? state.height * 100 : state.height,
      bmi: state.bmi!,
      date: DateTime.now(),
    );

    ref.read(bmiHistoryProvider.notifier).addEntry(entry);
    AdService.showInterstitialAd();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Result Saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bmiCalculationProvider);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // WEIGHT CARD
            _buildInputCard(
              context,
              label: "Weight",
              value: state.weight,
              unit: 'kg',
              min: 30,
              max: 200,
              controller: _weightController,
              onChanged: (val) {
                _weightController.text = val.toStringAsFixed(1);
                ref.read(bmiCalculationProvider.notifier).updateWeight(val);
              },
            ),
            const SizedBox(height: 16),
            // HEIGHT CARD
            _buildInputCard(
              context,
              label: "Height",
              value: state.height,
              unit: 'cm',
              min: 100,
              max: 250,
              isHeight: true,
              controller: _heightController,
              onChanged: (val) {
                _heightController.text = val.toStringAsFixed(0);
                ref.read(bmiCalculationProvider.notifier).updateHeight(val);
              },
            ),
            const SizedBox(height: 24),

            // ACTION BUTTONS ROW
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: FilledButton.icon(
                    onPressed: _save, // Save directly if we have a result
                    icon: const Icon(Icons.save),
                    label: const Text("SAVE RESULT"),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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

            if (state.bmi != null) ...[
              const SizedBox(height: 32),
              // RESULT CARD - Wrapped in RepaintBoundary for performance
              RepaintBoundary(
                child: _ResultCard(
                  bmi: state.bmi!,
                  categoryKey: state.categoryKey!,
                ),
              ),
            ],

            if (_isAdLoaded && _bannerAd != null) ...[
              const SizedBox(height: 24),
              // AD - Wrapped in RepaintBoundary to isolate heavy ad rendering
              RepaintBoundary(
                child: Center(
                  child: SizedBox(
                    height: _bannerAd!.size.height.toDouble(),
                    width: _bannerAd!.size.width.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
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

    double sliderVal = value;
    double sliderMin = min;
    double sliderMax = max;

    if (isHeight && value < 3.0) {
      sliderMin = 1.0;
      sliderMax = 2.5;
    }

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
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final double bmi;
  final String categoryKey;

  const _ResultCard({
    required this.bmi,
    required this.categoryKey,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor(context, categoryKey);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.9),
            color.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "YOUR BMI",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            bmi.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 64,
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              categoryKey.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
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
}
