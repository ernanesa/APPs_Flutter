import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/fasting_session.dart';
import '../../domain/repositories/i_fasting_repository.dart';
import '../models/fasting_session_model.dart';

class FastingRepositoryImpl implements IFastingRepository {
  final SharedPreferences _prefs;

  static const String _currentSessionKey = 'current_fasting_session';
  static const String _historyKey = 'fasting_history';

  FastingRepositoryImpl(this._prefs);

  @override
  Future<FastingSession?> getCurrentSession() async {
    final json = _prefs.getString(_currentSessionKey);
    if (json == null || json.isEmpty) return null;

    try {
      return FastingSessionModel.decodeList('[$json]').first;
    } catch (_) {
      return null;
    }
  }

  @override
  Future<FastingSession> startSession({
    required String protocolId,
    required int targetHours,
  }) async {
    final session = FastingSessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startTime: DateTime.now(),
      protocolId: protocolId,
      targetHours: targetHours,
    );

    await _prefs.setString(_currentSessionKey, session.toJson().toString());
    // Store as proper JSON
    await _prefs.setString(
      _currentSessionKey,
      FastingSessionModel.encodeList([
        session,
      ]).replaceAll('[', '').replaceAll(']', ''),
    );

    return session;
  }

  @override
  Future<FastingSession?> endSession() async {
    final current = await getCurrentSession();
    if (current == null) return null;

    final completedSession = FastingSessionModel(
      id: current.id,
      startTime: current.startTime,
      endTime: DateTime.now(),
      protocolId: current.protocolId,
      isCompleted: true,
      targetHours: current.targetHours,
    );

    // Add to history
    final history = await getHistory(limit: 100);
    final historyModels =
        history.map((s) => FastingSessionModel.fromEntity(s)).toList();
    historyModels.insert(0, completedSession);

    // Keep only last 100 sessions
    if (historyModels.length > 100) {
      historyModels.removeRange(100, historyModels.length);
    }

    await _prefs.setString(
      _historyKey,
      FastingSessionModel.encodeList(historyModels),
    );
    await _prefs.remove(_currentSessionKey);

    return completedSession;
  }

  @override
  Future<void> cancelSession() async {
    await _prefs.remove(_currentSessionKey);
  }

  @override
  Future<List<FastingSession>> getHistory({int limit = 30}) async {
    final json = _prefs.getString(_historyKey);
    if (json == null || json.isEmpty) return [];

    try {
      final sessions = FastingSessionModel.decodeList(json);
      return sessions.take(limit).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> clearHistory() async {
    await _prefs.remove(_historyKey);
  }
}
