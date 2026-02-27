import 'dart:convert';
import 'dart:io';

/// Cross-platform validation for ARB keys in all apps.
///
/// Rule: every `lib/l10n/app_*.arb` must match the key set of `app_en.arb`
/// (ignoring metadata keys that start with '@').
///
/// Usage:
///   dart run tools/check_l10n_all.dart
///   dart run tools/check_l10n_all.dart --apps-root=apps
int main(List<String> args) {
  final appsRoot = _argValue(args, '--apps-root') ?? 'apps';
  final rootDir = Directory.current;
  final appsDir = Directory(_join(rootDir.path, appsRoot));

  if (!appsDir.existsSync()) {
    stderr.writeln('Apps root not found: ${appsDir.path}');
    return 1;
  }

  final appDirs = <Directory>[];
  for (final entity in appsDir.listSync(recursive: true, followLinks: false)) {
    if (entity is! Directory) continue;

    // Only accept "apps/<cluster>/<app>" depth.
    final rel = _relativePath(entity.path, rootDir.path);
    final parts = rel.split(Platform.pathSeparator);
    if (parts.length != 3 || parts.first != appsRoot) continue;

    final template = File(_join(entity.path, 'lib', 'l10n', 'app_en.arb'));
    if (template.existsSync()) {
      appDirs.add(entity);
    }
  }

  appDirs.sort((a, b) => a.path.compareTo(b.path));
  if (appDirs.isEmpty) {
    stdout.writeln('No apps with lib/l10n/app_en.arb found under: ${appsDir.path}');
    return 0;
  }

  stdout.writeln('Validating l10n for ${appDirs.length} app(s)...');
  var hadFailures = false;

  for (final appDir in appDirs) {
    final rel = _relativePath(appDir.path, rootDir.path);
    stdout.writeln('\n==> $rel');
    final ok = _checkApp(appDir);
    if (!ok) hadFailures = true;
  }

  if (hadFailures) {
    stderr.writeln('\nFAIL: l10n validation failed.');
    return 1;
  }

  stdout.writeln('\nOK: l10n validation passed for all apps.');
  return 0;
}

bool _checkApp(Directory appDir) {
  final l10nDir = Directory(_join(appDir.path, 'lib', 'l10n'));
  final templatePath = File(_join(l10nDir.path, 'app_en.arb'));
  if (!l10nDir.existsSync()) {
    stderr.writeln('  - Missing directory: ${l10nDir.path}');
    return false;
  }
  if (!templatePath.existsSync()) {
    stderr.writeln('  - Missing template: ${templatePath.path}');
    return false;
  }

  Map<String, dynamic> templateJson;
  try {
    templateJson = jsonDecode(templatePath.readAsStringSync()) as Map<String, dynamic>;
  } catch (e) {
    stderr.writeln('  - Invalid JSON: ${templatePath.path}: $e');
    return false;
  }

  final templateKeys = templateJson.keys.where((k) => !k.startsWith('@')).toSet();
  final arbFiles = l10nDir
      .listSync(followLinks: false)
      .whereType<File>()
      .where((f) => f.path.endsWith('.arb') && _baseName(f.path).startsWith('app_'))
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  if (arbFiles.length < 2) {
    stderr.writeln('  - Expected multiple ARB files in: ${l10nDir.path}');
    return false;
  }

  var ok = true;
  for (final file in arbFiles) {
    if (_baseName(file.path) == 'app_en.arb') continue;

    Map<String, dynamic> json;
    try {
      json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    } catch (e) {
      stderr.writeln('  - Invalid JSON: ${file.path}: $e');
      ok = false;
      continue;
    }

    final keys = json.keys.where((k) => !k.startsWith('@')).toSet();
    final missing = templateKeys.difference(keys).toList()..sort();
    final extra = keys.difference(templateKeys).toList()..sort();

    if (missing.isEmpty && extra.isEmpty) continue;

    ok = false;
    stdout.writeln('  * ${_baseName(file.path)}');
    if (missing.isNotEmpty) {
      stdout.writeln('    Missing keys (${missing.length}):');
      for (final k in missing) {
        stdout.writeln('      - $k');
      }
    }
    if (extra.isNotEmpty) {
      stdout.writeln('    Extra keys (${extra.length}):');
      for (final k in extra) {
        stdout.writeln('      + $k');
      }
    }
  }

  if (ok) {
    stdout.writeln('  OK');
  }

  return ok;
}

String? _argValue(List<String> args, String key) {
  for (final a in args) {
    if (a.startsWith('$key=')) return a.substring(key.length + 1);
  }
  return null;
}

String _join(String a, [String? b, String? c, String? d, String? e]) {
  final parts = <String>[a];
  if (b != null) parts.add(b);
  if (c != null) parts.add(c);
  if (d != null) parts.add(d);
  if (e != null) parts.add(e);
  return parts.join(Platform.pathSeparator);
}

String _baseName(String path) => path.split(Platform.pathSeparator).last;

String _relativePath(String fullPath, String basePath) {
  final base = basePath.endsWith(Platform.pathSeparator) ? basePath : '$basePath${Platform.pathSeparator}';
  if (fullPath.startsWith(base)) return fullPath.substring(base.length);
  return fullPath;
}

