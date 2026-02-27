import '../entities/calculation.dart';

/// Repository interface for calculation history
abstract class ICalculationRepository {
  Future<List<Calculation>> getAllCalculations();
  Future<void> saveCalculation(Calculation calculation);
  Future<void> deleteCalculation(String id);
  Future<void> clearAll();
}
