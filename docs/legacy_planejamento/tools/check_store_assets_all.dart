import 'dart:io';
import 'dart:typed_data';

/// Cross-platform validation for Play Store assets under:
/// `apps/<cluster>/<app>/publishing/store_assets/`
///
/// Rules:
/// - Must contain `icon_512.png` exactly 512x512
/// - Must contain `feature_1024x500.png` exactly 1024x500
/// - Must contain at least 2 screenshots (png/jpg/jpeg) with name containing
///   "phone" or "screenshot"
/// - Screenshots must be within 320..3840 and portrait (height > width)
///
/// Usage:
///   dart run tools/check_store_assets_all.dart
///   dart run tools/check_store_assets_all.dart --root=apps
int main(List<String> args) {
  final publishingRoot = _argValue(args, '--root') ?? _join('apps');
  final rootDir = Directory.current;
  final pubDir = Directory(_join(rootDir.path, publishingRoot));

  if (!pubDir.existsSync()) {
    stdout.writeln('Publishing root not found (skipping): ${pubDir.path}');
    return 0;
  }

  final storeDirs = <Directory>[];
  // Expected: apps/<cluster>/<app>/publishing/store_assets
  for (final cluster in pubDir.listSync(followLinks: false)) {
    if (cluster is! Directory) continue;
    for (final app in cluster.listSync(followLinks: false)) {
      if (app is! Directory) continue;
      final store = Directory(_join(app.path, 'publishing', 'store_assets'));
      if (store.existsSync()) storeDirs.add(store);
    }
  }
  storeDirs.sort((a, b) => a.path.compareTo(b.path));

  if (storeDirs.isEmpty) {
    stdout.writeln('No store_assets directories found under: ${pubDir.path}');
    return 0;
  }

  stdout.writeln('Validating Play Store assets for ${storeDirs.length} app(s)...');
  var failed = false;

  for (final dir in storeDirs) {
    final rel = _relativePath(dir.path, rootDir.path);
    stdout.writeln('\n==> $rel');
    final ok = _checkStoreAssets(dir);
    if (!ok) failed = true;
  }

  if (failed) {
    stderr.writeln('\nFAIL: store assets validation failed.');
    return 1;
  }

  stdout.writeln('\nOK: store assets validation passed for all apps.');
  return 0;
}

bool _checkStoreAssets(Directory assetsDir) {
  var ok = true;

  ok &= _requireExactImage(assetsDir, 'icon_512.png', 512, 512);
  ok &= _requireFeatureGraphic(assetsDir);

  final screenshotFiles = _findScreenshots(assetsDir);

  if (screenshotFiles.length < 2) {
    stderr.writeln(
      'Missing screenshots: expected >= 2 files named like "*phone*" or "*screenshot*". Found: ${screenshotFiles.length}',
    );
    ok = false;
  } else {
    stdout.writeln('Found phone screenshots: ${screenshotFiles.length}');
    for (final f in screenshotFiles) {
      final dims = _imageDimensions(f);
      if (dims == null) {
        stderr.writeln('Invalid image (unsupported or corrupt): ${_baseName(f.path)}');
        ok = false;
        continue;
      }
      final (w, h) = dims;
      const min = 320;
      const max = 3840;
      if (w < min || h < min || w > max || h > max) {
        stderr.writeln('Invalid screenshot size range: ${_baseName(f.path)} = ${w}x$h (must be $min..$max)');
        ok = false;
        continue;
      }
      if (h <= w) {
        // Play Store accepts both, but portrait is the safest default.
        stdout.writeln('  WARN: screenshot is landscape: ${_baseName(f.path)} = ${w}x$h');
      }
      stdout.writeln('  OK: ${_baseName(f.path)} = ${w}x$h');
    }
  }

  return ok;
}

bool _requireExactImage(Directory dir, String name, int w, int h) {
  final file = File(_join(dir.path, name));
  if (!file.existsSync()) {
    stderr.writeln('Missing required file: $name');
    return false;
  }
  final dims = _imageDimensions(file);
  if (dims == null) {
    stderr.writeln('Invalid image: $name');
    return false;
  }
  final (iw, ih) = dims;
  if (iw != w || ih != h) {
    stderr.writeln('Invalid size for $name: ${iw}x$ih (expected ${w}x$h)');
    return false;
  }

  // Warn if extension doesn't match actual format (common legacy issue).
  final actual = _detectFormat(file);
  final lower = name.toLowerCase();
  if (actual != null) {
    if (actual == 'jpeg' && lower.endsWith('.png')) {
      stdout.writeln('WARN: $name is actually JPEG (consider renaming/re-exporting as PNG)');
    }
    if (actual == 'png' && (lower.endsWith('.jpg') || lower.endsWith('.jpeg'))) {
      stdout.writeln('WARN: $name is actually PNG (consider renaming)');
    }
  }

  stdout.writeln('OK: $name = ${iw}x$ih');
  return true;
}

bool _requireFeatureGraphic(Directory storeAssetsDir) {
  // Legacy folders use `feature_graphic.png`. Some releases keep `feature_1024x500.png`.
  const expectedW = 1024;
  const expectedH = 500;
  final candidates = <String>[
    'feature_graphic.png',
    'feature_1024x500.png',
  ];

  for (final name in candidates) {
    final file = File(_join(storeAssetsDir.path, name));
    if (!file.existsSync()) continue;
    final dims = _imageDimensions(file);
    if (dims == null) {
      stderr.writeln('Invalid image: $name');
      return false;
    }
    final (w, h) = dims;
    if (w != expectedW || h != expectedH) {
      stderr.writeln('Invalid size for $name: ${w}x$h (expected ${expectedW}x$expectedH)');
      return false;
    }
    stdout.writeln('OK: $name = ${w}x$h');
    return true;
  }

  stderr.writeln('Missing required file: feature_graphic.png (or feature_1024x500.png)');
  return false;
}

List<File> _findScreenshots(Directory storeAssetsDir) {
  final results = <File>[];
  void addFrom(Directory dir, {required bool acceptAllImages}) {
    if (!dir.existsSync()) return;
    for (final e in dir.listSync(followLinks: false)) {
      if (e is! File) continue;
      final name = _baseName(e.path).toLowerCase();
      if (!(name.endsWith('.png') || name.endsWith('.jpg') || name.endsWith('.jpeg'))) continue;
      if (acceptAllImages || name.contains('phone') || name.contains('screenshot')) {
        results.add(e);
      }
    }
  }

  // Store assets (root + screenshots subdir).
  addFrom(storeAssetsDir, acceptAllImages: false);
  addFrom(Directory(_join(storeAssetsDir.path, 'screenshots')), acceptAllImages: true);

  // Some legacy apps keep the "real" screenshots in release_assets.
  final appDir = storeAssetsDir.parent;
  final releaseDir = Directory(_join(appDir.path, 'release_assets'));
  addFrom(releaseDir, acceptAllImages: false);
  addFrom(Directory(_join(releaseDir.path, 'screenshots')), acceptAllImages: true);

  results.sort((a, b) => a.path.compareTo(b.path));
  return results;
}

/// Returns (width, height) or null.
(int, int)? _imageDimensions(File file) {
  final name = _baseName(file.path).toLowerCase();
  if (name.endsWith('.png')) {
    final dims = _pngDimensions(file);
    if (dims != null) return dims;
    // Fallback: some legacy files are misnamed (e.g., JPEG saved as .png).
    final format = _detectFormat(file);
    if (format == 'jpeg') return _jpegDimensions(file);
    return null;
  }

  if (name.endsWith('.jpg') || name.endsWith('.jpeg')) {
    final dims = _jpegDimensions(file);
    if (dims != null) return dims;
    final format = _detectFormat(file);
    if (format == 'png') return _pngDimensions(file);
    return null;
  }

  final format = _detectFormat(file);
  if (format == 'png') return _pngDimensions(file);
  if (format == 'jpeg') return _jpegDimensions(file);
  return null;
}

String? _detectFormat(File file) {
  final raw = file.readAsBytesSync();
  final bytes = raw.length <= 16 ? raw : raw.sublist(0, 16);
  if (bytes.length >= 8) {
    const sig = [137, 80, 78, 71, 13, 10, 26, 10];
    var isPng = true;
    for (var i = 0; i < sig.length; i++) {
      if (bytes[i] != sig[i]) {
        isPng = false;
        break;
      }
    }
    if (isPng) return 'png';
  }
  if (bytes.length >= 2 && bytes[0] == 0xFF && bytes[1] == 0xD8) return 'jpeg';
  return null;
}

/// Parses PNG IHDR width/height (big-endian) without dependencies.
(int, int)? _pngDimensions(File file) {
  final bytes = file.readAsBytesSync();
  if (bytes.length < 24) return null;

  // PNG signature
  const sig = [137, 80, 78, 71, 13, 10, 26, 10];
  for (var i = 0; i < sig.length; i++) {
    if (bytes[i] != sig[i]) return null;
  }

  // IHDR starts at byte 12: length(4) + type(4) then data.
  // Width/Height are the first 8 bytes of IHDR data at offset 16.
  final w = _readU32be(bytes, 16);
  final h = _readU32be(bytes, 20);
  if (w <= 0 || h <= 0) return null;
  return (w, h);
}

/// Parses JPEG SOF width/height (big-endian) without dependencies.
(int, int)? _jpegDimensions(File file) {
  final bytes = file.readAsBytesSync();
  if (bytes.length < 4) return null;
  if (bytes[0] != 0xFF || bytes[1] != 0xD8) return null; // SOI

  var i = 2;
  while (i + 3 < bytes.length) {
    if (bytes[i] != 0xFF) {
      i++;
      continue;
    }

    // Skip padding FFs.
    while (i < bytes.length && bytes[i] == 0xFF) {
      i++;
    }
    if (i >= bytes.length) break;

    final marker = bytes[i++];
    // Standalone markers (no length).
    if (marker == 0xD9 || marker == 0xDA) break; // EOI or SOS

    if (i + 1 >= bytes.length) break;
    final len = (bytes[i] << 8) | bytes[i + 1];
    if (len < 2 || i + len - 2 >= bytes.length) return null;

    final isSof = marker == 0xC0 ||
        marker == 0xC1 ||
        marker == 0xC2 ||
        marker == 0xC3 ||
        marker == 0xC5 ||
        marker == 0xC6 ||
        marker == 0xC7 ||
        marker == 0xC9 ||
        marker == 0xCA ||
        marker == 0xCB ||
        marker == 0xCD ||
        marker == 0xCE ||
        marker == 0xCF;

    if (isSof) {
      // SOF segment: [len(2)][precision(1)][height(2)][width(2)]...
      final start = i + 2; // after len bytes
      final h = (bytes[start + 1] << 8) | bytes[start + 2];
      final w = (bytes[start + 3] << 8) | bytes[start + 4];
      if (w <= 0 || h <= 0) return null;
      return (w, h);
    }

    i += len;
  }
  return null;
}

int _readU32be(Uint8List bytes, int offset) {
  return (bytes[offset] << 24) | (bytes[offset + 1] << 16) | (bytes[offset + 2] << 8) | bytes[offset + 3];
}

String? _argValue(List<String> args, String key) {
  for (final a in args) {
    if (a.startsWith('$key=')) return a.substring(key.length + 1);
  }
  return null;
}

String _join(String a, [String? b, String? c, String? d]) {
  final parts = <String>[a];
  if (b != null) parts.add(b);
  if (c != null) parts.add(c);
  if (d != null) parts.add(d);
  return parts.join(Platform.pathSeparator);
}

String _baseName(String path) => path.split(Platform.pathSeparator).last;

String _relativePath(String fullPath, String basePath) {
  final base = basePath.endsWith(Platform.pathSeparator) ? basePath : '$basePath${Platform.pathSeparator}';
  if (fullPath.startsWith(base)) return fullPath.substring(base.length);
  return fullPath;
}
