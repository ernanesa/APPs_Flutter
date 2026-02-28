import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../logic/bmi_logic.dart';

class BmiCalculationState {
  final double weight;
  final double height;
  final double? bmi;
  final String? categoryKey;

  BmiCalculationState({
    this.weight = 70.0,
    this.height = 170.0,
    this.bmi,
    this.categoryKey,
  });

  BmiCalculationState copyWith({
    double? weight,
    double? height,
    double? bmi,
    String? categoryKey,
  }) {
    return BmiCalculationState(
      weight: weight ?? this.weight,
      height: height ?? this.height,
      bmi: bmi ?? this.bmi,
      categoryKey: categoryKey ?? this.categoryKey,
    );
  }
}

class BmiCalculationNotifier extends StateNotifier<BmiCalculationState> {
  BmiCalculationNotifier() : super(BmiCalculationState());

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
      final bmi = BmiLogic.calculateBmi(state.weight, state.height);
      final categoryKey = BmiLogic.getCategoryKey(bmi);
      state = state.copyWith(bmi: bmi, categoryKey: categoryKey);
    }
  }

  void reset() {
    state = BmiCalculationState();
  }
}

final bmiCalculationProvider =
    StateNotifierProvider<BmiCalculationNotifier, BmiCalculationState>((ref) {
  return BmiCalculationNotifier();
});
