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
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Compound Interest'**
  String get appTitle;

  /// No description provided for @calculate.
  ///
  /// In en, this message translates to:
  /// **'Calculate'**
  String get calculate;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

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

  /// No description provided for @chart.
  ///
  /// In en, this message translates to:
  /// **'Chart'**
  String get chart;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @initialCapital.
  ///
  /// In en, this message translates to:
  /// **'Initial Capital'**
  String get initialCapital;

  /// No description provided for @interestRate.
  ///
  /// In en, this message translates to:
  /// **'Interest Rate (% per year)'**
  String get interestRate;

  /// No description provided for @investmentPeriod.
  ///
  /// In en, this message translates to:
  /// **'Investment Period'**
  String get investmentPeriod;

  /// No description provided for @monthlyContribution.
  ///
  /// In en, this message translates to:
  /// **'Monthly Contribution'**
  String get monthlyContribution;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get months;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'Years'**
  String get years;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @calculationName.
  ///
  /// In en, this message translates to:
  /// **'Calculation Name'**
  String get calculationName;

  /// No description provided for @calculationNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get calculationNameHint;

  /// No description provided for @calculationSaved.
  ///
  /// In en, this message translates to:
  /// **'Calculation saved'**
  String get calculationSaved;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required field'**
  String get requiredField;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// No description provided for @invalidRate.
  ///
  /// In en, this message translates to:
  /// **'Invalid rate'**
  String get invalidRate;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @totalContributed.
  ///
  /// In en, this message translates to:
  /// **'Total Contributed'**
  String get totalContributed;

  /// No description provided for @totalInterest.
  ///
  /// In en, this message translates to:
  /// **'Total Interest'**
  String get totalInterest;

  /// No description provided for @percentageGain.
  ///
  /// In en, this message translates to:
  /// **'Percentage Gain'**
  String get percentageGain;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @viewChart.
  ///
  /// In en, this message translates to:
  /// **'View chart'**
  String get viewChart;

  /// No description provided for @growthChart.
  ///
  /// In en, this message translates to:
  /// **'Growth chart'**
  String get growthChart;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @monthlyBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Monthly Breakdown'**
  String get monthlyBreakdown;

  /// No description provided for @balanceEvolution.
  ///
  /// In en, this message translates to:
  /// **'Balance Evolution'**
  String get balanceEvolution;

  /// No description provided for @investmentPresets.
  ///
  /// In en, this message translates to:
  /// **'Investment Presets'**
  String get investmentPresets;

  /// No description provided for @presetPoupanca.
  ///
  /// In en, this message translates to:
  /// **'Savings Account'**
  String get presetPoupanca;

  /// No description provided for @presetPoupancaDesc.
  ///
  /// In en, this message translates to:
  /// **'Low risk, low return (6.17% p.y.)'**
  String get presetPoupancaDesc;

  /// No description provided for @presetCDI.
  ///
  /// In en, this message translates to:
  /// **'CDI 100%'**
  String get presetCDI;

  /// No description provided for @presetCDIDesc.
  ///
  /// In en, this message translates to:
  /// **'Post-fixed conservative (10.65% p.y.)'**
  String get presetCDIDesc;

  /// No description provided for @presetTesouroSelic.
  ///
  /// In en, this message translates to:
  /// **'Tesouro Selic'**
  String get presetTesouroSelic;

  /// No description provided for @presetTesouroSelicDesc.
  ///
  /// In en, this message translates to:
  /// **'Government bonds (10.75% p.y.)'**
  String get presetTesouroSelicDesc;

  /// No description provided for @presetTesouroIPCA.
  ///
  /// In en, this message translates to:
  /// **'Tesouro IPCA+'**
  String get presetTesouroIPCA;

  /// No description provided for @presetTesouroIPCADesc.
  ///
  /// In en, this message translates to:
  /// **'Inflation protected (6.50% + IPCA)'**
  String get presetTesouroIPCADesc;

  /// No description provided for @presetCDB.
  ///
  /// In en, this message translates to:
  /// **'CDB'**
  String get presetCDB;

  /// No description provided for @presetCDBDesc.
  ///
  /// In en, this message translates to:
  /// **'Bank deposit certificate (11.50% p.y.)'**
  String get presetCDBDesc;

  /// No description provided for @presetLCILCA.
  ///
  /// In en, this message translates to:
  /// **'LCI/LCA'**
  String get presetLCILCA;

  /// No description provided for @presetLCILCADesc.
  ///
  /// In en, this message translates to:
  /// **'Tax-free real estate/agro (9.00% p.y.)'**
  String get presetLCILCADesc;

  /// No description provided for @calculationHistory.
  ///
  /// In en, this message translates to:
  /// **'Calculation History'**
  String get calculationHistory;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No calculations yet'**
  String get noHistory;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this calculation?'**
  String get deleteConfirm;

  /// No description provided for @clearHistory.
  ///
  /// In en, this message translates to:
  /// **'Clear All History'**
  String get clearHistory;

  /// No description provided for @clearHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete all calculations?'**
  String get clearHistoryConfirm;

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
  /// **'Progress'**
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

  /// No description provided for @categoryCalculations.
  ///
  /// In en, this message translates to:
  /// **'Calculations'**
  String get categoryCalculations;

  /// No description provided for @categoryStreak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get categoryStreak;

  /// No description provided for @categoryAmounts.
  ///
  /// In en, this message translates to:
  /// **'Amounts'**
  String get categoryAmounts;

  /// No description provided for @categorySpecial.
  ///
  /// In en, this message translates to:
  /// **'Special'**
  String get categorySpecial;

  /// No description provided for @achievementFirstCalc.
  ///
  /// In en, this message translates to:
  /// **'First Calculation'**
  String get achievementFirstCalc;

  /// No description provided for @achievementFirstCalcDesc.
  ///
  /// In en, this message translates to:
  /// **'Complete your first calculation'**
  String get achievementFirstCalcDesc;

  /// No description provided for @achievementCalc10.
  ///
  /// In en, this message translates to:
  /// **'10 Calculations'**
  String get achievementCalc10;

  /// No description provided for @achievementCalc10Desc.
  ///
  /// In en, this message translates to:
  /// **'Complete 10 calculations'**
  String get achievementCalc10Desc;

  /// No description provided for @achievementCalc50.
  ///
  /// In en, this message translates to:
  /// **'50 Calculations'**
  String get achievementCalc50;

  /// No description provided for @achievementCalc50Desc.
  ///
  /// In en, this message translates to:
  /// **'Complete 50 calculations'**
  String get achievementCalc50Desc;

  /// No description provided for @achievementCalc100.
  ///
  /// In en, this message translates to:
  /// **'Century'**
  String get achievementCalc100;

  /// No description provided for @achievementCalc100Desc.
  ///
  /// In en, this message translates to:
  /// **'Complete 100 calculations'**
  String get achievementCalc100Desc;

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
  /// **'Month Master'**
  String get achievementStreak30;

  /// No description provided for @achievementStreak30Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the app for 30 consecutive days'**
  String get achievementStreak30Desc;

  /// No description provided for @achievementMillion.
  ///
  /// In en, this message translates to:
  /// **'First Million'**
  String get achievementMillion;

  /// No description provided for @achievementMillionDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate reaching R\$ 1,000,000'**
  String get achievementMillionDesc;

  /// No description provided for @achievementTenMillion.
  ///
  /// In en, this message translates to:
  /// **'Ten Million Club'**
  String get achievementTenMillion;

  /// No description provided for @achievementTenMillionDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate reaching R\$ 10,000,000'**
  String get achievementTenMillionDesc;

  /// No description provided for @achievementLongTerm.
  ///
  /// In en, this message translates to:
  /// **'Long-Term Thinker'**
  String get achievementLongTerm;

  /// No description provided for @achievementLongTermDesc.
  ///
  /// In en, this message translates to:
  /// **'Calculate investment of 10+ years'**
  String get achievementLongTermDesc;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day} other{{count} days}}'**
  String streakDays(int count);

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
  /// **'Target Calculations'**
  String get dailyGoalTarget;

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'Goal Reached!'**
  String get goalReached;

  /// No description provided for @calculationsProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed}/{target} calculations'**
  String calculationsProgress(int completed, int target);

  /// No description provided for @calculationsPerDay.
  ///
  /// In en, this message translates to:
  /// **'calculations per day'**
  String get calculationsPerDay;

  /// No description provided for @colorTheme.
  ///
  /// In en, this message translates to:
  /// **'Color Theme'**
  String get colorTheme;

  /// No description provided for @themeGreen.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get themeGreen;

  /// No description provided for @themeBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get themeBlue;

  /// No description provided for @themePurple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get themePurple;

  /// No description provided for @themeOrange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get themeOrange;

  /// No description provided for @themeTeal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get themeTeal;

  /// No description provided for @themeIndigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get themeIndigo;

  /// No description provided for @themeRed.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get themeRed;

  /// No description provided for @themeAmber.
  ///
  /// In en, this message translates to:
  /// **'Amber'**
  String get themeAmber;
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
