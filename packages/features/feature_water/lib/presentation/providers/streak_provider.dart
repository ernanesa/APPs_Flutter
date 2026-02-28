import 'package:flutter_riverpod/legacy.dart';
import 'package:core_logic/core_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WaterStreakData {
  final int currentStreak;
  final int highestStreak;
  final DateTime? lastDrinkDate;

  const WaterStreakData({
    this.currentStreak = 0,
    this.highestStreak = 0,
    this.lastDrinkDate,
  });
}

class WaterStreakNotifier extends StateNotifier<WaterStreakData> {
  final SharedPreferences _prefs;
  static const _currentKey = 'water_current_streak';
  static const _highestKey = 'water_highest_streak';
  static const _dateKey = 'water_last_date';

  WaterStreakNotifier(this._prefs) : super(const WaterStreakData()) {
    _loadStreak();
  }

  void _loadStreak() {
    final current = _prefs.getInt(_currentKey) ?? 0;
    final highest = _prefs.getInt(_highestKey) ?? 0;
    final dateStr = _prefs.getString(_dateKey);
    final date = dateStr != null ? DateTime.tryParse(dateStr) : null;
    state = WaterStreakData(currentStreak: current, highestStreak: highest, lastDrinkDate: date);
  }

  Future<void> recordDrink() async {
    final now = DateTime.now();
    int newCurrent = state.currentStreak;
    int newHighest = state.highestStreak;

    if (state.lastDrinkDate != null) {
      final diff = now.difference(state.lastDrinkDate!).inDays;
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

    state = WaterStreakData(currentStreak: newCurrent, highestStreak: newHighest, lastDrinkDate: now);
  }
}

final waterStreakProvider = StateNotifierProvider<WaterStreakNotifier, WaterStreakData>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return WaterStreakNotifier(prefs); 
});
