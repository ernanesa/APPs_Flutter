import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/app_localizations.dart';
import '../models/pomodoro_session.dart';
import '../providers/settings_provider.dart';
import '../providers/timer_provider.dart';
import '../providers/streak_provider.dart';
import '../providers/daily_goal_provider.dart';
import '../providers/achievements_provider.dart';
import '../providers/ambient_sound_provider.dart';
import '../services/ad_service.dart';
import '../services/sound_service.dart';
import '../widgets/timer_display.dart';
import '../widgets/control_buttons.dart';
import '../widgets/session_indicator.dart';
import '../widgets/session_type_label.dart';
import '../widgets/ad_banner_widget.dart';
import '../widgets/streak_widget.dart';
import '../widgets/daily_goal_progress.dart';
import '../widgets/motivational_quote.dart';
import '../widgets/achievement_badge.dart';
import 'settings_screen.dart';
import 'statistics_screen.dart';
import 'achievements_screen.dart';

/// Main timer screen.
class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen>
    with WidgetsBindingObserver {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    // Set up session complete callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(timerProvider.notifier).onSessionComplete = _onSessionComplete;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      AdService.instance.showAppOpenAdIfAvailable();
    }
  }

  void _onSessionComplete(SessionType type, bool wasCompleted) {
    final settings = ref.read(settingsProvider);
    
    // Play sound and vibrate
    if (settings.soundEnabled) {
      SoundService.instance.playTimerComplete();
    }
    if (settings.vibrationEnabled) {
      SoundService.instance.vibrateOnComplete();
    }
    
    // Update gamification data for focus sessions
    if (type == SessionType.focus && wasCompleted) {
      // Record streak
      ref.read(streakProvider.notifier).recordFocusSessionCompleted();
      
      // Record daily goal progress
      final focusDuration = ref.read(settingsProvider).focusDurationMinutes;
      ref.read(dailyGoalProvider.notifier).recordFocusSessionCompleted(focusDuration);
      
      // Check achievements
      ref.read(timerProvider.notifier).getSessions().then((sessions) {
        ref.read(achievementsProvider.notifier).onSessionCompleted(sessions);
      });
      
      // Stop ambient sound
      ref.read(ambientSoundServiceProvider).stop();
      
      // Show interstitial ad
      AdService.instance.incrementActionAndShowIfNeeded();
    }

    // Show completion snackbar
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            type == SessionType.focus
                ? l10n.sessionComplete
                : l10n.breakOver,
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
      
      // Check for newly unlocked achievement
      final newAchievement = ref.read(newlyUnlockedAchievementProvider);
      if (newAchievement != null) {
        _showAchievementUnlockedDialog(newAchievement);
        ref.read(newlyUnlockedAchievementProvider.notifier).state = null;
      }
    }
  }

  void _showAchievementUnlockedDialog(dynamic achievement) {
    showDialog(
      context: context,
      builder: (context) => AchievementUnlockedDialog(achievement: achievement),
    );
  }

  Color _getSessionColor(SessionType type, ThemeData theme) {
    switch (type) {
      case SessionType.focus:
        return theme.colorScheme.primary;
      case SessionType.shortBreak:
        return theme.colorScheme.secondary;
      case SessionType.longBreak:
        return theme.colorScheme.tertiary;
    }
  }

  // Cores vibrantes para o modo colorido
  Color _getColorfulSessionColor(SessionType type) {
    switch (type) {
      case SessionType.focus:
        return const Color(0xFFE74C3C); // Vermelho tomate vibrante
      case SessionType.shortBreak:
        return const Color(0xFF27AE60); // Verde fresco
      case SessionType.longBreak:
        return const Color(0xFF3498DB); // Azul relaxante
    }
  }

  // Gradientes para o modo colorido
  List<Color> _getColorfulGradient(SessionType type) {
    switch (type) {
      case SessionType.focus:
        return [const Color(0xFFE74C3C), const Color(0xFFC0392B)];
      case SessionType.shortBreak:
        return [const Color(0xFF27AE60), const Color(0xFF1E8449)];
      case SessionType.longBreak:
        return [const Color(0xFF3498DB), const Color(0xFF2980B9)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final timerState = ref.watch(timerProvider);
    final settings = ref.watch(settingsProvider);
    final isColorful = settings.colorfulMode;
    
    final sessionColor = isColorful 
        ? _getColorfulSessionColor(timerState.currentSessionType)
        : _getSessionColor(timerState.currentSessionType, theme);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: const TextStyle(fontSize: 18),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        leadingWidth: 48,
        leading: const StreakBadge(),
        backgroundColor: isColorful ? sessionColor.withOpacity(0.1) : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined, size: 22),
            tooltip: l10n.achievements,
            visualDensity: VisualDensity.compact,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AchievementsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded, size: 22),
            tooltip: l10n.statistics,
            visualDensity: VisualDensity.compact,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StatisticsScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, size: 22),
            tooltip: l10n.settings,
            visualDensity: VisualDensity.compact,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: isColorful 
                  ? _buildColorfulBody(context, timerState, settings, sessionColor, l10n, theme)
                  : _buildMinimalBody(context, timerState, settings, sessionColor, l10n, theme),
            ),
            // Banner ad at bottom
            const AdBannerWidget(),
          ],
        ),
      ),
    );
  }

  // Layout minimalista (atual)
  Widget _buildMinimalBody(
    BuildContext context,
    dynamic timerState,
    dynamic settings,
    Color sessionColor,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          SessionTypeLabel(
            sessionType: timerState.currentSessionType,
            color: sessionColor,
          ),
          const SizedBox(height: 32),
          TimerDisplay(
            remainingSeconds: timerState.remainingSeconds,
            totalSeconds: timerState.totalSeconds,
            isFocusSession: timerState.isFocusSession,
            isRunning: timerState.isRunning,
            primaryColor: sessionColor,
          ),
          const SizedBox(height: 32),
          SessionIndicator(
            completedPomodoros: timerState.completedPomodoros,
            sessionsUntilLongBreak: settings.sessionsUntilLongBreak,
            currentSessionType: timerState.currentSessionType,
          ),
          const SizedBox(height: 8),
          Text(
            '${timerState.completedPomodoros} ${l10n.sessionsCompleted.toLowerCase()}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          const DailyGoalProgress(compact: false),
          const SizedBox(height: 40),
          ControlButtons(
            isRunning: timerState.isRunning,
            isPaused: timerState.isPaused,
            onStart: () {
              SoundService.instance.vibrateOnPress();
              ref.read(timerProvider.notifier).start();
            },
            onPause: () {
              SoundService.instance.vibrateOnPress();
              ref.read(timerProvider.notifier).pause();
            },
            onResume: () {
              SoundService.instance.vibrateOnPress();
              ref.read(timerProvider.notifier).resume();
            },
            onReset: () {
              SoundService.instance.vibrateMedium();
              ref.read(timerProvider.notifier).reset();
            },
            onSkip: () {
              SoundService.instance.vibrateMedium();
              ref.read(timerProvider.notifier).skip();
            },
            primaryColor: sessionColor,
          ),
          const SizedBox(height: 40),
          const MotivationalQuote(showRefreshButton: true),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // Layout colorido (novo - estilo BMI Calculator)
  Widget _buildColorfulBody(
    BuildContext context,
    dynamic timerState,
    dynamic settings,
    Color sessionColor,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    final gradientColors = _getColorfulGradient(timerState.currentSessionType);
    
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Card do timer principal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: sessionColor.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Session type com chip colorido
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: sessionColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: sessionColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          timerState.currentSessionType == SessionType.focus 
                              ? Icons.psychology 
                              : Icons.coffee,
                          color: sessionColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getSessionTypeName(timerState.currentSessionType, l10n),
                          style: TextStyle(
                            color: sessionColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Timer display
                  TimerDisplay(
                    remainingSeconds: timerState.remainingSeconds,
                    totalSeconds: timerState.totalSeconds,
                    isFocusSession: timerState.isFocusSession,
                    isRunning: timerState.isRunning,
                    primaryColor: sessionColor,
                  ),
                  const SizedBox(height: 20),
                  // Session indicators
                  SessionIndicator(
                    completedPomodoros: timerState.completedPomodoros,
                    sessionsUntilLongBreak: settings.sessionsUntilLongBreak,
                    currentSessionType: timerState.currentSessionType,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Card do progresso diário
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const DailyGoalProgress(compact: false),
            ),
          ),
          const SizedBox(height: 24),
          // Botões de controle com gradiente
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildColorfulControlButtons(timerState, sessionColor, gradientColors),
          ),
          const SizedBox(height: 24),
          // Card de resultado/status
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: sessionColor.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    l10n.todayStats,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${timerState.completedPomodoros}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      l10n.sessionsCompleted,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Quote
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: MotivationalQuote(showRefreshButton: true),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildColorfulControlButtons(dynamic timerState, Color sessionColor, List<Color> gradientColors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Reset button
        _buildCircularButton(
          icon: Icons.refresh,
          color: Colors.grey,
          onTap: () {
            SoundService.instance.vibrateMedium();
            ref.read(timerProvider.notifier).reset();
          },
        ),
        const SizedBox(width: 16),
        // Main play/pause button with gradient
        GestureDetector(
          onTap: () {
            SoundService.instance.vibrateOnPress();
            if (!timerState.isRunning) {
              ref.read(timerProvider.notifier).start();
            } else if (timerState.isPaused) {
              ref.read(timerProvider.notifier).resume();
            } else {
              ref.read(timerProvider.notifier).pause();
            }
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradientColors),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: sessionColor.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              timerState.isRunning && !timerState.isPaused
                  ? Icons.pause
                  : Icons.play_arrow,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Skip button
        _buildCircularButton(
          icon: Icons.skip_next,
          color: Colors.grey,
          onTap: () {
            SoundService.instance.vibrateMedium();
            ref.read(timerProvider.notifier).skip();
          },
        ),
      ],
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }

  String _getSessionTypeName(SessionType type, AppLocalizations l10n) {
    switch (type) {
      case SessionType.focus:
        return l10n.focusSession;
      case SessionType.shortBreak:
        return l10n.shortBreak;
      case SessionType.longBreak:
        return l10n.longBreak;
    }
  }
