import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pomodoro_timer/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Pomodoro Timer Visual E2E Journey', (WidgetTester tester) async {
    await app.main();
    await tester.pumpAndSettle();

    Future<void> humanDelay() async {
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
    }

    print("👤 Humano abrindo o Pomodoro Timer...");
    await humanDelay();

    // Iniciar Timer
    print("👆 Iniciando o Timer...");
    final playButton = find.byIcon(Icons.play_arrow);
    await tester.tap(playButton);
    await tester.pumpAndSettle();
    await humanDelay();

    // Pausar Timer
    print("👆 Pausando o Timer...");
    final pauseButton = find.byIcon(Icons.pause);
    await tester.tap(pauseButton);
    await tester.pumpAndSettle();
    await humanDelay();

    // Resetar Timer
    print("👆 Resetando o Timer...");
    final resetButton = find.byIcon(Icons.refresh);
    await tester.tap(resetButton);
    await tester.pumpAndSettle();
    await humanDelay();

    // Pular Sessão
    print("👆 Pulando para próxima sessão...");
    final skipButton = find.byIcon(Icons.skip_next);
    await tester.tap(skipButton);
    await tester.pumpAndSettle();
    await humanDelay();

    // Abrir Configurações
    print("⚙️ Abrindo Configurações...");
    final settingsButton = find.byIcon(Icons.settings_outlined);
    await tester.tap(settingsButton);
    await tester.pumpAndSettle();
    await humanDelay();

    // Voltar para Home
    print("🔙 Voltando...");
    await tester.pageBack();
    await tester.pumpAndSettle();
    await humanDelay();

    print("✅ Teste finalizado visualmente com sucesso.");
    await humanDelay();
  });
}
