import 'dart:io';

void main() async {
  final appsRoot = Directory('apps');
  final results = <String, Map<String, dynamic>>{};

  // Find all apps
  for (final cluster in appsRoot.listSync()) {
    if (cluster is! Directory) continue;
    final clusterName = cluster.path.split('/').last;

    for (final app in cluster.listSync()) {
      if (app is! Directory) continue;
      final appName = app.path.split('/').last;
      if (appName == '.gitkeep') continue;

      final appPath = app.path;
      final key = '$clusterName/$appName';

      results[key] = {
        'cluster': clusterName,
        'name': appName,
        'has_pubspec': File('$appPath/pubspec.yaml').existsSync(),
        'has_main': File('$appPath/lib/main.dart').existsSync(),
        'has_l10n_yaml': File('$appPath/l10n.yaml').existsSync(),
        'has_test_dir': Directory('$appPath/test').existsSync(),
        'has_integration_test':
            Directory('$appPath/integration_test').existsSync(),
        'arb_count': _countArbFiles(appPath),
        'has_publishing': Directory('$appPath/publishing').existsSync(),
        'has_android': Directory('$appPath/android').existsSync(),
      };
    }
  }

  // Sort by cluster then name
  final sorted = results.entries.toList()
    ..sort((a, b) {
      final cmp = a.value['cluster'].compareTo(b.value['cluster']);
      if (cmp != 0) return cmp;
      return a.value['name'].compareTo(b.value['name']);
    });

  // Print summary
  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('📊 FLUTTER APP FACTORY - STATUS REPORT');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  var total = 0;
  var complete = 0;
  var inProgress = 0;
  var notStarted = 0;

  String currentCluster = '';

  for (final entry in sorted) {
    total++;
    final data = entry.value;
    final cluster = data['cluster'] as String;
    final name = data['name'] as String;
    final hasPubspec = data['has_pubspec'] as bool;
    final hasMain = data['has_main'] as bool;
    final hasL10n = data['has_l10n_yaml'] as bool;
    final hasTest = data['has_test_dir'] as bool;
    final hasIntTest = data['has_integration_test'] as bool;
    final arbCount = data['arb_count'] as int;
    final hasPublishing = data['has_publishing'] as bool;
    final hasAndroid = data['has_android'] as bool;

    // Print cluster header
    if (cluster != currentCluster) {
      if (currentCluster.isNotEmpty) print('');
      print('┌─ ${cluster.toUpperCase()} ─────────────────');
      currentCluster = cluster;
    }

    // Determine status
    String status;
    String emoji;
    if (hasPubspec && hasMain && hasL10n && arbCount >= 15 && hasAndroid) {
      status = 'COMPLETE';
      emoji = '✅';
      complete++;
    } else if (hasPubspec && hasMain) {
      status = 'IN PROGRESS';
      emoji = '🟡';
      inProgress++;
    } else {
      status = 'NOT STARTED';
      emoji = '⚪';
      notStarted++;
    }

    print('│ $emoji $name ($status)');

    if (status != 'NOT STARTED') {
      final checks = <String>[];
      if (hasPubspec) checks.add('pubspec');
      if (hasMain) checks.add('main');
      if (hasL10n) checks.add('l10n');
      if (arbCount >= 15) checks.add('15 langs');
      if (hasTest) checks.add('tests');
      if (hasIntTest) checks.add('int_test');
      if (hasPublishing) checks.add('publishing');
      if (hasAndroid) checks.add('android');

      print('│   └─ ${checks.join(', ')}');
      if (arbCount > 0 && arbCount < 15) {
        print('│      ⚠️  Only $arbCount ARB files (need 15)');
      }
    }
  }

  print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
  print('📈 SUMMARY');
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━SUMMARY━━━━━━━━');
  print('Total Apps:      $total');
  print(
    '✅ Complete:     $complete (${(complete / total * 100).toStringAsFixed(1)}%)',
  );
  print(
    '🟡 In Progress:  $inProgress (${(inProgress / total * 100).toStringAsFixed(1)}%)',
  );
  print(
    '⚪ Not Started:  $notStarted (${(notStarted / total * 100).toStringAsFixed(1)}%)',
  );
  print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
}

int _countArbFiles(String appPath) {
  final l10nDir = Directory('$appPath/lib/l10n');
  if (!l10nDir.existsSync()) return 0;
  return l10nDir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.arb'))
      .length;
}
