import 'dart:io';

void main() async {
  final appsDir = Directory('apps');
  final clusters = [
    'finance',
    'health',
    'media',
    'productivity',
    'utility',
    'niche',
    'tools',
  ];

  final List<AppStatus> allApps = [];

  for (final cluster in clusters) {
    final clusterDir = Directory('${appsDir.path}/$cluster');
    if (!clusterDir.existsSync()) continue;

    final apps = clusterDir
        .listSync()
        .whereType<Directory>()
        .where((d) => !d.path.endsWith('.') && !d.path.endsWith('..'))
        .toList();

    for (final appDir in apps) {
      final appName = appDir.path.split('/').last;
      final status = analyzeApp(appDir, appName, cluster);
      allApps.add(status);
    }
  }

  // Ordenar do maior para o menor percentual
  allApps.sort((a, b) => b.percentage.compareTo(a.percentage));

  // Gerar arquivo markdown
  final buffer = StringBuffer();
  buffer.writeln('# Apps Ranqueados por Percentual de Completude');
  buffer.writeln('');
  buffer.writeln(
    '**Data:** ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
  );
  buffer.writeln('**Total de Apps:** ${allApps.length}');
  buffer.writeln('');
  buffer.writeln('---');
  buffer.writeln('');

  // Estatísticas
  final completed = allApps.where((a) => a.percentage >= 100).length;
  final almostDone =
      allApps.where((a) => a.percentage >= 75 && a.percentage < 100).length;
  final inProgress =
      allApps.where((a) => a.percentage >= 25 && a.percentage < 75).length;
  final justStarted =
      allApps.where((a) => a.percentage > 0 && a.percentage < 25).length;
  final notStarted = allApps.where((a) => a.percentage == 0).length;

  buffer.writeln('## Resumo Executivo');
  buffer.writeln('');
  buffer.writeln('| Status | Quantidade | % do Total |');
  buffer.writeln('|--------|------------|------------|');
  buffer.writeln(
    '| ✅ Completos (100%) | $completed | ${(completed * 100 / allApps.length).toStringAsFixed(1)}% |',
  );
  buffer.writeln(
    '| 🟢 Quase Prontos (75-99%) | $almostDone | ${(almostDone * 100 / allApps.length).toStringAsFixed(1)}% |',
  );
  buffer.writeln(
    '| 🟡 Em Progresso (25-74%) | $inProgress | ${(inProgress * 100 / allApps.length).toStringAsFixed(1)}% |',
  );
  buffer.writeln(
    '| 🟠 Iniciados (1-24%) | $justStarted | ${(justStarted * 100 / allApps.length).toStringAsFixed(1)}% |',
  );
  buffer.writeln(
    '| ⚪ Não Iniciados (0%) | $notStarted | ${(notStarted * 100 / allApps.length).toStringAsFixed(1)}% |',
  );
  buffer.writeln('');
  buffer.writeln('---');
  buffer.writeln('');

  buffer.writeln('## Lista Completa (Ordenada por Completude)');
  buffer.writeln('');
  buffer.writeln(
    '| # | App | Cluster | % | pubspec | main | l10n | 15 langs | tests | int_test | publishing | android |',
  );
  buffer.writeln(
    '|---|-----|---------|---|:-------:|:----:|:----:|:--------:|:-----:|:--------:|:----------:|:-------:|',
  );

  for (var i = 0; i < allApps.length; i++) {
    final app = allApps[i];
    final rank = i + 1;
    final emoji = app.percentage >= 100
        ? '✅'
        : app.percentage >= 75
            ? '🟢'
            : app.percentage >= 25
                ? '🟡'
                : app.percentage > 0
                    ? '🟠'
                    : '⚪';

    buffer.writeln(
      '| $rank | $emoji ${app.name} | ${app.cluster} | **${app.percentage}%** | ${app.hasPubspec ? '✅' : '❌'} | ${app.hasMain ? '✅' : '❌'} | ${app.hasL10n ? '✅' : '❌'} | ${app.has15Langs ? '✅' : app.arbCount > 0 ? '⚠️ ${app.arbCount}' : '❌'} | ${app.hasTests ? '✅' : '❌'} | ${app.hasIntegrationTest ? '✅' : '❌'} | ${app.hasPublishing ? '✅' : '❌'} | ${app.hasAndroid ? '✅' : '❌'} |',
    );
  }

  buffer.writeln('');
  buffer.writeln('---');
  buffer.writeln('');
  buffer.writeln('## Top 10 por Cluster');
  buffer.writeln('');

  for (final cluster in clusters) {
    final clusterApps =
        allApps.where((a) => a.cluster == cluster).take(10).toList();
    if (clusterApps.isEmpty) continue;

    buffer.writeln('### ${cluster.toUpperCase()}');
    buffer.writeln('');
    for (var i = 0; i < clusterApps.length; i++) {
      final app = clusterApps[i];
      final emoji = app.percentage >= 75
          ? '🟢'
          : app.percentage >= 25
              ? '🟡'
              : '🟠';
      buffer.writeln('${i + 1}. $emoji **${app.name}** - ${app.percentage}%');
    }
    buffer.writeln('');
  }

  // Salvar arquivo
  final outputFile = File('APPS_RANKED_BY_COMPLETION.md');
  await outputFile.writeAsString(buffer.toString());

  print('✅ Lista criada: APPS_RANKED_BY_COMPLETION.md');
  print('📊 Total de apps analisados: ${allApps.length}');
  print('🏆 Top 5:');
  for (var i = 0; i < 5 && i < allApps.length; i++) {
    print(
      '   ${i + 1}. ${allApps[i].name} (${allApps[i].cluster}) - ${allApps[i].percentage}%',
    );
  }
}

class AppStatus {
  AppStatus({
    required this.name,
    required this.cluster,
    required this.hasPubspec,
    required this.hasMain,
    required this.hasL10n,
    required this.has15Langs,
    required this.arbCount,
    required this.hasTests,
    required this.hasIntegrationTest,
    required this.hasPublishing,
    required this.hasAndroid,
    required this.percentage,
  });
  final String name;
  final String cluster;
  final bool hasPubspec;
  final bool hasMain;
  final bool hasL10n;
  final bool has15Langs;
  final int arbCount;
  final bool hasTests;
  final bool hasIntegrationTest;
  final bool hasPublishing;
  final bool hasAndroid;
  final int percentage;
}

AppStatus analyzeApp(Directory appDir, String appName, String cluster) {
  final hasPubspec = File('${appDir.path}/pubspec.yaml').existsSync();
  final hasMain = File('${appDir.path}/lib/main.dart').existsSync();
  final hasL10n = File('${appDir.path}/l10n.yaml').existsSync();

  // Contar arquivos ARB
  int arbCount = 0;
  final l10nDir = Directory('${appDir.path}/lib/l10n');
  if (l10nDir.existsSync()) {
    arbCount = l10nDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.arb'))
        .length;
  }
  final has15Langs = arbCount >= 15;

  final hasTests = Directory('${appDir.path}/test').existsSync();
  final hasIntegrationTest =
      Directory('${appDir.path}/integration_test').existsSync();
  final hasPublishing = Directory('${appDir.path}/publishing').existsSync();
  final hasAndroid = Directory('${appDir.path}/android').existsSync();

  // Calcular percentual (8 critérios)
  int completed = 0;
  if (hasPubspec) completed++;
  if (hasMain) completed++;
  if (hasL10n) completed++;
  if (has15Langs) completed++;
  if (hasTests) completed++;
  if (hasIntegrationTest) completed++;
  if (hasPublishing) completed++;
  if (hasAndroid) completed++;

  final percentage = ((completed / 8) * 100).round();

  return AppStatus(
    name: appName,
    cluster: cluster,
    hasPubspec: hasPubspec,
    hasMain: hasMain,
    hasL10n: hasL10n,
    has15Langs: has15Langs,
    arbCount: arbCount,
    hasTests: hasTests,
    hasIntegrationTest: hasIntegrationTest,
    hasPublishing: hasPublishing,
    hasAndroid: hasAndroid,
    percentage: percentage,
  );
}
