import 'dart:convert';

class BmiEntry {
  final String id;
  final double weight;
  final double height;
  final double bmi;
  final DateTime date;

  BmiEntry({
    required this.id,
    required this.weight,
    required this.height,
    required this.bmi,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'weight': weight,
      'height': height,
      'bmi': bmi,
      'date': date.toIso8601String(),
    };
  }

  factory BmiEntry.fromMap(Map<String, dynamic> map) {
    return BmiEntry(
      id: map['id'] ?? '',
      weight: (map['weight'] ?? 0).toDouble(),
      height: (map['height'] ?? 0).toDouble(),
      bmi: (map['bmi'] ?? 0).toDouble(),
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
    );
  }

  String toJson() => json.encode(toMap());

  // Performance 2026: fromJson string factory removed to prevent main-thread decoding.
  // Use BmiEntry.fromMap() after decoding JSON in an Isolate.
}
