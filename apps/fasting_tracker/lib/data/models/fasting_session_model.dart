import 'dart:convert';
import '../../domain/entities/fasting_session.dart';

/// Data model for FastingSession with JSON serialization
class FastingSessionModel extends FastingSession {
  const FastingSessionModel({
    required super.id,
    required super.startTime,
    super.endTime,
    required super.protocolId,
    super.isCompleted,
    required super.targetHours,
  });

  factory FastingSessionModel.fromJson(Map<String, dynamic> json) {
    return FastingSessionModel(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      protocolId: json['protocolId'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      targetHours: json['targetHours'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'protocolId': protocolId,
      'isCompleted': isCompleted,
      'targetHours': targetHours,
    };
  }

  factory FastingSessionModel.fromEntity(FastingSession entity) {
    return FastingSessionModel(
      id: entity.id,
      startTime: entity.startTime,
      endTime: entity.endTime,
      protocolId: entity.protocolId,
      isCompleted: entity.isCompleted,
      targetHours: entity.targetHours,
    );
  }

  static String encodeList(List<FastingSessionModel> sessions) {
    return jsonEncode(sessions.map((s) => s.toJson()).toList());
  }

  static List<FastingSessionModel> decodeList(String json) {
    final List<dynamic> list = jsonDecode(json);
    return list.map((item) => FastingSessionModel.fromJson(item)).toList();
  }
}
