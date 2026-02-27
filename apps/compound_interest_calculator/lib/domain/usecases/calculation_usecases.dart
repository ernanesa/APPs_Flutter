import '../entities/calculation.dart';
import '../repositories/calculation_repository.dart';

/// UseCase for calculating compound interest
class CalculateCompoundInterestUseCase {
  Calculation execute({
    required double initialCapital,
    required double annualRate,
    required int months,
    required double monthlyContribution,
  }) {
    final calculation = Calculation(
      id: '',
      initialCapital: initialCapital,
      interestRate: annualRate,
      months: months,
      monthlyContribution: monthlyContribution,
      createdAt: DateTime.now(),
    );

    return calculation;
  }
}

/// UseCase for saving calculation to history
class SaveCalculationUseCase {
  final ICalculationRepository repository;

  SaveCalculationUseCase(this.repository);

  Future<void> execute(Calculation calculation) {
    return repository.saveCalculation(calculation);
  }
}

/// UseCase for getting calculation history
class GetCalculationHistoryUseCase {
  final ICalculationRepository repository;

  GetCalculationHistoryUseCase(this.repository);

  Future<List<Calculation>> execute() {
    return repository.getAllCalculations();
  }
}

/// UseCase for deleting a calculation
class DeleteCalculationUseCase {
  final ICalculationRepository repository;

  DeleteCalculationUseCase(this.repository);

  Future<void> execute(String id) {
    return repository.deleteCalculation(id);
  }
}
