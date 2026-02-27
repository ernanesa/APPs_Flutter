import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fasting_tracker/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Fasting Tracker Visual E2E', (WidgetTester tester) async {
    await app.main();
    await tester.pumpAndSettle();
    Future<void> humanDelay() async { await Future.delayed(const Duration(seconds: 2)); await tester.pump(); }
    print("�� Humano abrindo Fasting...");
    await humanDelay();
    print("✅ Fasting Teste finalizado.");
  });
}
