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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final timerState = ref.watch(timerProvider);
    final settings = ref.watch(settingsProvider);
    final sessionColor = _getSessionColor(timerState.currentSessionType, theme);

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    // Session type label
                    SessionTypeLabel(
                      sessionType: timerState.currentSessionType,
                      color: sessionColor,
                    ),
                    const SizedBox(height: 32),
                    // Timer display
                    TimerDisplay(
                      remainingSeconds: timerState.remainingSeconds,
                      totalSeconds: timerState.totalSeconds,
                      isFocusSession: timerState.isFocusSession,
                      isRunning: timerState.isRunning,
                      primaryColor: sessionColor,
                    ),
                    const SizedBox(height: 32),
                    // Session indicators
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
                    // Daily goal progress
                    const DailyGoalProgress(compact: false),
                    const SizedBox(height: 40),
                    // Control buttons
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
                    // Motivational quote
                    const MotivationalQuote(showRefreshButton: true),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            // Banner ad at bottom
            const AdBannerWidget(),
          ],
        ),
      ),
    );
  }
}
