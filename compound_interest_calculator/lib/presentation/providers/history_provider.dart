import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/calculation.dart';
import '../../domain/usecases/calculation_usecases.dart';
import 'calculation_provider.dart';

final historyProvider = StateNotifierProvider<HistoryNotifier, AsyncValue<List<Calculation>>>((ref) {
  final repository = ref.watch(calculationRepositoryProvider);
  return HistoryNotifier(repository);
});

class HistoryNotifier extends StateNotifier<AsyncValue<List<Calculation>>> {
  final dynamic _repository;

  HistoryNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    state = const AsyncValue.loading();
    try {
    final usecase = GetCalculationHistoryUseCase(_repository);
      final calculations = await usecase.execute();
      state = AsyncValue.data(calculations);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> deleteCalculation(String id) async {
    try {
      final usecase = DeleteCalculationUseCase(_repository);
      await usecase.execute(id);
      await loadHistory(); // Reload
    } catch (e) {
      // Handle error
    }
  }

  Future<void> clearAll() async {
    try {
      final calculations = state.valueOrNull ?? [];
      for (final calc in calculations) {
        await deleteCalculation(calc.id);
      }
      await loadHistory();
    } catch (e) {
      // Handle error
    }
  }
}
