import 'package:flutter_test/flutter_test.dart';
import 'package:bmi_calculator/logic/bmi_logic.dart';

void main() {
  group('BmiLogic Tests', () {
    test('Should calculate IMC correctly', () {
      // Peso 70kg, Altura 1.75m (175cm)
      // IMC = 70 / (1.75 * 1.75) = 22.857...
      final result = BmiLogic.calculateBmi(70, 175);
      expect(result, closeTo(22.85, 0.01));
    });

    test('Should return correct category for Normal weight', () {
      final category = BmiLogic.getCategoryKey(22.8);
      expect(category, 'normal');
    });

    test('Should return correct category for Underweight', () {
      final category = BmiLogic.getCategoryKey(16.0);
      expect(category, 'underweight');
    });

    test('Should return correct category for Obesity Class III', () {
      final category = BmiLogic.getCategoryKey(45.0);
      expect(category, 'obesity3');
    });

    test('Should return 0 for zero height', () {
      final result = BmiLogic.calculateBmi(70, 0);
      expect(result, 0);
    });
  });
}
