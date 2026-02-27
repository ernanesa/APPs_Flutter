import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/sound_entity.dart';
import 'repository_providers.dart';

final soundsProvider = FutureProvider<List<SoundEntity>>((ref) async {
  return ref.watch(soundRepositoryProvider).getAllSounds();
});
