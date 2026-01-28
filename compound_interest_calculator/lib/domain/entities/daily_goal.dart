import 'package:equatable/equatable.dart';

class DailyGoal extends Equatable {
  final int targetCalculations;
  final int completedCalculations;
  final DateTime date;

  const DailyGoal({
    required this.targetCalculations,
    this.completedCalculations = 0,
    required this.date,
  });

  bool get isCompleted => completedCalculations >= targetCalculations;
  
  double get progress => 
      targetCalculations > 0 ? completedCalculations / targetCalculations : 0;

  DailyGoal copyWith({
    int? targetCalculations,
    int? completedCalculations,
    DateTime? date,
  }) {
    return DailyGoal(
      targetCalculations: targetCalculations ?? this.targetCalculations,
      completedCalculations: completedCalculations ?? this.completedCalculations,
      date: date ?? this.date,
    );
  }

  @override
  List<Object?> get props => [targetCalculations, completedCalculations, date];
}
