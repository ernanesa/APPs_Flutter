import 'package:equatable/equatable.dart';

/// Domain entity representing a compound interest calculation
class Calculation extends Equatable {
  final String id;
  final double initialCapital;
  final double interestRate; // Annual percentage
  final int months;
  final double monthlyContribution;
  final DateTime createdAt;
  final String? name;

  const Calculation({
    required this.id,
    required this.initialCapital,
    required this.interestRate,
    required this.months,
    required this.monthlyContribution,
    required this.createdAt,
    this.name,
  });

  /// Calculate total amount after compound interest
  double get totalAmount {
    if (interestRate == 0) {
      return initialCapital + (monthlyContribution * months);
    }

    final monthlyRate = interestRate / 100 / 12;
    
    // Future value of initial capital
    final fvInitial = initialCapital * _pow(1 + monthlyRate, months);
    
    // Future value of monthly contributions (ordinary annuity)
    final fvContributions = monthlyContribution * 
        ((_pow(1 + monthlyRate, months) - 1) / monthlyRate);
    
    return fvInitial + fvContributions;
  }

  /// Total amount contributed (initial + all monthly contributions)
  double get totalContributed => initialCapital + (monthlyContribution * months);

  /// Total interest earned
  double get totalInterest => totalAmount - totalContributed;

  /// Percentage gain
  double get percentageGain => 
      totalContributed > 0 ? (totalInterest / totalContributed) * 100 : 0;

  /// Generate monthly breakdown for chart
  List<MonthlyData> get monthlyBreakdown {
    final List<MonthlyData> data = [];
    final monthlyRate = interestRate / 100 / 12;

    for (int month = 0; month <= months; month++) {
      double balance;
      double totalInvested;

      if (month == 0) {
        balance = initialCapital;
        totalInvested = initialCapital;
      } else {
        final fvInitial = initialCapital * _pow(1 + monthlyRate, month);
        final fvContributions = monthlyContribution * 
            ((_pow(1 + monthlyRate, month) - 1) / monthlyRate);
        balance = fvInitial + fvContributions;
        totalInvested = initialCapital + (monthlyContribution * month);
      }

      data.add(MonthlyData(
        month: month,
        balance: balance,
        totalInvested: totalInvested,
        interest: balance - totalInvested,
      ));
    }

    return data;
  }

  double _pow(double base, int exponent) {
    double result = 1.0;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }

  Calculation copyWith({
    String? id,
    double? initialCapital,
    double? interestRate,
    int? months,
    double? monthlyContribution,
    DateTime? createdAt,
    String? name,
  }) {
    return Calculation(
      id: id ?? this.id,
      initialCapital: initialCapital ?? this.initialCapital,
      interestRate: interestRate ?? this.interestRate,
      months: months ?? this.months,
      monthlyContribution: monthlyContribution ?? this.monthlyContribution,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [
        id,
        initialCapital,
        interestRate,
        months,
        monthlyContribution,
        createdAt,
        name,
      ];
}

/// Data point for monthly chart
class MonthlyData {
  final int month;
  final double balance;
  final double totalInvested;
  final double interest;

  const MonthlyData({
    required this.month,
    required this.balance,
    required this.totalInvested,
    required this.interest,
  });
}
