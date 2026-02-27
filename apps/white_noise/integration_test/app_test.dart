import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:white_noise/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('White Noise Visual E2E', (WidgetTester tester) async {
    await app.main();
    await tester.pumpAndSettle();
    Future<void> humanDelay() async { await Future.delayed(const Duration(seconds: 2)); await tester.pump(); }
    print("👤 Humano abrindo White Noise...");
    await humanDelay();
    print("✅ White Noise Teste finalizado.");
  });
}
