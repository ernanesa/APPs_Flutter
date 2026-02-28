import 'package:flutter_riverpod/legacy.dart';
import 'package:core_logic/core_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompoundStreakData {
  final int currentStreak;
  final int highestStreak;
  final DateTime? lastCheckDate;

  const CompoundStreakData({
    this.currentStreak = 0,
    this.highestStreak = 0,
    this.lastCheckDate,
  });
}

class CompoundStreakNotifier extends StateNotifier<CompoundStreakData> {
  final SharedPreferences _prefs;
  static const _currentKey = 'compound_current_streak';
  static const _highestKey = 'compound_highest_streak';
  static const _dateKey = 'compound_last_date';

  CompoundStreakNotifier(this._prefs) : super(const CompoundStreakData()) {
    _loadStreak();
  }

  void _loadStreak() {
    final current = _prefs.getInt(_currentKey) ?? 0;
    final highest = _prefs.getInt(_highestKey) ?? 0;
    final dateStr = _prefs.getString(_dateKey);
    final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
    state = CompoundStreakData(currentStreak: current, highestStreak: highest, lastCheckDate: date);
  }

  Future<void> recordCheckIn() async {
    final now = DateTime.now();
    int newCurrent = state.currentStreak;
    int newHighest = state.highestStreak;

    if (state.lastCheckDate != null) {
      final diff = now.difference(state.lastCheckDate!).inDays;
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

    state = CompoundStreakData(currentStreak: newCurrent, highestStreak: newHighest, lastCheckDate: now);
  }
}

final compoundStreakProvider = StateNotifierProvider<CompoundStreakNotifier, CompoundStreakData>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return CompoundStreakNotifier(prefs); 
});
