import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_logic/core_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

final waterIntakeProvider = NotifierProvider<WaterNotifier, int>(() {
  return WaterNotifier();
});

class WaterNotifier extends Notifier<int> {
  static const _key = 'daily_water';

  @override
  int build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getInt(_key) ?? 0;
  }

  Future<void> addGlass() async {
    state += 1;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_key, state);
    AdService.incrementActionAndShowIfNeeded();
  }
  
  Future<void> reset() async {
    state = 0;
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_key, state);
  }
}
