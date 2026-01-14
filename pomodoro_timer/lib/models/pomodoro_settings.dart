/// User settings for the Pomodoro timer.
class PomodoroSettings {
  final int focusDurationMinutes;
  final int shortBreakMinutes;
  final int longBreakMinutes;
  final int sessionsUntilLongBreak;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool autoStartBreaks;
  final bool autoStartFocus;
  final bool notificationsEnabled;
  final bool darkMode;

  const PomodoroSettings({
    this.focusDurationMinutes = 25,
    this.shortBreakMinutes = 5,
    this.longBreakMinutes = 15,
    this.sessionsUntilLongBreak = 4,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.autoStartBreaks = false,
    this.autoStartFocus = false,
    this.notificationsEnabled = true,
    this.darkMode = false,
  });

  /// Creates settings from JSON.
  factory PomodoroSettings.fromJson(Map<String, dynamic> json) {
    return PomodoroSettings(
      focusDurationMinutes: json['focusDurationMinutes'] as int? ?? 25,
      shortBreakMinutes: json['shortBreakMinutes'] as int? ?? 5,
      longBreakMinutes: json['longBreakMinutes'] as int? ?? 15,
      sessionsUntilLongBreak: json['sessionsUntilLongBreak'] as int? ?? 4,
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      vibrationEnabled: json['vibrationEnabled'] as bool? ?? true,
      autoStartBreaks: json['autoStartBreaks'] as bool? ?? false,
      autoStartFocus: json['autoStartFocus'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      darkMode: json['darkMode'] as bool? ?? false,
    );
  }

  /// Converts settings to JSON.
  Map<String, dynamic> toJson() {
    return {
      'focusDurationMinutes': focusDurationMinutes,
      'shortBreakMinutes': shortBreakMinutes,
      'longBreakMinutes': longBreakMinutes,
      'sessionsUntilLongBreak': sessionsUntilLongBreak,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'autoStartBreaks': autoStartBreaks,
      'autoStartFocus': autoStartFocus,
      'notificationsEnabled': notificationsEnabled,
      'darkMode': darkMode,
    };
  }

  /// Creates a copy with modified values.
  PomodoroSettings copyWith({
    int? focusDurationMinutes,
    int? shortBreakMinutes,
    int? longBreakMinutes,
    int? sessionsUntilLongBreak,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? autoStartBreaks,
    bool? autoStartFocus,
    bool? notificationsEnabled,
    bool? darkMode,
  }) {
    return PomodoroSettings(
      focusDurationMinutes: focusDurationMinutes ?? this.focusDurationMinutes,
      shortBreakMinutes: shortBreakMinutes ?? this.shortBreakMinutes,
      longBreakMinutes: longBreakMinutes ?? this.longBreakMinutes,
      sessionsUntilLongBreak: sessionsUntilLongBreak ?? this.sessionsUntilLongBreak,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      autoStartBreaks: autoStartBreaks ?? this.autoStartBreaks,
      autoStartFocus: autoStartFocus ?? this.autoStartFocus,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      darkMode: darkMode ?? this.darkMode,
    );
  }
}
