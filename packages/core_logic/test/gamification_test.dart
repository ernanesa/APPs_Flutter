import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:core_logic/core_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Fake implements SharedPreferences {
  final Map<String, dynamic> _data = {};
  @override
  int? getInt(String key) => _data[key] as int?;
  @override
  Future<bool> setInt(String key, int value) async {
    _data[key] = value;
    return true;
  }
}

void main() {
  test('Gamificação: Deve aumentar XP e Nível corretamente', () {
    final mockPrefs = MockSharedPreferences();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(mockPrefs),
      ],
    );

    final notifier = container.read(streakProvider.notifier);
    
    // XP Inicial
    expect(container.read(streakProvider).xp, 0);

    // Ganha XP e sobe de nível
    notifier.reportActivity(xpReward: 600);

    expect(container.read(streakProvider).xp, 600);
    expect(container.read(streakProvider).level, 2);
  });
}
