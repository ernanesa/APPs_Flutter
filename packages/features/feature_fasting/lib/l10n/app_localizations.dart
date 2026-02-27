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
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Fasting Tracker'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @ofPreposition.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofPreposition;

  /// No description provided for @readyToFast.
  ///
  /// In en, this message translates to:
  /// **'Ready to Fast'**
  String get readyToFast;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @endEarly.
  ///
  /// In en, this message translates to:
  /// **'End Early'**
  String get endEarly;

  /// No description provided for @cancelFastingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this fasting session? Progress will be lost.'**
  String get cancelFastingConfirm;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No fasting history yet'**
  String get noHistory;

  /// No description provided for @totalHours.
  ///
  /// In en, this message translates to:
  /// **'Total Hours'**
  String get totalHours;

  /// No description provided for @openSource.
  ///
  /// In en, this message translates to:
  /// **'Open Source'**
  String get openSource;

  /// No description provided for @openSourceDesc.
  ///
  /// In en, this message translates to:
  /// **'Built with Flutter'**
  String get openSourceDesc;

  /// No description provided for @startFasting.
  ///
  /// In en, this message translates to:
  /// **'Start Fasting'**
  String get startFasting;

  /// No description provided for @endFasting.
  ///
  /// In en, this message translates to:
  /// **'End Fasting'**
  String get endFasting;

  /// No description provided for @cancelFasting.
  ///
  /// In en, this message translates to:
  /// **'Cancel Fasting'**
  String get cancelFasting;

  /// No description provided for @fastingInProgress.
  ///
  /// In en, this message translates to:
  /// **'Fasting in Progress'**
  String get fastingInProgress;

  /// No description provided for @fastingCompleted.
  ///
  /// In en, this message translates to:
  /// **'Fasting Completed!'**
  String get fastingCompleted;

  /// No description provided for @timeRemaining.
  ///
  /// In en, this message translates to:
  /// **'Time Remaining'**
  String get timeRemaining;

  /// No description provided for @timeElapsed.
  ///
  /// In en, this message translates to:
  /// **'Time Elapsed'**
  String get timeElapsed;

  /// No description provided for @targetReached.
  ///
  /// In en, this message translates to:
  /// **'Target Reached!'**
  String get targetReached;

  /// No description provided for @selectProtocol.
  ///
  /// In en, this message translates to:
  /// **'Select Protocol'**
  String get selectProtocol;

  /// No description provided for @protocol12_12.
  ///
  /// In en, this message translates to:
  /// **'12:12'**
  String get protocol12_12;

  /// No description provided for @protocol12_12Desc.
  ///
  /// In en, this message translates to:
  /// **'12h fasting, 12h eating'**
  String get protocol12_12Desc;

  /// No description provided for @protocol14_10.
  ///
  /// In en, this message translates to:
  /// **'14:10'**
  String get protocol14_10;

  /// No description provided for @protocol14_10Desc.
  ///
  /// In en, this message translates to:
  /// **'14h fasting, 10h eating'**
  String get protocol14_10Desc;

  /// No description provided for @protocol16_8.
  ///
  /// In en, this message translates to:
  /// **'16:8'**
  String get protocol16_8;

  /// No description provided for @protocol16_8Desc.
  ///
  /// In en, this message translates to:
  /// **'16h fasting, 8h eating (Popular)'**
  String get protocol16_8Desc;

  /// No description provided for @protocol18_6.
  ///
  /// In en, this message translates to:
  /// **'18:6'**
  String get protocol18_6;

  /// No description provided for @protocol18_6Desc.
  ///
  /// In en, this message translates to:
  /// **'18h fasting, 6h eating'**
  String get protocol18_6Desc;

  /// No description provided for @protocol20_4.
  ///
  /// In en, this message translates to:
  /// **'20:4'**
  String get protocol20_4;

  /// No description provided for @protocol20_4Desc.
  ///
  /// In en, this message translates to:
  /// **'20h fasting, 4h eating (Warrior)'**
  String get protocol20_4Desc;

  /// No description provided for @protocol23_1.
  ///
  /// In en, this message translates to:
  /// **'23:1'**
  String get protocol23_1;

  /// No description provided for @protocol23_1Desc.
  ///
  /// In en, this message translates to:
  /// **'23h fasting, 1h eating (OMAD)'**
  String get protocol23_1Desc;

  /// No description provided for @metabolicStages.
  ///
  /// In en, this message translates to:
  /// **'Metabolic Stages'**
  String get metabolicStages;

  /// No description provided for @stageFed.
  ///
  /// In en, this message translates to:
  /// **'Fed State'**
  String get stageFed;

  /// No description provided for @stageFedDesc.
  ///
  /// In en, this message translates to:
  /// **'Body digesting food, insulin elevated'**
  String get stageFedDesc;

  /// No description provided for @stageEarlyFasting.
  ///
  /// In en, this message translates to:
  /// **'Early Fasting'**
  String get stageEarlyFasting;

  /// No description provided for @stageEarlyFastingDesc.
  ///
  /// In en, this message translates to:
  /// **'Blood sugar stabilizing, using glycogen'**
  String get stageEarlyFastingDesc;

  /// No description provided for @stageFatBurning.
  ///
  /// In en, this message translates to:
  /// **'Fat Burning'**
  String get stageFatBurning;

  /// No description provided for @stageFatBurningDesc.
  ///
  /// In en, this message translates to:
  /// **'Body switching to fat for energy'**
  String get stageFatBurningDesc;

  /// No description provided for @stageKetosis.
  ///
  /// In en, this message translates to:
  /// **'Ketosis'**
  String get stageKetosis;

  /// No description provided for @stageKetosisDesc.
  ///
  /// In en, this message translates to:
  /// **'Producing ketones, enhanced mental clarity'**
  String get stageKetosisDesc;

  /// No description provided for @stageDeepKetosis.
  ///
  /// In en, this message translates to:
  /// **'Deep Ketosis'**
  String get stageDeepKetosis;

  /// No description provided for @stageDeepKetosisDesc.
  ///
  /// In en, this message translates to:
  /// **'Maximum fat burning, growth hormone boost'**
  String get stageDeepKetosisDesc;

  /// No description provided for @stageAutophagy.
  ///
  /// In en, this message translates to:
  /// **'Autophagy'**
  String get stageAutophagy;

  /// No description provided for @stageAutophagyDesc.
  ///
  /// In en, this message translates to:
  /// **'Cellular cleanup and regeneration'**
  String get stageAutophagyDesc;

  /// No description provided for @currentStage.
  ///
  /// In en, this message translates to:
  /// **'Current Stage'**
  String get currentStage;

  /// No description provided for @stageStartsAt.
  ///
  /// In en, this message translates to:
  /// **'Starts at {hours}h'**
  String stageStartsAt(int hours);

  /// No description provided for @healthInfo.
  ///
  /// In en, this message translates to:
  /// **'Health Information'**
  String get healthInfo;

  /// No description provided for @benefits.
  ///
  /// In en, this message translates to:
  /// **'Benefits'**
  String get benefits;

  /// No description provided for @warnings.
  ///
  /// In en, this message translates to:
  /// **'Warnings & Precautions'**
  String get warnings;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips for Success'**
  String get tips;

  /// No description provided for @benefitWeightLoss.
  ///
  /// In en, this message translates to:
  /// **'Promotes weight loss and fat burning'**
  String get benefitWeightLoss;

  /// No description provided for @benefitInsulin.
  ///
  /// In en, this message translates to:
  /// **'Improves insulin sensitivity'**
  String get benefitInsulin;

  /// No description provided for @benefitBrain.
  ///
  /// In en, this message translates to:
  /// **'Enhances brain function and mental clarity'**
  String get benefitBrain;

  /// No description provided for @benefitHeart.
  ///
  /// In en, this message translates to:
  /// **'Supports cardiovascular health'**
  String get benefitHeart;

  /// No description provided for @benefitCellRepair.
  ///
  /// In en, this message translates to:
  /// **'Triggers cellular repair (autophagy)'**
  String get benefitCellRepair;

  /// No description provided for @benefitInflammation.
  ///
  /// In en, this message translates to:
  /// **'Reduces inflammation'**
  String get benefitInflammation;

  /// No description provided for @benefitLongevity.
  ///
  /// In en, this message translates to:
  /// **'May promote longevity'**
  String get benefitLongevity;

  /// No description provided for @benefitMetabolism.
  ///
  /// In en, this message translates to:
  /// **'Boosts metabolic health'**
  String get benefitMetabolism;

  /// No description provided for @warningPregnant.
  ///
  /// In en, this message translates to:
  /// **'Not recommended during pregnancy or breastfeeding'**
  String get warningPregnant;

  /// No description provided for @warningDiabetes.
  ///
  /// In en, this message translates to:
  /// **'Consult doctor if you have diabetes'**
  String get warningDiabetes;

  /// No description provided for @warningMedication.
  ///
  /// In en, this message translates to:
  /// **'Check with doctor if taking medications'**
  String get warningMedication;

  /// No description provided for @warningEatingDisorder.
  ///
  /// In en, this message translates to:
  /// **'Avoid if history of eating disorders'**
  String get warningEatingDisorder;

  /// No description provided for @warningChildren.
  ///
  /// In en, this message translates to:
  /// **'Not suitable for children or adolescents'**
  String get warningChildren;

  /// No description provided for @warningUnderweight.
  ///
  /// In en, this message translates to:
  /// **'Not recommended if underweight'**
  String get warningUnderweight;

  /// No description provided for @warningMedical.
  ///
  /// In en, this message translates to:
  /// **'Consult healthcare provider before starting'**
  String get warningMedical;

  /// No description provided for @tipHydration.
  ///
  /// In en, this message translates to:
  /// **'Stay well hydrated during fasting periods'**
  String get tipHydration;

  /// No description provided for @tipGradual.
  ///
  /// In en, this message translates to:
  /// **'Start with shorter fasting periods'**
  String get tipGradual;

  /// No description provided for @tipNutrition.
  ///
  /// In en, this message translates to:
  /// **'Focus on nutritious foods during eating window'**
  String get tipNutrition;

  /// No description provided for @tipListenBody.
  ///
  /// In en, this message translates to:
  /// **'Listen to your body and adjust as needed'**
  String get tipListenBody;

  /// No description provided for @sourceInfo.
  ///
  /// In en, this message translates to:
  /// **'Information based on research from Johns Hopkins Medicine and Harvard Health'**
  String get sourceInfo;

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

  /// No description provided for @totalFasts.
  ///
  /// In en, this message translates to:
  /// **'Total Fasts'**
  String get totalFasts;

  /// No description provided for @daysUnit.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get daysUnit;

  /// No description provided for @dayUnit.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get dayUnit;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{day} other{days}}'**
  String streakDays(int count);

  /// No description provided for @achievementsProgress.
  ///
  /// In en, this message translates to:
  /// **'{unlocked} of {total} unlocked'**
  String achievementsProgress(int unlocked, int total);

  /// No description provided for @achievementUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked!'**
  String get achievementUnlocked;

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

  /// No description provided for @achievementFirstFast.
  ///
  /// In en, this message translates to:
  /// **'First Fast'**
  String get achievementFirstFast;

  /// No description provided for @achievementFirstFastDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete your first fasting session'**
  String get achievementFirstFastDesc;

  /// No description provided for @achievement10Fasts.
  ///
  /// In en, this message translates to:
  /// **'Dedicated Faster'**
  String get achievement10Fasts;

  /// No description provided for @achievement10FastsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 10 fasting sessions'**
  String get achievement10FastsDesc;

  /// No description provided for @achievement50Fasts.
  ///
  /// In en, this message translates to:
  /// **'Fasting Pro'**
  String get achievement50Fasts;

  /// No description provided for @achievement50FastsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 50 fasting sessions'**
  String get achievement50FastsDesc;

  /// No description provided for @achievement100Fasts.
  ///
  /// In en, this message translates to:
  /// **'Fasting Master'**
  String get achievement100Fasts;

  /// No description provided for @achievement100FastsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 100 fasting sessions'**
  String get achievement100FastsDesc;

  /// No description provided for @achievementStreak3.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
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

  /// No description provided for @achievement24Hours.
  ///
  /// In en, this message translates to:
  /// **'Full Day Fast'**
  String get achievement24Hours;

  /// No description provided for @achievement24HoursDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete a 24-hour fast'**
  String get achievement24HoursDesc;

  /// No description provided for @achievement25Fasts.
  ///
  /// In en, this message translates to:
  /// **'Fasting Enthusiast'**
  String get achievement25Fasts;

  /// No description provided for @achievement25FastsDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 25 fasting sessions'**
  String get achievement25FastsDesc;

  /// No description provided for @achievement100Hours.
  ///
  /// In en, this message translates to:
  /// **'Century Club'**
  String get achievement100Hours;

  /// No description provided for @achievement100HoursDesc.
  ///
  /// In en, this message translates to:
  /// **'Accumulate 100 hours of fasting'**
  String get achievement100HoursDesc;

  /// No description provided for @achievement500Hours.
  ///
  /// In en, this message translates to:
  /// **'500 Hour Hero'**
  String get achievement500Hours;

  /// No description provided for @achievement500HoursDesc.
  ///
  /// In en, this message translates to:
  /// **'Accumulate 500 hours of fasting'**
  String get achievement500HoursDesc;

  /// No description provided for @achievementStreak14.
  ///
  /// In en, this message translates to:
  /// **'Two Week Champion'**
  String get achievementStreak14;

  /// No description provided for @achievementStreak14Desc.
  ///
  /// In en, this message translates to:
  /// **'Maintain a 14-day streak'**
  String get achievementStreak14Desc;

  /// No description provided for @achievementKetosis.
  ///
  /// In en, this message translates to:
  /// **'Ketosis Achiever'**
  String get achievementKetosis;

  /// No description provided for @achievementKetosisDesc.
  ///
  /// In en, this message translates to:
  /// **'Reach the ketosis stage (18+ hours)'**
  String get achievementKetosisDesc;

  /// No description provided for @achievementAutophagy.
  ///
  /// In en, this message translates to:
  /// **'Autophagy Achiever'**
  String get achievementAutophagy;

  /// No description provided for @achievementAutophagyDesc.
  ///
  /// In en, this message translates to:
  /// **'Reach the autophagy stage (48+ hours)'**
  String get achievementAutophagyDesc;

  /// No description provided for @achievementEarlyBird.
  ///
  /// In en, this message translates to:
  /// **'Early Bird'**
  String get achievementEarlyBird;

  /// No description provided for @achievementEarlyBirdDesc.
  ///
  /// In en, this message translates to:
  /// **'Start a fast before 8 AM'**
  String get achievementEarlyBirdDesc;

  /// No description provided for @achievementNightOwl.
  ///
  /// In en, this message translates to:
  /// **'Night Owl'**
  String get achievementNightOwl;

  /// No description provided for @achievementNightOwlDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete a fast after 10 PM'**
  String get achievementNightOwlDesc;

  /// No description provided for @achievementWeekend.
  ///
  /// In en, this message translates to:
  /// **'Weekend Warrior'**
  String get achievementWeekend;

  /// No description provided for @achievementWeekendDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete a fast on weekend'**
  String get achievementWeekendDesc;

  /// No description provided for @achievementPerfectWeek.
  ///
  /// In en, this message translates to:
  /// **'Perfect Week'**
  String get achievementPerfectWeek;

  /// No description provided for @achievementPerfectWeekDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete 7 fasts in a week'**
  String get achievementPerfectWeekDesc;

  /// No description provided for @colorTheme.
  ///
  /// In en, this message translates to:
  /// **'Color Theme'**
  String get colorTheme;

  /// No description provided for @themeForest.
  ///
  /// In en, this message translates to:
  /// **'Forest'**
  String get themeForest;

  /// No description provided for @themeOcean.
  ///
  /// In en, this message translates to:
  /// **'Ocean'**
  String get themeOcean;

  /// No description provided for @themeSunset.
  ///
  /// In en, this message translates to:
  /// **'Sunset'**
  String get themeSunset;

  /// No description provided for @themeLavender.
  ///
  /// In en, this message translates to:
  /// **'Lavender'**
  String get themeLavender;

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

  /// No description provided for @themeAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get themeAmber;

  /// No description provided for @noFastingHistory.
  ///
  /// In en, this message translates to:
  /// **'No fasting history yet'**
  String get noFastingHistory;

  /// No description provided for @startFirstFast.
  ///
  /// In en, this message translates to:
  /// **'Start your first fast to see your progress'**
  String get startFirstFast;

  /// No description provided for @fastingHistory.
  ///
  /// In en, this message translates to:
  /// **'Fasting History'**
  String get fastingHistory;

  /// No description provided for @totalFastingTime.
  ///
  /// In en, this message translates to:
  /// **'Total Fasting Time'**
  String get totalFastingTime;

  /// No description provided for @averageFastDuration.
  ///
  /// In en, this message translates to:
  /// **'Average Duration'**
  String get averageFastDuration;

  /// No description provided for @longestFast.
  ///
  /// In en, this message translates to:
  /// **'Longest Fast'**
  String get longestFast;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'{count}h'**
  String hours(int count);

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'{count}m'**
  String minutes(int count);

  /// No description provided for @hoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String hoursMinutes(int hours, int minutes);

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageDefault.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get languageDefault;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enableReminders.
  ///
  /// In en, this message translates to:
  /// **'Enable Reminders'**
  String get enableReminders;

  /// No description provided for @reminderTime.
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTime;

  /// No description provided for @notificationGoalReachedTitle.
  ///
  /// In en, this message translates to:
  /// **'Target Reached! 🎉'**
  String get notificationGoalReachedTitle;

  /// No description provided for @notificationGoalReachedBody.
  ///
  /// In en, this message translates to:
  /// **'You have successfully reached your fasting goal!'**
  String get notificationGoalReachedBody;

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

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

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

  /// No description provided for @healthInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Intermittent Fasting'**
  String get healthInfoTitle;

  /// No description provided for @healthInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Science-based information'**
  String get healthInfoSubtitle;

  /// No description provided for @benefitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Health Benefits'**
  String get benefitsTitle;

  /// No description provided for @warningsTitle.
  ///
  /// In en, this message translates to:
  /// **'Warnings & Precautions'**
  String get warningsTitle;

  /// No description provided for @tipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Tips for Success'**
  String get tipsTitle;

  /// No description provided for @sources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get sources;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'This app is for informational purposes only. Always consult a healthcare provider before starting any fasting regimen.'**
  String get disclaimer;

  /// No description provided for @benefitWeightTitle.
  ///
  /// In en, this message translates to:
  /// **'Weight Management'**
  String get benefitWeightTitle;

  /// No description provided for @benefitWeightDesc.
  ///
  /// In en, this message translates to:
  /// **'Intermittent fasting can help reduce body weight and body fat by limiting calorie intake and boosting metabolism.'**
  String get benefitWeightDesc;

  /// No description provided for @benefitBloodPressureTitle.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get benefitBloodPressureTitle;

  /// No description provided for @benefitBloodPressureDesc.
  ///
  /// In en, this message translates to:
  /// **'Studies show fasting may help lower blood pressure and improve resting heart rates.'**
  String get benefitBloodPressureDesc;

  /// No description provided for @benefitHeartHealthTitle.
  ///
  /// In en, this message translates to:
  /// **'Heart Health'**
  String get benefitHeartHealthTitle;

  /// No description provided for @benefitHeartHealthDesc.
  ///
  /// In en, this message translates to:
  /// **'Fasting can improve cardiovascular health markers including cholesterol levels and inflammatory markers.'**
  String get benefitHeartHealthDesc;

  /// No description provided for @benefitDiabetesTitle.
  ///
  /// In en, this message translates to:
  /// **'Blood Sugar Control'**
  String get benefitDiabetesTitle;

  /// No description provided for @benefitDiabetesDesc.
  ///
  /// In en, this message translates to:
  /// **'Intermittent fasting may improve insulin sensitivity and help manage Type 2 diabetes.'**
  String get benefitDiabetesDesc;

  /// No description provided for @benefitCognitiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Brain Function'**
  String get benefitCognitiveTitle;

  /// No description provided for @benefitCognitiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Fasting stimulates production of BDNF, a protein that supports brain health and cognitive function.'**
  String get benefitCognitiveDesc;

  /// No description provided for @benefitTissueTitle.
  ///
  /// In en, this message translates to:
  /// **'Tissue Health'**
  String get benefitTissueTitle;

  /// No description provided for @benefitTissueDesc.
  ///
  /// In en, this message translates to:
  /// **'Fasting triggers cellular repair processes and may improve tissue health and recovery.'**
  String get benefitTissueDesc;

  /// No description provided for @benefitMetabolicTitle.
  ///
  /// In en, this message translates to:
  /// **'Metabolic Switch'**
  String get benefitMetabolicTitle;

  /// No description provided for @benefitMetabolicDesc.
  ///
  /// In en, this message translates to:
  /// **'After 12-36 hours, your body switches from glucose to ketones for energy, improving metabolic flexibility.'**
  String get benefitMetabolicDesc;

  /// No description provided for @benefitCellularTitle.
  ///
  /// In en, this message translates to:
  /// **'Cellular Repair'**
  String get benefitCellularTitle;

  /// No description provided for @benefitCellularDesc.
  ///
  /// In en, this message translates to:
  /// **'Fasting initiates autophagy, a process where cells remove damaged components and regenerate.'**
  String get benefitCellularDesc;

  /// No description provided for @warningChildrenTitle.
  ///
  /// In en, this message translates to:
  /// **'Children & Teens'**
  String get warningChildrenTitle;

  /// No description provided for @warningChildrenDesc.
  ///
  /// In en, this message translates to:
  /// **'Intermittent fasting is not recommended for children or adolescents who are still growing.'**
  String get warningChildrenDesc;

  /// No description provided for @warningPregnantTitle.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy'**
  String get warningPregnantTitle;

  /// No description provided for @warningPregnantDesc.
  ///
  /// In en, this message translates to:
  /// **'Do not fast during pregnancy as it may affect fetal development.'**
  String get warningPregnantDesc;

  /// No description provided for @warningBreastfeedingTitle.
  ///
  /// In en, this message translates to:
  /// **'Breastfeeding'**
  String get warningBreastfeedingTitle;

  /// No description provided for @warningBreastfeedingDesc.
  ///
  /// In en, this message translates to:
  /// **'Fasting while breastfeeding may reduce milk supply and nutritional quality.'**
  String get warningBreastfeedingDesc;

  /// No description provided for @warningType1DiabetesTitle.
  ///
  /// In en, this message translates to:
  /// **'Type 1 Diabetes'**
  String get warningType1DiabetesTitle;

  /// No description provided for @warningType1DiabetesDesc.
  ///
  /// In en, this message translates to:
  /// **'People with Type 1 diabetes should not fast without medical supervision due to hypoglycemia risk.'**
  String get warningType1DiabetesDesc;

  /// No description provided for @warningEatingDisordersTitle.
  ///
  /// In en, this message translates to:
  /// **'Eating Disorders'**
  String get warningEatingDisordersTitle;

  /// No description provided for @warningEatingDisordersDesc.
  ///
  /// In en, this message translates to:
  /// **'Fasting may trigger or worsen eating disorders. Seek professional help if you have a history.'**
  String get warningEatingDisordersDesc;

  /// No description provided for @warningMuscleLossTitle.
  ///
  /// In en, this message translates to:
  /// **'Muscle Loss Risk'**
  String get warningMuscleLossTitle;

  /// No description provided for @warningMuscleLossDesc.
  ///
  /// In en, this message translates to:
  /// **'Extended fasting may lead to muscle loss. Maintain protein intake during eating windows.'**
  String get warningMuscleLossDesc;

  /// No description provided for @warningConsultDoctorTitle.
  ///
  /// In en, this message translates to:
  /// **'Consult Your Doctor'**
  String get warningConsultDoctorTitle;

  /// No description provided for @warningConsultDoctorDesc.
  ///
  /// In en, this message translates to:
  /// **'Always consult a healthcare provider before starting fasting, especially if you have medical conditions.'**
  String get warningConsultDoctorDesc;

  /// No description provided for @tipHydrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay Hydrated'**
  String get tipHydrationTitle;

  /// No description provided for @tipHydrationDesc.
  ///
  /// In en, this message translates to:
  /// **'Drink plenty of water, herbal tea, or black coffee during fasting periods. Proper hydration is essential.'**
  String get tipHydrationDesc;

  /// No description provided for @tipGradualStartTitle.
  ///
  /// In en, this message translates to:
  /// **'Start Gradually'**
  String get tipGradualStartTitle;

  /// No description provided for @tipGradualStartDesc.
  ///
  /// In en, this message translates to:
  /// **'Begin with shorter fasting periods (12:12) and gradually increase as your body adapts.'**
  String get tipGradualStartDesc;

  /// No description provided for @tipBalancedMealsTitle.
  ///
  /// In en, this message translates to:
  /// **'Eat Balanced Meals'**
  String get tipBalancedMealsTitle;

  /// No description provided for @tipBalancedMealsDesc.
  ///
  /// In en, this message translates to:
  /// **'Focus on nutritious, whole foods during your eating window. Include proteins, healthy fats, and vegetables.'**
  String get tipBalancedMealsDesc;

  /// No description provided for @tipExerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Light Exercise'**
  String get tipExerciseTitle;

  /// No description provided for @tipExerciseDesc.
  ///
  /// In en, this message translates to:
  /// **'Light to moderate exercise is fine while fasting. Avoid intense workouts until you adapt.'**
  String get tipExerciseDesc;
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
    'ja',
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
    case 'ja':
      return AppLocalizationsJa();
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
