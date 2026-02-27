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
      id: map['id'],
      weight: map['weight'],
      height: map['height'],
      bmi: map['bmi'],
      date: DateTime.parse(map['date']),
    );
  }

  String toJson() => json.encode(toMap());

  factory BmiEntry.fromJson(String source) =>
      BmiEntry.fromMap(json.decode(source));
}
