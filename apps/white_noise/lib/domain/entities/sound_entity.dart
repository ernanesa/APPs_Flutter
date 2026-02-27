/// Entity representing a sound available in the app
/// Pure Dart - no external dependencies (Clean Architecture)
class SoundEntity {
  final String id;
  final String nameKey; // i18n key
  final String assetPath;
  final SoundCategory category;
  final bool isLocked;

  const SoundEntity({
    required this.id,
    required this.nameKey,
    required this.assetPath,
    required this.category,
    this.isLocked = false,
  });

  SoundEntity copyWith({
    String? id,
    String? nameKey,
    String? assetPath,
    SoundCategory? category,
    bool? isLocked,
  }) {
    return SoundEntity(
      id: id ?? this.id,
      nameKey: nameKey ?? this.nameKey,
      assetPath: assetPath ?? this.assetPath,
      category: category ?? this.category,
      isLocked: isLocked ?? this.isLocked,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SoundEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

enum SoundCategory {
  rain,
  nature,
  water,
  noise, // white, pink, brown noise for children's sleep
  ambient,
}

/// Default sounds available in the app
class DefaultSounds {
  // Rain sounds
  static const rainLight = SoundEntity(
    id: 'rain_light',
    nameKey: 'soundRainLight',
    assetPath: 'sounds/rain_light.mp3',
    category: SoundCategory.rain,
  );

  static const rainHeavy = SoundEntity(
    id: 'rain_heavy',
    nameKey: 'soundRainHeavy',
    assetPath: 'sounds/rain_heavy.mp3',
    category: SoundCategory.rain,
  );

  static const storm = SoundEntity(
    id: 'storm',
    nameKey: 'soundStorm',
    assetPath: 'sounds/storm.mp3',
    category: SoundCategory.rain,
  );

  static const rainRoof = SoundEntity(
    id: 'rain_roof',
    nameKey: 'soundRainRoof',
    assetPath: 'sounds/rain_roof.mp3',
    category: SoundCategory.rain,
  );

  // Nature sounds
  static const forest = SoundEntity(
    id: 'forest',
    nameKey: 'soundForest',
    assetPath: 'sounds/forest.mp3',
    category: SoundCategory.nature,
  );

  // Water sounds
  static const ocean = SoundEntity(
    id: 'ocean',
    nameKey: 'soundOcean',
    assetPath: 'sounds/ocean.mp3',
    category: SoundCategory.water,
  );

  static const river = SoundEntity(
    id: 'river',
    nameKey: 'soundRiver',
    assetPath: 'sounds/river.mp3',
    category: SoundCategory.water,
  );

  static const waterfall = SoundEntity(
    id: 'waterfall',
    nameKey: 'soundWaterfall',
    assetPath: 'sounds/waterfall.mp3',
    category: SoundCategory.water,
  );

  // Ambient sounds
  static const fireplace = SoundEntity(
    id: 'fireplace',
    nameKey: 'soundFireplace',
    assetPath: 'sounds/fireplace.mp3',
    category: SoundCategory.ambient,
  );

  static const cafe = SoundEntity(
    id: 'cafe',
    nameKey: 'soundCafe',
    assetPath: 'sounds/cafe.mp3',
    category: SoundCategory.ambient,
  );

  // Noise sounds (for children's sleep - PRIMARY FEATURE)
  static const whiteNoise = SoundEntity(
    id: 'white_noise',
    nameKey: 'soundWhiteNoise',
    assetPath: 'sounds/white_noise.mp3',
    category: SoundCategory.noise,
  );

  static const pinkNoise = SoundEntity(
    id: 'pink_noise',
    nameKey: 'soundPinkNoise',
    assetPath: 'sounds/pink_noise.mp3',
    category: SoundCategory.noise,
  );

  static const brownNoise = SoundEntity(
    id: 'brown_noise',
    nameKey: 'soundBrownNoise',
    assetPath: 'sounds/brown_noise.mp3',
    category: SoundCategory.noise,
  );

  /// All available sounds (12 total)
  static const List<SoundEntity> all = [
    // Rain (4)
    rainLight,
    rainHeavy,
    storm,
    rainRoof,
    // Nature (1)
    forest,
    // Water (3)
    ocean,
    river,
    waterfall,
    // Ambient (2)
    fireplace,
    cafe,
    // Noise (3) - Children's sleep
    whiteNoise,
    pinkNoise,
    brownNoise,
  ];

  /// Get sounds by category
  static List<SoundEntity> getByCategory(SoundCategory category) {
    return all.where((sound) => sound.category == category).toList();
  }

  /// Find sound by ID
  static SoundEntity? findById(String id) {
    try {
      return all.firstWhere((sound) => sound.id == id);
    } catch (_) {
      return null;
    }
  }
}
