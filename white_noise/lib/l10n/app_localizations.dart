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
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
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
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'White Noise'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @timer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timer;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get minutes;

  /// No description provided for @mix.
  ///
  /// In en, this message translates to:
  /// **'Mix Sounds'**
  String get mix;

  /// No description provided for @mixEmpty.
  ///
  /// In en, this message translates to:
  /// **'Select up to 3 sounds'**
  String get mixEmpty;

  /// No description provided for @mixLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Maximum 3 sounds in mix'**
  String get mixLimitReached;

  /// No description provided for @noTimer.
  ///
  /// In en, this message translates to:
  /// **'No Timer'**
  String get noTimer;

  /// No description provided for @soundRainLight.
  ///
  /// In en, this message translates to:
  /// **'Light Rain'**
  String get soundRainLight;

  /// No description provided for @soundRainHeavy.
  ///
  /// In en, this message translates to:
  /// **'Heavy Rain'**
  String get soundRainHeavy;

  /// No description provided for @soundStorm.
  ///
  /// In en, this message translates to:
  /// **'Thunderstorm'**
  String get soundStorm;

  /// No description provided for @soundRainRoof.
  ///
  /// In en, this message translates to:
  /// **'Rain on Roof'**
  String get soundRainRoof;

  /// No description provided for @soundForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get soundForest;

  /// No description provided for @soundOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean Waves'**
  String get soundOcean;

  /// No description provided for @soundRiver.
  ///
  /// In en, this message translates to:
  /// **'River'**
  String get soundRiver;

  /// No description provided for @soundWaterfall.
  ///
  /// In en, this message translates to:
  /// **'Waterfall'**
  String get soundWaterfall;

  /// No description provided for @soundFireplace.
  ///
  /// In en, this message translates to:
  /// **'Fireplace'**
  String get soundFireplace;

  /// No description provided for @soundCafe.
  ///
  /// In en, this message translates to:
  /// **'Café Ambience'**
  String get soundCafe;

  /// No description provided for @soundWhiteNoise.
  ///
  /// In en, this message translates to:
  /// **'White Noise'**
  String get soundWhiteNoise;

  /// No description provided for @soundPinkNoise.
  ///
  /// In en, this message translates to:
  /// **'Pink Noise'**
  String get soundPinkNoise;

  /// No description provided for @soundBrownNoise.
  ///
  /// In en, this message translates to:
  /// **'Brown Noise'**
  String get soundBrownNoise;

  /// No description provided for @categoryRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get categoryRain;

  /// No description provided for @categoryNature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get categoryNature;

  /// No description provided for @categoryWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get categoryWater;

  /// No description provided for @categoryAmbient.
  ///
  /// In en, this message translates to:
  /// **'Ambient'**
  String get categoryAmbient;

  /// No description provided for @categoryNoise.
  ///
  /// In en, this message translates to:
  /// **'Noise'**
  String get categoryNoise;

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
  /// **'Achievements Progress'**
  String get achievementsProgress;

  /// No description provided for @notUnlockedYet.
  ///
  /// In en, this message translates to:
  /// **'Not unlocked yet'**
  String get notUnlockedYet;

  /// No description provided for @unlockedOn.
  ///
  /// In en, this message translates to:
  /// **'Unlocked on'**
  String get unlockedOn;

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
  /// **'Streaks'**
  String get categoryStreak;

  /// No description provided for @categoryTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get categoryTime;

  /// No description provided for @categorySpecial.
  ///
  /// In en, this message translates to:
  /// **'Special'**
  String get categorySpecial;

  /// No description provided for @achievementFirstSession.
  ///
  /// In en, this message translates to:
  /// **'First Relaxation'**
  String get achievementFirstSession;

  /// No description provided for @achievementFirstSessionDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete your first session'**
  String get achievementFirstSessionDesc;

  /// No description provided for @achievement10Sessions.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get achievement10Sessions;

  /// No description provided for @achievement10SessionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 10 sessions'**
  String get achievement10SessionsDesc;

  /// No description provided for @achievement50Sessions.
  ///
  /// In en, this message translates to:
  /// **'Committed'**
  String get achievement50Sessions;

  /// No description provided for @achievement50SessionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 50 sessions'**
  String get achievement50SessionsDesc;

  /// No description provided for @achievement100Sessions.
  ///
  /// In en, this message translates to:
  /// **'Dedicated'**
  String get achievement100Sessions;

  /// No description provided for @achievement100SessionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 100 sessions'**
  String get achievement100SessionsDesc;

  /// No description provided for @achievement500Sessions.
  ///
  /// In en, this message translates to:
  /// **'Master of Relaxation'**
  String get achievement500Sessions;

  /// No description provided for @achievement500SessionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 500 sessions'**
  String get achievement500SessionsDesc;

  /// No description provided for @achievementStreak3.
  ///
  /// In en, this message translates to:
  /// **'3-Day Streak'**
  String get achievementStreak3;

  /// No description provided for @achievementStreak3Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the app for 3 consecutive days'**
  String get achievementStreak3Desc;

  /// No description provided for @achievementStreak7.
  ///
  /// In en, this message translates to:
  /// **'Week Warrior'**
  String get achievementStreak7;

  /// No description provided for @achievementStreak7Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the app for 7 consecutive days'**
  String get achievementStreak7Desc;

  /// No description provided for @achievementStreak30.
  ///
  /// In en, this message translates to:
  /// **'Monthly Master'**
  String get achievementStreak30;

  /// No description provided for @achievementStreak30Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the app for 30 consecutive days'**
  String get achievementStreak30Desc;

  /// No description provided for @achievement1Hour.
  ///
  /// In en, this message translates to:
  /// **'1 Hour'**
  String get achievement1Hour;

  /// No description provided for @achievement1HourDesc.
  ///
  /// In en, this message translates to:
  /// **'Listen for a total of 1 hour'**
  String get achievement1HourDesc;

  /// No description provided for @achievement10Hours.
  ///
  /// In en, this message translates to:
  /// **'10 Hours'**
  String get achievement10Hours;

  /// No description provided for @achievement10HoursDesc.
  ///
  /// In en, this message translates to:
  /// **'Listen for a total of 10 hours'**
  String get achievement10HoursDesc;

  /// No description provided for @achievement100Hours.
  ///
  /// In en, this message translates to:
  /// **'100 Hours'**
  String get achievement100Hours;

  /// No description provided for @achievement100HoursDesc.
  ///
  /// In en, this message translates to:
  /// **'Listen for a total of 100 hours'**
  String get achievement100HoursDesc;

  /// No description provided for @achievementNightOwl.
  ///
  /// In en, this message translates to:
  /// **'Night Owl'**
  String get achievementNightOwl;

  /// No description provided for @achievementNightOwlDesc.
  ///
  /// In en, this message translates to:
  /// **'Use the app between midnight and 5 AM'**
  String get achievementNightOwlDesc;

  /// No description provided for @achievementFirstMix.
  ///
  /// In en, this message translates to:
  /// **'First Mix'**
  String get achievementFirstMix;

  /// No description provided for @achievementFirstMixDesc.
  ///
  /// In en, this message translates to:
  /// **'Mix two sounds together'**
  String get achievementFirstMixDesc;

  /// No description provided for @achievementMasterMixer.
  ///
  /// In en, this message translates to:
  /// **'Master Mixer'**
  String get achievementMasterMixer;

  /// No description provided for @achievementMasterMixerDesc.
  ///
  /// In en, this message translates to:
  /// **'Mix 3 sounds simultaneously'**
  String get achievementMasterMixerDesc;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'Day Streak'**
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
  /// **'Sessions Progress'**
  String get sessionsProgress;

  /// No description provided for @sessionsPerDay.
  ///
  /// In en, this message translates to:
  /// **'sessions per day'**
  String get sessionsPerDay;

  /// No description provided for @focusTimeToday.
  ///
  /// In en, this message translates to:
  /// **'Listening Time Today'**
  String get focusTimeToday;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @keepScreenOn.
  ///
  /// In en, this message translates to:
  /// **'Keep Screen On'**
  String get keepScreenOn;

  /// No description provided for @keepScreenOnDesc.
  ///
  /// In en, this message translates to:
  /// **'Prevent screen from turning off during playback'**
  String get keepScreenOnDesc;

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

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share App'**
  String get shareApp;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
