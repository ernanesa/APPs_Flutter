import 'package:equatable/equatable.dart';

class StreakData extends Equatable {
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastActiveDate;

  const StreakData({
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastActiveDate,
  });

  bool get isActiveToday {
    if (lastActiveDate == null) return false;
    final now = DateTime.now();
    return lastActiveDate!.year == now.year &&
        lastActiveDate!.month == now.month &&
        lastActiveDate!.day == now.day;
  }

  StreakData copyWith({
    int? currentStreak,
    int? bestStreak,
    DateTime? lastActiveDate,
  }) {
    return StreakData(
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }

  @override
  List<Object?> get props => [currentStreak, bestStreak, lastActiveDate];
}
