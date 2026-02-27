import '../../domain/entities/calculation.dart';
import '../../domain/repositories/calculation_repository.dart';
import '../datasources/calculation_local_datasource.dart';
import '../models/calculation_model.dart';

/// Implementation of ICalculationRepository
class CalculationRepositoryImpl implements ICalculationRepository {
  final CalculationLocalDataSource localDataSource;

  CalculationRepositoryImpl(this.localDataSource);

  @override
  Future<List<Calculation>> getAllCalculations() async {
    return await localDataSource.getCalculations();
  }

  @override
  Future<void> saveCalculation(Calculation calculation) async {
    final model = CalculationModel.fromEntity(calculation);
    await localDataSource.saveCalculation(model);
  }

  @override
  Future<void> deleteCalculation(String id) async {
    await localDataSource.deleteCalculation(id);
  }

  @override
  Future<void> clearAll() async {
    await localDataSource.clearAll();
  }
}
