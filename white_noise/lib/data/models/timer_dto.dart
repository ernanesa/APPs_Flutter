import 'package:white_noise/domain/entities/timer_entity.dart';

/// DTO for TimerEntity serialization
class TimerDto {
  final int durationMinutes; // Duration as int minutes
  final bool isEnabled;
  final bool fadeOut;

  const TimerDto({
    required this.durationMinutes,
    required this.isEnabled,
    required this.fadeOut,
  });

  TimerEntity toEntity() {
    return TimerEntity(
      duration: Duration(minutes: durationMinutes),
      isEnabled: isEnabled,
      fadeOut: fadeOut,
    );
  }

  factory TimerDto.fromEntity(TimerEntity entity) {
    return TimerDto(
      durationMinutes: entity.duration.inMinutes,
      isEnabled: entity.isEnabled,
      fadeOut: entity.fadeOut,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'durationMinutes': durationMinutes,
      'isEnabled': isEnabled,
      'fadeOut': fadeOut,
    };
  }

  factory TimerDto.fromJson(Map<String, dynamic> json) {
    return TimerDto(
      durationMinutes: json['durationMinutes'] as int? ?? 30,
      isEnabled: json['isEnabled'] as bool? ?? false,
      fadeOut: json['fadeOut'] as bool? ?? true,
    );
  }
}
