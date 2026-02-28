import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/calculation.dart';
import '../../domain/usecases/calculation_usecases.dart';
import 'calculation_provider.dart';

final historyProvider =
    NotifierProvider<HistoryNotifier, AsyncValue<List<Calculation>>>(() {
  return HistoryNotifier();
});

class HistoryNotifier extends Notifier<AsyncValue<List<Calculation>>> {
  dynamic get _repository => ref.read(calculationRepositoryProvider);

  @override
  AsyncValue<List<Calculation>> build() {
    loadHistory();
    return const AsyncValue.loading();
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
      await loadHistory();
    } catch (e) {
      // Handle error
    }
  }

  Future<void> clearAll() async {
    try {
      final calculations = state.value ?? [];
      for (final calc in calculations) {
        await deleteCalculation(calc.id);
      }
      await loadHistory();
    } catch (e) {
      // Handle error
    }
  }
}
