import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pomodoro Timer';

  @override
  String get focusSession => 'Focus Session';

  @override
  String get shortBreak => 'Short Break';

  @override
  String get longBreak => 'Long Break';

  @override
  String get start => 'Start';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Resume';

  @override
  String get reset => 'Reset';

  @override
  String get skip => 'Skip';

  @override
  String get sessions => 'Sessions';

  @override
  String get sessionsCompleted => 'Sessions Completed';

  @override
  String get totalFocusTime => 'Total Focus Time';

  @override
  String get todayStats => 'Today\'s Stats';

  @override
  String get weeklyStats => 'Weekly Stats';

  @override
  String get settings => 'Settings';

  @override
  String get focusDuration => 'Focus Duration';

  @override
  String get shortBreakDuration => 'Short Break Duration';

  @override
  String get longBreakDuration => 'Long Break Duration';

  @override
  String get sessionsUntilLongBreak => 'Sessions Until Long Break';

  @override
  String get soundEnabled => 'Sound Enabled';

  @override
  String get vibrationEnabled => 'Vibration Enabled';

  @override
  String get autoStartBreaks => 'Auto-start Breaks';

  @override
  String get autoStartFocus => 'Auto-start Focus';

  @override
  String get notifications => 'Notifications';

  @override
  String get minutes => 'minutes';

  @override
  String get min => 'min';

  @override
  String get hours => 'hours';

  @override
  String get history => 'History';

  @override
  String get statistics => 'Statistics';

  @override
  String get timer => 'Timer';

  @override
  String get keepFocused => 'Keep Focused!';

  @override
  String get timeForBreak => 'Time for a Break!';

  @override
  String get breakOver => 'Break is Over!';

  @override
  String get greatJob => 'Great Job!';

  @override
  String get sessionComplete => 'Session Complete';

  @override
  String get ready => 'Ready';

  @override
  String get focusMode => 'Focus Mode';

  @override
  String get breakMode => 'Break Mode';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get rateApp => 'Rate App';

  @override
  String get noSessionsYet => 'No sessions yet. Start your first Pomodoro!';

  @override
  String get pomodoroTechnique => 'The Pomodoro Technique helps you focus by breaking work into intervals, traditionally 25 minutes in length, separated by short breaks.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get letsGo => 'Let\'s Go!';

  @override
  String get streakDays => 'day streak';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get bestStreak => 'Best Streak';

  @override
  String get days => 'days';

  @override
  String get achievements => 'Achievements';

  @override
  String get achievementUnlocked => 'Achievement Unlocked!';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked/$total Unlocked';
  }

  @override
  String get notUnlockedYet => 'Not unlocked yet';

  @override
  String unlockedOn(String date) {
    return 'Unlocked on $date';
  }

  @override
  String get close => 'Close';

  @override
  String get categorySession => 'Sessions';

  @override
  String get categoryStreak => 'Streak';

  @override
  String get categoryTime => 'Focus Time';

  @override
  String get categorySpecial => 'Special';

  @override
  String get achievementFirstSession => 'First Step';

  @override
  String get achievementFirstSessionDesc => 'Complete your first focus session';

  @override
  String get achievementSessions10 => 'Getting Started';

  @override
  String get achievementSessions10Desc => 'Complete 10 focus sessions';

  @override
  String get achievementSessions50 => 'Dedicated';

  @override
  String get achievementSessions50Desc => 'Complete 50 focus sessions';

  @override
  String get achievementSessions100 => 'Centurion';

  @override
  String get achievementSessions100Desc => 'Complete 100 focus sessions';

  @override
  String get achievementSessions500 => 'Grandmaster';

  @override
  String get achievementSessions500Desc => 'Complete 500 focus sessions';

  @override
  String get achievementStreak3 => 'Hat Trick';

  @override
  String get achievementStreak3Desc => 'Maintain a 3-day streak';

  @override
  String get achievementStreak7 => 'Week Warrior';

  @override
  String get achievementStreak7Desc => 'Maintain a 7-day streak';

  @override
  String get achievementStreak30 => 'Monthly Champion';

  @override
  String get achievementStreak30Desc => 'Maintain a 30-day streak';

  @override
  String get achievementTime1h => 'First Hour';

  @override
  String get achievementTime1hDesc => 'Accumulate 1 hour of focus time';

  @override
  String get achievementTime10h => 'Time Investor';

  @override
  String get achievementTime10hDesc => 'Accumulate 10 hours of focus time';

  @override
  String get achievementTime100h => 'Time Master';

  @override
  String get achievementTime100hDesc => 'Accumulate 100 hours of focus time';

  @override
  String get achievementEarlyBird => 'Early Bird';

  @override
  String get achievementEarlyBirdDesc => 'Complete a session before 7 AM';

  @override
  String get achievementNightOwl => 'Night Owl';

  @override
  String get achievementNightOwlDesc => 'Complete a session after 10 PM';

  @override
  String get achievementWeekendWarrior => 'Weekend Warrior';

  @override
  String get achievementWeekendWarriorDesc => 'Complete 5 sessions on a weekend';

  @override
  String get ambientSounds => 'Ambient Sounds';

  @override
  String get soundSilence => 'Silence';

  @override
  String get soundRain => 'Rain';

  @override
  String get soundForest => 'Forest';

  @override
  String get soundOcean => 'Ocean';

  @override
  String get soundCafe => 'Café';

  @override
  String get soundFireplace => 'Fireplace';

  @override
  String get soundWhiteNoise => 'White Noise';

  @override
  String get soundThunder => 'Thunder';

  @override
  String get colorTheme => 'Color Theme';

  @override
  String get themeTomato => 'Tomato';

  @override
  String get themeOcean => 'Ocean';

  @override
  String get themeForest => 'Forest';

  @override
  String get themeLavender => 'Lavender';

  @override
  String get themeSunset => 'Sunset';

  @override
  String get themeMidnight => 'Midnight';

  @override
  String get themeRose => 'Rose';

  @override
  String get themeMint => 'Mint';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String get dailyGoalTarget => 'Daily Goal Target';

  @override
  String get goalReached => 'Goal Reached!';

  @override
  String sessionsProgress(int completed, int target) {
    return '$completed/$target sessions';
  }

  @override
  String sessionsPerDay(int count) {
    return '$count sessions per day';
  }

  @override
  String focusTimeToday(int minutes) {
    return '$minutes min focused today';
  }

  @override
  String get newQuote => 'New Quote';

  @override
  String get quote1Text => 'The secret of getting ahead is getting started.';

  @override
  String get quote1Author => 'Mark Twain';

  @override
  String get quote2Text => 'Focus on being productive instead of busy.';

  @override
  String get quote2Author => 'Tim Ferriss';

  @override
  String get quote3Text => 'It\'s not that I\'m so smart, it\'s just that I stay with problems longer.';

  @override
  String get quote3Author => 'Albert Einstein';

  @override
  String get quote4Text => 'The way to get started is to quit talking and begin doing.';

  @override
  String get quote4Author => 'Walt Disney';

  @override
  String get quote5Text => 'You don\'t have to be great to start, but you have to start to be great.';

  @override
  String get quote5Author => 'Zig Ziglar';

  @override
  String get quote6Text => 'Success is the sum of small efforts repeated day in and day out.';

  @override
  String get quote6Author => 'Robert Collier';

  @override
  String get quote7Text => 'The only way to do great work is to love what you do.';

  @override
  String get quote7Author => 'Steve Jobs';

  @override
  String get quote8Text => 'Concentrate all your thoughts upon the work at hand.';

  @override
  String get quote8Author => 'Alexander Graham Bell';

  @override
  String get quote9Text => 'Time is what we want most, but what we use worst.';

  @override
  String get quote9Author => 'William Penn';

  @override
  String get quote10Text => 'Action is the foundational key to all success.';

  @override
  String get quote10Author => 'Pablo Picasso';

  @override
  String get quote11Text => 'Don\'t watch the clock; do what it does. Keep going.';

  @override
  String get quote11Author => 'Sam Levenson';

  @override
  String get quote12Text => 'Your limitation—it\'s only your imagination.';

  @override
  String get quote12Author => 'Unknown';

  @override
  String get quote13Text => 'Dream it. Wish it. Do it.';

  @override
  String get quote13Author => 'Unknown';

  @override
  String get quote14Text => 'The harder you work, the luckier you get.';

  @override
  String get quote14Author => 'Gary Player';

  @override
  String get quote15Text => 'Do something today that your future self will thank you for.';

  @override
  String get quote15Author => 'Unknown';
}
