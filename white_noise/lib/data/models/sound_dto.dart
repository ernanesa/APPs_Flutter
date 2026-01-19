import 'package:white_noise/domain/entities/sound_entity.dart';

/// DTO for SoundEntity serialization
class SoundDto {
  final String id;
  final String nameKey;
  final String assetPath;
  final String category; // Enum as string

  const SoundDto({
    required this.id,
    required this.nameKey,
    required this.assetPath,
    required this.category,
  });

  SoundEntity toEntity() {
    return SoundEntity(
      id: id,
      nameKey: nameKey,
      assetPath: assetPath,
      category: SoundCategory.values.firstWhere(
        (e) => e.name == category,
        orElse: () => SoundCategory.nature,
      ),
    );
  }

  factory SoundDto.fromEntity(SoundEntity entity) {
    return SoundDto(
      id: entity.id,
      nameKey: entity.nameKey,
      assetPath: entity.assetPath,
      category: entity.category.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nameKey': nameKey,
      'assetPath': assetPath,
      'category': category,
    };
  }

  factory SoundDto.fromJson(Map<String, dynamic> json) {
    return SoundDto(
      id: json['id'] as String,
      nameKey: json['nameKey'] as String,
      assetPath: json['assetPath'] as String,
      category: json['category'] as String,
    );
  }
}
