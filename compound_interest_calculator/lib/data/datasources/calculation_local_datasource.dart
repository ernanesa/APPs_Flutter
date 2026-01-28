import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/calculation_model.dart';

/// Local data source for calculations using SharedPreferences
class CalculationLocalDataSource {
  static const String _key = 'calculations_history';
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List<CalculationModel>> getCalculations() async {
    final prefs = await _prefs;
    final String? jsonString = prefs.getString(_key);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => CalculationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveCalculation(CalculationModel calculation) async {
    final prefs = await _prefs;
    final calculations = await getCalculations();
    calculations.insert(0, calculation); // Add to beginning
    
    // Keep only last 50 calculations
    if (calculations.length > 50) {
      calculations.removeRange(50, calculations.length);
    }

    final jsonString = jsonEncode(
      calculations.map((c) => c.toJson()).toList(),
    );
    await prefs.setString(_key, jsonString);
  }

  Future<void> deleteCalculation(String id) async {
    final prefs = await _prefs;
    final calculations = await getCalculations();
    calculations.removeWhere((c) => c.id == id);
    
    final jsonString = jsonEncode(
      calculations.map((c) => c.toJson()).toList(),
    );
    await prefs.setString(_key, jsonString);
  }

  Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.remove(_key);
  }
}
