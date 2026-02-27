import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bmi_calculator/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('BMI Calculator Visual E2E Journey', (WidgetTester tester) async {
    await app.main();
    await tester.pumpAndSettle();

    Future<void> humanDelay() async {
      await Future.delayed(const Duration(seconds: 2));
      await tester.pump();
    }

    print("👤 Humano abrindo o BMI Calculator...");
    await humanDelay();

    // Encontrar campos de entrada (identificados no calculator_screen.dart)
    // O primeiro buildInputCard é Weight, o segundo é Height.
    // Como são TextFields dentro de Cards, vamos buscá-los por tipo e ordem.
    
    print("⌨️ Inserindo Peso...");
    final weightField = find.byType(TextField).at(0);
    await tester.enterText(weightField, "85");
    await tester.pumpAndSettle();
    await humanDelay();

    print("⌨️ Inserindo Altura...");
    final heightField = find.byType(TextField).at(1);
    await tester.enterText(heightField, "185");
    await tester.pumpAndSettle();
    await humanDelay();

    print("👆 Tocando no botão Calcular...");
    final calcButton = find.widgetWithText(FilledButton, 'CALCULATE');
    await tester.tap(calcButton);
    await tester.pumpAndSettle();
    await humanDelay();
    
    print("✅ Verificando se o resultado apareceu...");
    expect(find.text("24.8"), findsOneWidget); // BMI de 85kg/1.85m é ~24.8
    await humanDelay();
    
    print("💾 Salvando o resultado...");
    final saveButton = find.widgetWithIcon(ElevatedButton, Icons.save);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
    await humanDelay();

    print("✅ Teste finalizado visualmente com sucesso.");
    await humanDelay();
  });

}
