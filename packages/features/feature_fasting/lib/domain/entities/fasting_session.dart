/// Represents a fasting session with start/end times and protocol used.
class FastingSession {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final String protocolId;
  final bool isCompleted;
  final int targetHours;

  const FastingSession({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.protocolId,
    this.isCompleted = false,
    required this.targetHours,
  });

  /// Duration in minutes since start
  int get elapsedMinutes {
    final end = endTime ?? DateTime.now();
    return end.difference(startTime).inMinutes;
  }

  /// Duration in hours since start
  double get elapsedHours => elapsedMinutes / 60.0;

  /// Progress percentage (0.0 to 1.0+)
  double get progress {
    if (targetHours == 0) return 0.0;
    return elapsedHours / targetHours;
  }

  /// Whether the fasting goal was achieved
  bool get goalAchieved => elapsedHours >= targetHours;

  /// Current metabolic stage based on hours fasted
  FastingStage get currentStage => FastingStage.fromHours(elapsedHours);

  FastingSession copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    String? protocolId,
    bool? isCompleted,
    int? targetHours,
  }) {
    return FastingSession(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      protocolId: protocolId ?? this.protocolId,
      isCompleted: isCompleted ?? this.isCompleted,
      targetHours: targetHours ?? this.targetHours,
    );
  }
}

/// Metabolic stages during fasting based on scientific research
/// Sources: Johns Hopkins Medicine, Harvard Health
enum FastingStage {
  fed(0, 4, 'fed', '🍽️'),
  earlyFasting(4, 12, 'earlyFasting', '🔄'),
  fatBurning(12, 18, 'fatBurning', '🔥'),
  ketosis(18, 24, 'ketosis', '⚡'),
  deepKetosis(24, 48, 'deepKetosis', '💪'),
  autophagy(48, 72, 'autophagy', '🧬');

  final int startHour;
  final int endHour;
  final String nameKey;
  final String icon;

  const FastingStage(this.startHour, this.endHour, this.nameKey, this.icon);

  static FastingStage fromHours(double hours) {
    if (hours < 4) return FastingStage.fed;
    if (hours < 12) return FastingStage.earlyFasting;
    if (hours < 18) return FastingStage.fatBurning;
    if (hours < 24) return FastingStage.ketosis;
    if (hours < 48) return FastingStage.deepKetosis;
    return FastingStage.autophagy;
  }

  /// Progress within this stage (0.0 to 1.0)
  double progressInStage(double hours) {
    if (hours < startHour) return 0.0;
    if (hours >= endHour) return 1.0;
    return (hours - startHour) / (endHour - startHour);
  }
}
