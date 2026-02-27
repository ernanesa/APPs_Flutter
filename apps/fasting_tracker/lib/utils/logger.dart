import 'package:flutter/foundation.dart';

/// Logger utility that is completely removed in release builds
void logDebug(String message) {
  if (kDebugMode) {
    debugPrint('[FastingTracker] $message');
  }
}

void logError(String message, [Object? error, StackTrace? stackTrace]) {
  if (kDebugMode) {
    debugPrint('[FastingTracker ERROR] $message');
    if (error != null) debugPrint('$error');
    if (stackTrace != null) debugPrint('$stackTrace');
  }
}
