/// Predefined intermittent fasting protocols
class FastingProtocol {
  final String id;
  final String nameKey;
  final String descriptionKey;
  final int fastingHours;
  final int eatingHours;
  final String icon;
  final bool isCustom;

  const FastingProtocol({
    required this.id,
    required this.nameKey,
    required this.descriptionKey,
    required this.fastingHours,
    required this.eatingHours,
    required this.icon,
    this.isCustom = false,
  });

  /// Total cycle duration in hours
  int get totalHours => fastingHours + eatingHours;

  /// Formatted ratio string (e.g., "16:8")
  String get ratioString => '$fastingHours:$eatingHours';

  /// Standard IF protocols
  static const List<FastingProtocol> standardProtocols = [
    FastingProtocol(
      id: '12_12',
      nameKey: 'protocol12_12',
      descriptionKey: 'protocol12_12Desc',
      fastingHours: 12,
      eatingHours: 12,
      icon: '🌱',
    ),
    FastingProtocol(
      id: '14_10',
      nameKey: 'protocol14_10',
      descriptionKey: 'protocol14_10Desc',
      fastingHours: 14,
      eatingHours: 10,
      icon: '🌿',
    ),
    FastingProtocol(
      id: '16_8',
      nameKey: 'protocol16_8',
      descriptionKey: 'protocol16_8Desc',
      fastingHours: 16,
      eatingHours: 8,
      icon: '🔥',
    ),
    FastingProtocol(
      id: '18_6',
      nameKey: 'protocol18_6',
      descriptionKey: 'protocol18_6Desc',
      fastingHours: 18,
      eatingHours: 6,
      icon: '⚡',
    ),
    FastingProtocol(
      id: '20_4',
      nameKey: 'protocol20_4',
      descriptionKey: 'protocol20_4Desc',
      fastingHours: 20,
      eatingHours: 4,
      icon: '💪',
    ),
    FastingProtocol(
      id: '23_1',
      nameKey: 'protocol23_1',
      descriptionKey: 'protocol23_1Desc',
      fastingHours: 23,
      eatingHours: 1,
      icon: '🏆',
    ),
  ];

  static FastingProtocol? findById(String id) {
    try {
      return standardProtocols.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  FastingProtocol copyWith({
    String? id,
    String? nameKey,
    String? descriptionKey,
    int? fastingHours,
    int? eatingHours,
    String? icon,
    bool? isCustom,
  }) {
    return FastingProtocol(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      descriptionKey: descriptionKey ?? this.descriptionKey,
      fastingHours: fastingHours ?? this.fastingHours,
      eatingHours: eatingHours ?? this.eatingHours,
      icon: icon ?? this.icon,
      isCustom: isCustom ?? this.isCustom,
    );
  }
}
