import 'package:flutter/foundation.dart';

/// Logger que é completamente removido em release via tree-shaking
void logDebug(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}

void logError(String message, [Object? error, StackTrace? stackTrace]) {
  if (kDebugMode) {
    debugPrint('ERROR: $message');
    if (error != null) debugPrint('$error');
    if (stackTrace != null) debugPrint('$stackTrace');
  }
}
