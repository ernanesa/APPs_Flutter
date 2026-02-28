import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/settings_provider.dart';

class HapticService {
  static void lightImpact(WidgetRef ref) {
    if (ref.read(settingsProvider).hapticEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  static void mediumImpact(WidgetRef ref) {
    if (ref.read(settingsProvider).hapticEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  static void heavyImpact(WidgetRef ref) {
    if (ref.read(settingsProvider).hapticEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  static void selectionClick(WidgetRef ref) {
    if (ref.read(settingsProvider).hapticEnabled) {
      HapticFeedback.selectionClick();
    }
  }
}
