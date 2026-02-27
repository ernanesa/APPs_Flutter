import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/bmi_entry.dart';

final bmiHistoryProvider =
    StateNotifierProvider<BmiHistoryNotifier, List<BmiEntry>>((ref) {
      return BmiHistoryNotifier();
    });

class BmiHistoryNotifier extends StateNotifier<List<BmiEntry>> {
  BmiHistoryNotifier() : super([]) {
    loadHistory();
  }

  static const String _storageKey = 'bmi_history';

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString(_storageKey);
    if (historyJson != null) {
      final List<dynamic> decoded = json.decode(historyJson);
      state = decoded.map((item) => BmiEntry.fromMap(item)).toList();
      // Sort by date descending
      state.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  Future<void> addEntry(BmiEntry entry) async {
    state = [entry, ...state];
    await _saveToDisk();
  }

  Future<void> deleteEntry(String id) async {
    state = state.where((entry) => entry.id != id).toList();
    await _saveToDisk();
  }

  Future<void> _saveToDisk() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(
      state.map((entry) => entry.toMap()).toList(),
    );
    await prefs.setString(_storageKey, encoded);
  }
}
