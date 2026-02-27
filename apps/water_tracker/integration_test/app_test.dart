import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:water_tracker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Water Tracker Visual E2E Journey', (WidgetTester tester) async {
    // Inicia o app
    await app.main();
    await tester.pumpAndSettle();
    
    // Funcao para desacelerar o teste imitando um ser humano vendo a tela
    Future<void> humanDelay() async {
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
    }

    print("👤 Humano abrindo o App...");
    await humanDelay();
    await humanDelay(); // Dá um tempo extra na tela inicial
    
    final addButton = find.text('Drink a Glass (+250ml)');
    expect(addButton, findsOneWidget);
    
    for(int i=1; i<=3; i++) {
        print("👆 Humano tocando no botão ('Copo $i')...");
        await tester.tap(addButton);
        await tester.pumpAndSettle();
        await humanDelay();
    }
    
    print("✅ Teste finalizado visualmente com sucesso.");
    await humanDelay();
  });
}
