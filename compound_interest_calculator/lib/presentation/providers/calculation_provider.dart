import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/calculation.dart';
import '../../domain/entities/preset.dart';
import '../../domain/usecases/calculation_usecases.dart';
import '../../data/repositories/calculation_repository_impl.dart';
import '../../data/datasources/calculation_local_datasource.dart';

final calculationRepositoryProvider = Provider((ref) {
  return CalculationRepositoryImpl(CalculationLocalDataSource());
});

final calculationProvider = StateNotifierProvider<CalculationNotifier, CalculationState>((ref) {
  final repository = ref.watch(calculationRepositoryProvider);
  return CalculationNotifier(repository);
});

class CalculationState {
  final double initialCapital;
  final double annualRate;
  final int months;
  final double monthlyContribution;
  final Calculation? result;
  final bool isLoading;

  const CalculationState({
    this.initialCapital = 1000.0,
    this.annualRate = 10.0,
    this.months = 12,
    this.monthlyContribution = 0.0,
    this.result,
    this.isLoading = false,
  });

  CalculationState copyWith({
    double? initialCapital,
    double? annualRate,
    int? months,
    double? monthlyContribution,
    Calculation? result,
    bool? isLoading,
  }) {
    return CalculationState(
      initialCapital: initialCapital ?? this.initialCapital,
      annualRate: annualRate ?? this.annualRate,
      months: months ?? this.months,
      monthlyContribution: monthlyContribution ?? this.monthlyContribution,
      result: result ?? this.result,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CalculationNotifier extends StateNotifier<CalculationState> {
  final CalculationRepositoryImpl _repository;

  CalculationNotifier(this._repository) : super(const CalculationState());

  void setInitialCapital(double value) {
    state = state.copyWith(initialCapital: value);
  }

  void setAnnualRate(double value) {
    state = state.copyWith(annualRate: value);
  }

  void setMonths(int value) {
    state = state.copyWith(months: value);
  }

  void setMonthlyContribution(double value) {
    state = state.copyWith(monthlyContribution: value);
  }

  void selectPreset(InvestmentPreset preset) {
    state = state.copyWith(annualRate: preset.annualRate);
  }

  Future<void> calculate() async {
    state = state.copyWith(isLoading: true);
    
    final usecase = CalculateCompoundInterestUseCase();
    final result = usecase.execute(
      initialCapital: state.initialCapital,
      annualRate: state.annualRate,
      months: state.months,
      monthlyContribution: state.monthlyContribution,
    );
    
    state = state.copyWith(result: result, isLoading: false);
  }

  Future<void> saveCalculation(String name) async {
    if (state.result == null) return;
    
    final usecase = SaveCalculationUseCase(_repository);
    final calculation = state.result!.copyWith(name: name);
    await usecase.execute(calculation);
  }

  void reset() {
    state = const CalculationState();
  }
}
