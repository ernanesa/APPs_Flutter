import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Pomodoro Timer'**
  String get appTitle;

  /// No description provided for @focusSession.
  ///
  /// In en, this message translates to:
  /// **'Focus Session'**
  String get focusSession;

  /// No description provided for @shortBreak.
  ///
  /// In en, this message translates to:
  /// **'Short Break'**
  String get shortBreak;

  /// No description provided for @longBreak.
  ///
  /// In en, this message translates to:
  /// **'Long Break'**
  String get longBreak;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessions;

  /// No description provided for @sessionsCompleted.
  ///
  /// In en, this message translates to:
  /// **'Sessions Completed'**
  String get sessionsCompleted;

  /// No description provided for @totalFocusTime.
  ///
  /// In en, this message translates to:
  /// **'Total Focus Time'**
  String get totalFocusTime;

  /// No description provided for @todayStats.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Stats'**
  String get todayStats;

  /// No description provided for @weeklyStats.
  ///
  /// In en, this message translates to:
  /// **'Weekly Stats'**
  String get weeklyStats;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @focusDuration.
  ///
  /// In en, this message translates to:
  /// **'Focus Duration'**
  String get focusDuration;

  /// No description provided for @shortBreakDuration.
  ///
  /// In en, this message translates to:
  /// **'Short Break Duration'**
  String get shortBreakDuration;

  /// No description provided for @longBreakDuration.
  ///
  /// In en, this message translates to:
  /// **'Long Break Duration'**
  String get longBreakDuration;

  /// No description provided for @sessionsUntilLongBreak.
  ///
  /// In en, this message translates to:
  /// **'Sessions Until Long Break'**
  String get sessionsUntilLongBreak;

  /// No description provided for @soundEnabled.
  ///
  /// In en, this message translates to:
  /// **'Sound Enabled'**
  String get soundEnabled;

  /// No description provided for @vibrationEnabled.
  ///
  /// In en, this message translates to:
  /// **'Vibration Enabled'**
  String get vibrationEnabled;

  /// No description provided for @autoStartBreaks.
  ///
  /// In en, this message translates to:
  /// **'Auto-start Breaks'**
  String get autoStartBreaks;

  /// No description provided for @autoStartFocus.
  ///
  /// In en, this message translates to:
  /// **'Auto-start Focus'**
  String get autoStartFocus;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get hours;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @timer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// No description provided for @keepFocused.
  ///
  /// In en, this message translates to:
  /// **'Keep Focused!'**
  String get keepFocused;

  /// No description provided for @timeForBreak.
  ///
  /// In en, this message translates to:
  /// **'Time for a Break!'**
  String get timeForBreak;

  /// No description provided for @breakOver.
  ///
  /// In en, this message translates to:
  /// **'Break is Over!'**
  String get breakOver;

  /// No description provided for @greatJob.
  ///
  /// In en, this message translates to:
  /// **'Great Job!'**
  String get greatJob;

  /// No description provided for @sessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Session Complete'**
  String get sessionComplete;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @focusMode.
  ///
  /// In en, this message translates to:
  /// **'Focus Mode'**
  String get focusMode;

  /// No description provided for @breakMode.
  ///
  /// In en, this message translates to:
  /// **'Break Mode'**
  String get breakMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @noSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet. Start your first Pomodoro!'**
  String get noSessionsYet;

  /// No description provided for @pomodoroTechnique.
  ///
  /// In en, this message translates to:
  /// **'The Pomodoro Technique helps you focus by breaking work into intervals, traditionally 25 minutes in length, separated by short breaks.'**
  String get pomodoroTechnique;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @letsGo.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Go!'**
  String get letsGo;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'day streak'**
  String get streakDays;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @bestStreak.
  ///
  /// In en, this message translates to:
  /// **'Best Streak'**
  String get bestStreak;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked!'**
  String get achievementUnlocked;

  /// No description provided for @achievementsProgress.
  ///
  /// In en, this message translates to:
  /// **'{unlocked}/{total} Unlocked'**
  String achievementsProgress(int unlocked, int total);

  /// No description provided for @notUnlockedYet.
  ///
  /// In en, this message translates to:
  /// **'Not unlocked yet'**
  String get notUnlockedYet;

  /// No description provided for @unlockedOn.
  ///
  /// In en, this message translates to:
  /// **'Unlocked on {date}'**
  String unlockedOn(String date);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @categorySession.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get categorySession;

  /// No description provided for @categoryStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get categoryStreak;

  /// No description provided for @categoryTime.
  ///
  /// In en, this message translates to:
  /// **'Focus Time'**
  String get categoryTime;

  /// No description provided for @categorySpecial.
  ///
  /// In en, this message translates to:
  /// **'Special'**
  String get categorySpecial;

  /// No description provided for @achievementFirstSession.
  ///
  /// In en, this message translates to:
  /// **'First Step'**
  String get achievementFirstSession;

  /// No description provided for @achievementFirstSessionDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete your first focus session'**
  String get achievementFirstSessionDesc;

  /// No description provided for @achievementSessions10.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get achievementSessions10;

  /// No description provided for @achievementSessions10Desc.
  ///
  /// In en, this message translates to:
  /// **'Complete 10 focus sessions'**
  String get achievementSessions10Desc;

  /// No description provided for @achievementSessions50.
  ///
  /// In en, this message translates to:
  /// **'Dedicated'**
  String get achievementSessions50;

  /// No description provided for @achievementSessions50Desc.
  ///
  /// In en, this message translates to:
  /// **'Complete 50 focus sessions'**
  String get achievementSessions50Desc;

  /// No description provided for @achievementSessions100.
  ///
  /// In en, this message translates to:
  /// **'Centurion'**
  String get achievementSessions100;

  /// No description provided for @achievementSessions100Desc.
  ///
  /// In en, this message translates to:
  /// **'Complete 100 focus sessions'**
  String get achievementSessions100Desc;

  /// No description provided for @achievementSessions500.
  ///
  /// In en, this message translates to:
  /// **'Grandmaster'**
  String get achievementSessions500;

  /// No description provided for @achievementSessions500Desc.
  ///
  /// In en, this message translates to:
  /// **'Complete 500 focus sessions'**
  String get achievementSessions500Desc;

  /// No description provided for @achievementStreak3.
  ///
  /// In en, this message translates to:
  /// **'Hat Trick'**
  String get achievementStreak3;

  /// No description provided for @achievementStreak3Desc.
  ///
  /// In en, this message translates to:
  /// **'Maintain a 3-day streak'**
  String get achievementStreak3Desc;

  /// No description provided for @achievementStreak7.
  ///
  /// In en, this message translates to:
  /// **'Week Warrior'**
  String get achievementStreak7;

  /// No description provided for @achievementStreak7Desc.
  ///
  /// In en, this message translates to:
  /// **'Maintain a 7-day streak'**
  String get achievementStreak7Desc;

  /// No description provided for @achievementStreak30.
  ///
  /// In en, this message translates to:
  /// **'Monthly Champion'**
  String get achievementStreak30;

  /// No description provided for @achievementStreak30Desc.
  ///
  /// In en, this message translates to:
  /// **'Maintain a 30-day streak'**
  String get achievementStreak30Desc;

  /// No description provided for @achievementTime1h.
  ///
  /// In en, this message translates to:
  /// **'First Hour'**
  String get achievementTime1h;

  /// No description provided for @achievementTime1hDesc.
  ///
  /// In en, this message translates to:
  /// **'Accumulate 1 hour of focus time'**
  String get achievementTime1hDesc;

  /// No description provided for @achievementTime10h.
  ///
  /// In en, this message translates to:
  /// **'Time Investor'**
  String get achievementTime10h;

  /// No description provided for @achievementTime10hDesc.
  ///
  /// In en, this message translates to:
  /// **'Accumulate 10 hours of focus time'**
  String get achievementTime10hDesc;

  /// No description provided for @achievementTime100h.
  ///
  /// In en, this message translates to:
  /// **'Time Master'**
  String get achievementTime100h;

  /// No description provided for @achievementTime100hDesc.
  ///
  /// In en, this message translates to:
  /// **'Accumulate 100 hours of focus time'**
  String get achievementTime100hDesc;

  /// No description provided for @achievementEarlyBird.
  ///
  /// In en, this message translates to:
  /// **'Early Bird'**
  String get achievementEarlyBird;

  /// No description provided for @achievementEarlyBirdDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete a session before 7 AM'**
  String get achievementEarlyBirdDesc;

  /// No description provided for @achievementNightOwl.
  ///
  /// In en, this message translates to:
  /// **'Night Owl'**
  String get achievementNightOwl;

  /// No description provided for @achievementNightOwlDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete a session after 10 PM'**
  String get achievementNightOwlDesc;

  /// No description provided for @achievementWeekendWarrior.
  ///
  /// In en, this message translates to:
  /// **'Weekend Warrior'**
  String get achievementWeekendWarrior;

  /// No description provided for @achievementWeekendWarriorDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 5 sessions on a weekend'**
  String get achievementWeekendWarriorDesc;

  /// No description provided for @ambientSounds.
  ///
  /// In en, this message translates to:
  /// **'Ambient Sounds'**
  String get ambientSounds;

  /// No description provided for @soundSilence.
  ///
  /// In en, this message translates to:
  /// **'Silence'**
  String get soundSilence;

  /// No description provided for @soundRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get soundRain;

  /// No description provided for @soundForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get soundForest;

  /// No description provided for @soundOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get soundOcean;

  /// No description provided for @soundCafe.
  ///
  /// In en, this message translates to:
  /// **'Café'**
  String get soundCafe;

  /// No description provided for @soundFireplace.
  ///
  /// In en, this message translates to:
  /// **'Fireplace'**
  String get soundFireplace;

  /// No description provided for @soundWhiteNoise.
  ///
  /// In en, this message translates to:
  /// **'White Noise'**
  String get soundWhiteNoise;

  /// No description provided for @soundThunder.
  ///
  /// In en, this message translates to:
  /// **'Thunder'**
  String get soundThunder;

  /// No description provided for @colorTheme.
  ///
  /// In en, this message translates to:
  /// **'Color Theme'**
  String get colorTheme;

  /// No description provided for @themeTomato.
  ///
  /// In en, this message translates to:
  /// **'Tomato'**
  String get themeTomato;

  /// No description provided for @themeOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get themeOcean;

  /// No description provided for @themeForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get themeForest;

  /// No description provided for @themeLavender.
  ///
  /// In en, this message translates to:
  /// **'Lavender'**
  String get themeLavender;

  /// No description provided for @themeSunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get themeSunset;

  /// No description provided for @themeMidnight.
  ///
  /// In en, this message translates to:
  /// **'Midnight'**
  String get themeMidnight;

  /// No description provided for @themeRose.
  ///
  /// In en, this message translates to:
  /// **'Rose'**
  String get themeRose;

  /// No description provided for @themeMint.
  ///
  /// In en, this message translates to:
  /// **'Mint'**
  String get themeMint;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// No description provided for @dailyGoalTarget.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal Target'**
  String get dailyGoalTarget;

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'Goal Reached!'**
  String get goalReached;

  /// No description provided for @sessionsProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{target} sessions'**
  String sessionsProgress(int completed, int target);

  /// No description provided for @sessionsPerDay.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions per day'**
  String sessionsPerDay(int count);

  /// No description provided for @focusTimeToday.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min focused today'**
  String focusTimeToday(int minutes);

  /// No description provided for @newQuote.
  ///
  /// In en, this message translates to:
  /// **'New Quote'**
  String get newQuote;

  /// No description provided for @quote1Text.
  ///
  /// In en, this message translates to:
  /// **'The secret of getting ahead is getting started.'**
  String get quote1Text;

  /// No description provided for @quote1Author.
  ///
  /// In en, this message translates to:
  /// **'Mark Twain'**
  String get quote1Author;

  /// No description provided for @quote2Text.
  ///
  /// In en, this message translates to:
  /// **'Focus on being productive instead of busy.'**
  String get quote2Text;

  /// No description provided for @quote2Author.
  ///
  /// In en, this message translates to:
  /// **'Tim Ferriss'**
  String get quote2Author;

  /// No description provided for @quote3Text.
  ///
  /// In en, this message translates to:
  /// **'It\'s not that I\'m so smart, it\'s just that I stay with problems longer.'**
  String get quote3Text;

  /// No description provided for @quote3Author.
  ///
  /// In en, this message translates to:
  /// **'Albert Einstein'**
  String get quote3Author;

  /// No description provided for @quote4Text.
  ///
  /// In en, this message translates to:
  /// **'The way to get started is to quit talking and begin doing.'**
  String get quote4Text;

  /// No description provided for @quote4Author.
  ///
  /// In en, this message translates to:
  /// **'Walt Disney'**
  String get quote4Author;

  /// No description provided for @quote5Text.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have to be great to start, but you have to start to be great.'**
  String get quote5Text;

  /// No description provided for @quote5Author.
  ///
  /// In en, this message translates to:
  /// **'Zig Ziglar'**
  String get quote5Author;

  /// No description provided for @quote6Text.
  ///
  /// In en, this message translates to:
  /// **'Success is the sum of small efforts repeated day in and day out.'**
  String get quote6Text;

  /// No description provided for @quote6Author.
  ///
  /// In en, this message translates to:
  /// **'Robert Collier'**
  String get quote6Author;

  /// No description provided for @quote7Text.
  ///
  /// In en, this message translates to:
  /// **'The only way to do great work is to love what you do.'**
  String get quote7Text;

  /// No description provided for @quote7Author.
  ///
  /// In en, this message translates to:
  /// **'Steve Jobs'**
  String get quote7Author;

  /// No description provided for @quote8Text.
  ///
  /// In en, this message translates to:
  /// **'Concentrate all your thoughts upon the work at hand.'**
  String get quote8Text;

  /// No description provided for @quote8Author.
  ///
  /// In en, this message translates to:
  /// **'Alexander Graham Bell'**
  String get quote8Author;

  /// No description provided for @quote9Text.
  ///
  /// In en, this message translates to:
  /// **'Time is what we want most, but what we use worst.'**
  String get quote9Text;

  /// No description provided for @quote9Author.
  ///
  /// In en, this message translates to:
  /// **'William Penn'**
  String get quote9Author;

  /// No description provided for @quote10Text.
  ///
  /// In en, this message translates to:
  /// **'Action is the foundational key to all success.'**
  String get quote10Text;

  /// No description provided for @quote10Author.
  ///
  /// In en, this message translates to:
  /// **'Pablo Picasso'**
  String get quote10Author;

  /// No description provided for @quote11Text.
  ///
  /// In en, this message translates to:
  /// **'Don\'t watch the clock; do what it does. Keep going.'**
  String get quote11Text;

  /// No description provided for @quote11Author.
  ///
  /// In en, this message translates to:
  /// **'Sam Levenson'**
  String get quote11Author;

  /// No description provided for @quote12Text.
  ///
  /// In en, this message translates to:
  /// **'Your limitation—it\'s only your imagination.'**
  String get quote12Text;

  /// No description provided for @quote12Author.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get quote12Author;

  /// No description provided for @quote13Text.
  ///
  /// In en, this message translates to:
  /// **'Dream it. Wish it. Do it.'**
  String get quote13Text;

  /// No description provided for @quote13Author.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get quote13Author;

  /// No description provided for @quote14Text.
  ///
  /// In en, this message translates to:
  /// **'The harder you work, the luckier you get.'**
  String get quote14Text;

  /// No description provided for @quote14Author.
  ///
  /// In en, this message translates to:
  /// **'Gary Player'**
  String get quote14Author;

  /// No description provided for @quote15Text.
  ///
  /// In en, this message translates to:
  /// **'Do something today that your future self will thank you for.'**
  String get quote15Text;

  /// No description provided for @quote15Author.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get quote15Author;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @colorfulMode.
  ///
  /// In en, this message translates to:
  /// **'Colorful Mode'**
  String get colorfulMode;

  /// No description provided for @colorfulModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Use vibrant colors and animated layout'**
  String get colorfulModeDesc;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'bn', 'de', 'en', 'es', 'fr', 'hi', 'ja', 'pt', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'bn': return AppLocalizationsBn();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'hi': return AppLocalizationsHi();
    case 'ja': return AppLocalizationsJa();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
