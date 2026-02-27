import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Define a shared preferences instance globally accessible via Riverpod.
/// This must be overridden in the root `ProviderScope` of each application.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider was not overridden in ProviderScope',
  );
});
