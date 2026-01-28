import '../../domain/entities/calculation.dart';

/// Data model for Calculation (with JSON serialization)
class CalculationModel extends Calculation {
  const CalculationModel({
    required super.id,
    required super.initialCapital,
    required super.interestRate,
    required super.months,
    required super.monthlyContribution,
    required super.createdAt,
    super.name,
  });

  factory CalculationModel.fromJson(Map<String, dynamic> json) {
    return CalculationModel(
      id: json['id'] as String,
      initialCapital: (json['initialCapital'] as num).toDouble(),
      interestRate: (json['interestRate'] as num).toDouble(),
      months: json['months'] as int,
      monthlyContribution: (json['monthlyContribution'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      name: json['name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'initialCapital': initialCapital,
      'interestRate': interestRate,
      'months': months,
      'monthlyContribution': monthlyContribution,
      'createdAt': createdAt.toIso8601String(),
      'name': name,
    };
  }

  factory CalculationModel.fromEntity(Calculation calculation) {
    return CalculationModel(
      id: calculation.id,
      initialCapital: calculation.initialCapital,
      interestRate: calculation.interestRate,
      months: calculation.months,
      monthlyContribution: calculation.monthlyContribution,
      createdAt: calculation.createdAt,
      name: calculation.name,
    );
  }
}
