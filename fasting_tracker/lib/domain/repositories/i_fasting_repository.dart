import '../entities/fasting_session.dart';

/// Repository interface for fasting sessions
abstract class IFastingRepository {
  /// Get current active fasting session (if any)
  Future<FastingSession?> getCurrentSession();
  
  /// Start a new fasting session
  Future<FastingSession> startSession({
    required String protocolId,
    required int targetHours,
  });
  
  /// End the current fasting session
  Future<FastingSession?> endSession();
  
  /// Cancel the current fasting session without completing
  Future<void> cancelSession();
  
  /// Get fasting history
  Future<List<FastingSession>> getHistory({int limit = 30});
  
  /// Clear all history
  Future<void> clearHistory();
}
