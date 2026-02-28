import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_logic/core_logic.dart';
import '../logic/bmi_logic.dart';

class BmiCalculationState {
  final double weight;
  final double height;
  final double? bmi;
  final String? categoryKey;
  final bool isImperial;

  BmiCalculationState({
    this.weight = 70.0,
    this.height = 170.0,
    this.bmi,
    this.categoryKey,
    this.isImperial = false,
  });

  BmiCalculationState copyWith({
    double? weight,
    double? height,
    double? bmi,
    String? categoryKey,
    bool? isImperial,
  }) {
    return BmiCalculationState(
      weight: weight ?? this.weight,
      height: height ?? this.height,
      bmi: bmi ?? this.bmi,
      categoryKey: categoryKey ?? this.categoryKey,
      isImperial: isImperial ?? this.isImperial,
    );
  }
}

class BmiCalculationNotifier extends Notifier<BmiCalculationState> {
  @override
  BmiCalculationState build() {
    final settings = ref.watch(settingsProvider);
    
    // Convert units if system changes during runtime
    final isImperial = settings.useImperialUnits;
    
    return BmiCalculationState(
      isImperial: isImperial,
      // Default startup values based on system
      weight: isImperial ? 154.0 : 70.0, // 70kg -> ~154lbs
      height: isImperial ? 67.0 : 170.0, // 170cm -> ~67in
    );
  }

  void updateWeight(double weight) {
    if (state.weight == weight) return;
    state = state.copyWith(weight: weight);
    _calculate();
  }

  void updateHeight(double height) {
    if (state.height == height) return;
    state = state.copyWith(height: height);
    _calculate();
  }

  void _calculate() {
    if (state.weight > 0 && state.height > 0) {
      final bmi = BmiLogic.calculateBmi(
        state.weight, 
        state.height, 
        isImperial: state.isImperial
      );
      final categoryKey = BmiLogic.getCategoryKey(bmi);
      state = state.copyWith(bmi: bmi, categoryKey: categoryKey);
    }
  }

  void reset() {
    state = BmiCalculationState(
      isImperial: state.isImperial,
      weight: state.isImperial ? 154.0 : 70.0,
      height: state.isImperial ? 67.0 : 170.0,
    );
  }
}

final bmiCalculationProvider =
    NotifierProvider<BmiCalculationNotifier, BmiCalculationState>(
  () => BmiCalculationNotifier(),
);
