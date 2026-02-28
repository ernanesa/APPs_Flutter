import 'dart:convert';
import 'dart:isolate';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  // Executado na Background Isolate (Zero Latency na UI)
  static List<BmiEntry> _parseHistoryInIsolate(String historyJson) {
    final List<dynamic> decoded = json.decode(historyJson);
    final entries = decoded.map((item) => BmiEntry.fromMap(item)).toList();
    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  // Executado na Background Isolate (Zero Latency na UI)
  static String _encodeHistoryInIsolate(List<Map<String, dynamic>> rawData) {
    return json.encode(rawData);
  }

  Future<void> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? historyJson = prefs.getString(_storageKey);
    
    if (historyJson != null) {
      // Dart 3.x: Isolate.run for zero-cost thread offloading
      state = await Isolate.run(() => _parseHistoryInIsolate(historyJson));
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
    
    // Preparar dados puros para enviar para a Isolate (evitar envio de instâncias complexas)
    final rawData = state.map((entry) => entry.toMap()).toList();
    
    // Processamento de texto longo (encoding) em thread separada
    final String encoded = await Isolate.run(() => _encodeHistoryInIsolate(rawData));
    
    await prefs.setString(_storageKey, encoded);
  }
}
