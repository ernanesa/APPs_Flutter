import 'package:flutter/foundation.dart';

/// Production-safe logger that only prints in debug mode.
/// In release builds, these calls are completely removed by tree shaking.
void logDebug(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
