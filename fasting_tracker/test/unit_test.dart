import 'package:flutter_test/flutter_test.dart';
import 'package:fasting_tracker/domain/entities/fasting_session.dart';

void main() {
  group('FastingSession Logic Unit Tests', () {
    test('Calculates elapsed hours correctly', () {
      // Arrange
      final now = DateTime.now();
      final start = now.subtract(const Duration(hours: 4));
      
      // Act
      final session = FastingSession(
        id: 'test_1',
        startTime: start,
        protocolId: '16:8',
        targetHours: 16,
      );

      // Assert
      expect(session.elapsedHours, closeTo(4.0, 0.05));
      expect(session.progress, closeTo(0.25, 0.01)); // 4/16 = 0.25
    });

    test('Goal Achieved logic works', () {
      // Arrange
      final now = DateTime.now();
      final startNotAchieved = now.subtract(const Duration(hours: 15));
      final startAchieved = now.subtract(const Duration(hours: 16));

      // Act
      final sessionNotAchieved = FastingSession(
        id: '1',
        startTime: startNotAchieved,
        protocolId: '16:8',
        targetHours: 16,
      );
      
      final sessionAchieved = FastingSession(
        id: '2',
        startTime: startAchieved,
        protocolId: '16:8',
        targetHours: 16,
      );

      // Assert
      expect(sessionNotAchieved.goalAchieved, false);
      expect(sessionAchieved.goalAchieved, true);
    });

    test('Metabolic Stages transition correctly', () {
      // 0-4h: Fed
      expect(FastingStage.fromHours(3.9), FastingStage.fed);
      // 4-12h: Early Fasting
      expect(FastingStage.fromHours(4.1), FastingStage.earlyFasting);
      // 12-18h: Fat Burning
      expect(FastingStage.fromHours(12.1), FastingStage.fatBurning);
      // 18-24h: Ketosis
      expect(FastingStage.fromHours(18.1), FastingStage.ketosis);
      // 24-48h: Deep Ketosis
      expect(FastingStage.fromHours(24.1), FastingStage.deepKetosis);
      // >48h: Autophagy
      expect(FastingStage.fromHours(48.1), FastingStage.autophagy);
    });

    test('Progress in stage calculation', () {
      // Stage Fat Burning: 12h to 18h (Duration 6h)
      // Current: 15h (Middle) -> Expected 0.5
      final stage = FastingStage.fatBurning;
      expect(stage.progressInStage(15), closeTo(0.5, 0.01));
      
      // Start of stage
      expect(stage.progressInStage(12), closeTo(0.0, 0.01));
      
      // End of stage
      expect(stage.progressInStage(18), closeTo(1.0, 0.01));
    });
  });
}
