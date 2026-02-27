import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../domain/entities/fasting_session.dart';
import '../../domain/entities/fasting_protocol.dart';
import '../../data/repositories/fasting_repository_impl.dart';
import 'shared_prefs_provider.dart';
import 'streak_provider.dart';
import 'achievements_provider.dart';
import '../../services/notification_service.dart';

/// Current fasting session state
class FastingState {
  final FastingSession? currentSession;
  final FastingProtocol selectedProtocol;
  final bool isLoading;
  final String? errorMessage;

  const FastingState({
    this.currentSession,
    this.selectedProtocol = const FastingProtocol(
      id: '16_8',
      nameKey: 'protocol16_8',
      descriptionKey: 'protocol16_8Desc',
      fastingHours: 16,
      eatingHours: 8,
      icon: '🔥',
    ),
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isFasting => currentSession != null;

  FastingState copyWith({
    FastingSession? currentSession,
    FastingProtocol? selectedProtocol,
    bool? isLoading,
    String? errorMessage,
    bool clearSession = false,
  }) {
    return FastingState(
      currentSession: clearSession
          ? null
          : (currentSession ?? this.currentSession),
      selectedProtocol: selectedProtocol ?? this.selectedProtocol,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Fasting state notifier
class FastingNotifier extends StateNotifier<FastingState> {
  final FastingRepositoryImpl _repository;
  final Ref _ref;
  Timer? _updateTimer;

  FastingNotifier(this._repository, this._ref) : super(const FastingState()) {
    _loadCurrentSession();
  }

  Future<void> _loadCurrentSession() async {
    state = state.copyWith(isLoading: true);

    try {
      final session = await _repository.getCurrentSession();
      state = state.copyWith(currentSession: session, isLoading: false);

      if (session != null) {
        _startUpdateTimer();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void _startUpdateTimer() {
    _updateTimer?.cancel();
    _updateTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      // Force UI rebuild by creating new state with same session
      if (state.currentSession != null) {
        state = state.copyWith(
          currentSession: state.currentSession!.copyWith(),
        );
      }
    });
  }

  Future<void> startFasting({
    required String notificationTitle,
    required String notificationBody,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final session = await _repository.startSession(
        protocolId: state.selectedProtocol.id,
        targetHours: state.selectedProtocol.fastingHours,
      );

      state = state.copyWith(currentSession: session, isLoading: false);

      _startUpdateTimer();

      // Schedule notification
      final endTime = session.startTime.add(
        Duration(hours: session.targetHours),
      );
      await _ref
          .read(notificationServiceProvider)
          .scheduleFastingEndNotification(
            endTime,
            title: notificationTitle,
            body: notificationBody,
          );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> endFasting() async {
    final currentSession = state.currentSession;
    if (currentSession == null) return;

    state = state.copyWith(isLoading: true);

    try {
      final completedSession = await _repository.endSession();
      _updateTimer?.cancel();
      await _ref.read(notificationServiceProvider).cancelAll();

      state = state.copyWith(isLoading: false, clearSession: true);

      if (completedSession != null) {
        // Update streak
        await _ref
            .read(streakProvider.notifier)
            .recordCompletedFast(completedSession.elapsedMinutes);

        // Check achievements
        await _ref.read(achievementsProvider.notifier).checkAndUnlock();
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> cancelFasting() async {
    state = state.copyWith(isLoading: true);

    try {
      await _repository.cancelSession();
      await _ref.read(notificationServiceProvider).cancelAll();
      _updateTimer?.cancel();

      state = state.copyWith(isLoading: false, clearSession: true);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void selectProtocol(FastingProtocol protocol) {
    if (state.isFasting) return; // Can't change protocol while fasting
    state = state.copyWith(selectedProtocol: protocol);
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }
}

/// Fasting provider
final fastingProvider = StateNotifierProvider<FastingNotifier, FastingState>((
  ref,
) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return FastingNotifier(FastingRepositoryImpl(prefs), ref);
});

/// History provider
final fastingHistoryProvider = FutureProvider<List<FastingSession>>((
  ref,
) async {
  final prefs = ref.watch(sharedPreferencesProvider);
  final repository = FastingRepositoryImpl(prefs);
  return repository.getHistory(limit: 30);
});
