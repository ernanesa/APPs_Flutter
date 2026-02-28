import 'package:flutter_riverpod/legacy.dart';
import 'package:core_logic/core_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BmiStreakData {
  final int currentStreak;
  final int highestStreak;
  final DateTime? lastLogDate;

  const BmiStreakData({
    this.currentStreak = 0,
    this.highestStreak = 0,
    this.lastLogDate,
  });
}

class BmiStreakNotifier extends StateNotifier<BmiStreakData> {
  final SharedPreferences _prefs;
  static const _currentKey = 'bmi_current_streak';
  static const _highestKey = 'bmi_highest_streak';
  static const _dateKey = 'bmi_last_date';

  BmiStreakNotifier(this._prefs) : super(const BmiStreakData()) {
    _loadStreak();
  }

  void _loadStreak() {
    final current = _prefs.getInt(_currentKey) ?? 0;
    final highest = _prefs.getInt(_highestKey) ?? 0;
    final dateStr = _prefs.getString(_dateKey);
    final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
    state = BmiStreakData(currentStreak: current, highestStreak: highest, lastLogDate: date);
  }

  Future<void> recordLog() async {
    final now = DateTime.now();
    int newCurrent = state.currentStreak;
    int newHighest = state.highestStreak;

    if (state.lastLogDate != null) {
      final diff = now.difference(state.lastLogDate!).inDays;
      if (diff == 1) {
        newCurrent++;
      } else if (diff > 1) {
        newCurrent = 1;
      }
    } else {
      newCurrent = 1;
    }

    if (newCurrent > newHighest) {
      newHighest = newCurrent;
    }

    await _prefs.setInt(_currentKey, newCurrent);
    await _prefs.setInt(_highestKey, newHighest);
    await _prefs.setString(_dateKey, now.toIso8601String());

    state = BmiStreakData(currentStreak: newCurrent, highestStreak: newHighest, lastLogDate: now);
  }
}

final bmiStreakProvider = StateNotifierProvider<BmiStreakNotifier, BmiStreakData>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return BmiStreakNotifier(prefs); 
});
