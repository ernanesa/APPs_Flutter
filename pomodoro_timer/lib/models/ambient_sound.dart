import 'package:flutter/material.dart';

/// Represents an ambient sound option for focus sessions.
class AmbientSound {
  final String id;
  final String nameKey; // i18n key
  final IconData icon;
  final Color color;
  final String? assetPath; // null means silence

  const AmbientSound({
    required this.id,
    required this.nameKey,
    required this.icon,
    required this.color,
    this.assetPath,
  });
}

/// Predefined ambient sounds.
class AmbientSounds {
  static const silence = AmbientSound(
    id: 'silence',
    nameKey: 'soundSilence',
    icon: Icons.volume_off,
    color: Colors.grey,
    assetPath: null,
  );

  static const rain = AmbientSound(
    id: 'rain',
    nameKey: 'soundRain',
    icon: Icons.water_drop,
    color: Colors.blue,
    assetPath: 'assets/sounds/rain.mp3',
  );

  static const forest = AmbientSound(
    id: 'forest',
    nameKey: 'soundForest',
    icon: Icons.forest,
    color: Colors.green,
    assetPath: 'assets/sounds/forest.mp3',
  );

  static const ocean = AmbientSound(
    id: 'ocean',
    nameKey: 'soundOcean',
    icon: Icons.waves,
    color: Colors.cyan,
    assetPath: 'assets/sounds/ocean.mp3',
  );

  static const cafe = AmbientSound(
    id: 'cafe',
    nameKey: 'soundCafe',
    icon: Icons.local_cafe,
    color: Colors.brown,
    assetPath: 'assets/sounds/cafe.mp3',
  );

  static const fireplace = AmbientSound(
    id: 'fireplace',
    nameKey: 'soundFireplace',
    icon: Icons.fireplace,
    color: Colors.orange,
    assetPath: 'assets/sounds/fireplace.mp3',
  );

  static const whiteNoise = AmbientSound(
    id: 'white_noise',
    nameKey: 'soundWhiteNoise',
    icon: Icons.graphic_eq,
    color: Colors.blueGrey,
    assetPath: 'assets/sounds/white_noise.mp3',
  );

  static const thunder = AmbientSound(
    id: 'thunder',
    nameKey: 'soundThunder',
    icon: Icons.thunderstorm,
    color: Colors.deepPurple,
    assetPath: 'assets/sounds/thunder.mp3',
  );

  static List<AmbientSound> get all => [
    silence,
    rain,
    forest,
    ocean,
    cafe,
    fireplace,
    whiteNoise,
    thunder,
  ];
}
