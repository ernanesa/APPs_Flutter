/// Entity representing a timer for auto-stop feature
/// Ideal for children's sleep - stop sounds after they fall asleep
class TimerEntity {
  final Duration duration;
  final bool isEnabled;
  final bool fadeOut; // Gradual volume reduction before stop

  const TimerEntity({
    required this.duration,
    this.isEnabled = false,
    this.fadeOut = true,
  });

  TimerEntity copyWith({Duration? duration, bool? isEnabled, bool? fadeOut}) {
    return TimerEntity(
      duration: duration ?? this.duration,
      isEnabled: isEnabled ?? this.isEnabled,
      fadeOut: fadeOut ?? this.fadeOut,
    );
  }

  /// Common durations for children's sleep
  static const Duration duration15min = Duration(minutes: 15);
  static const Duration duration30min = Duration(minutes: 30);
  static const Duration duration45min = Duration(minutes: 45);
  static const Duration duration60min = Duration(minutes: 60);
  static const Duration duration90min = Duration(minutes: 90);
  static const Duration duration120min = Duration(minutes: 120);

  static const List<Duration> commonDurations = [
    duration15min,
    duration30min,
    duration45min,
    duration60min,
    duration90min,
    duration120min,
  ];

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TimerEntity &&
        other.duration == duration &&
        other.isEnabled == isEnabled &&
        other.fadeOut == fadeOut;
  }

  @override
  int get hashCode => Object.hash(duration, isEnabled, fadeOut);
}
