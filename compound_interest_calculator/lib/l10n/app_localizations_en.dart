// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Compound Interest';

  @override
  String get calculate => 'Calculate';

  @override
  String get reset => 'Reset';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get close => 'Close';

  @override
  String get settings => 'Settings';

  @override
  String get history => 'History';

  @override
  String get chart => 'Chart';

  @override
  String get details => 'Details';

  @override
  String get initialCapital => 'Initial Capital';

  @override
  String get interestRate => 'Interest Rate (% per year)';

  @override
  String get investmentPeriod => 'Investment Period';

  @override
  String get monthlyContribution => 'Monthly Contribution';

  @override
  String get months => 'Months';

  @override
  String get years => 'Years';

  @override
  String get optional => 'Optional';

  @override
  String get calculationName => 'Calculation Name';

  @override
  String get calculationNameHint => 'Enter a name';

  @override
  String get calculationSaved => 'Calculation saved';

  @override
  String get requiredField => 'Required field';

  @override
  String get invalidNumber => 'Invalid number';

  @override
  String get invalidRate => 'Invalid rate';

  @override
  String get totalAmount => 'Total Amount';

  @override
  String get totalContributed => 'Total Contributed';

  @override
  String get totalInterest => 'Total Interest';

  @override
  String get percentageGain => 'Percentage Gain';

  @override
  String get result => 'Result';

  @override
  String get viewChart => 'View chart';

  @override
  String get growthChart => 'Growth chart';

  @override
  String get month => 'Month';

  @override
  String get monthlyBreakdown => 'Monthly Breakdown';

  @override
  String get balanceEvolution => 'Balance Evolution';

  @override
  String get investmentPresets => 'Investment Presets';

  @override
  String get presetPoupanca => 'Savings Account';

  @override
  String get presetPoupancaDesc => 'Low risk, low return (6.17% p.y.)';

  @override
  String get presetCDI => 'CDI 100%';

  @override
  String get presetCDIDesc => 'Post-fixed conservative (10.65% p.y.)';

  @override
  String get presetTesouroSelic => 'Tesouro Selic';

  @override
  String get presetTesouroSelicDesc => 'Government bonds (10.75% p.y.)';

  @override
  String get presetTesouroIPCA => 'Tesouro IPCA+';

  @override
  String get presetTesouroIPCADesc => 'Inflation protected (6.50% + IPCA)';

  @override
  String get presetCDB => 'CDB';

  @override
  String get presetCDBDesc => 'Bank deposit certificate (11.50% p.y.)';

  @override
  String get presetLCILCA => 'LCI/LCA';

  @override
  String get presetLCILCADesc => 'Tax-free real estate/agro (9.00% p.y.)';

  @override
  String get calculationHistory => 'Calculation History';

  @override
  String get noHistory => 'No calculations yet';

  @override
  String get deleteConfirm => 'Delete this calculation?';

  @override
  String get clearHistory => 'Clear All History';

  @override
  String get clearHistoryConfirm => 'Delete all calculations?';

  @override
  String get achievements => 'Achievements';

  @override
  String get achievementUnlocked => 'Achievement Unlocked!';

  @override
  String get achievementsProgress => 'Progress';

  @override
  String get notUnlockedYet => 'Not unlocked yet';

  @override
  String get unlockedOn => 'Unlocked on';

  @override
  String get categoryCalculations => 'Calculations';

  @override
  String get categoryStreak => 'Streak';

  @override
  String get categoryAmounts => 'Amounts';

  @override
  String get categorySpecial => 'Special';

  @override
  String get achievementFirstCalc => 'First Calculation';

  @override
  String get achievementFirstCalcDesc => 'Complete your first calculation';

  @override
  String get achievementCalc10 => '10 Calculations';

  @override
  String get achievementCalc10Desc => 'Complete 10 calculations';

  @override
  String get achievementCalc50 => '50 Calculations';

  @override
  String get achievementCalc50Desc => 'Complete 50 calculations';

  @override
  String get achievementCalc100 => 'Century';

  @override
  String get achievementCalc100Desc => 'Complete 100 calculations';

  @override
  String get achievementStreak3 => '3-Day Streak';

  @override
  String get achievementStreak3Desc => 'Use the app for 3 consecutive days';

  @override
  String get achievementStreak7 => 'Week Warrior';

  @override
  String get achievementStreak7Desc => 'Use the app for 7 consecutive days';

  @override
  String get achievementStreak30 => 'Month Master';

  @override
  String get achievementStreak30Desc => 'Use the app for 30 consecutive days';

  @override
  String get achievementMillion => 'First Million';

  @override
  String get achievementMillionDesc => 'Calculate reaching R\$ 1,000,000';

  @override
  String get achievementTenMillion => 'Ten Million Club';

  @override
  String get achievementTenMillionDesc => 'Calculate reaching R\$ 10,000,000';

  @override
  String get achievementLongTerm => 'Long-Term Thinker';

  @override
  String get achievementLongTermDesc => 'Calculate investment of 10+ years';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get bestStreak => 'Best Streak';

  @override
  String get days => 'days';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String get dailyGoalTarget => 'Target Calculations';

  @override
  String get goalReached => 'Goal Reached!';

  @override
  String calculationsProgress(int completed, int target) {
    return '$completed/$target calculations';
  }

  @override
  String get calculationsPerDay => 'calculations per day';

  @override
  String get colorTheme => 'Color Theme';

  @override
  String get themeGreen => 'Green';

  @override
  String get themeBlue => 'Blue';

  @override
  String get themePurple => 'Purple';

  @override
  String get themeOrange => 'Orange';

  @override
  String get themeTeal => 'Teal';

  @override
  String get themeIndigo => 'Indigo';

  @override
  String get themeRed => 'Red';

  @override
  String get themeAmber => 'Amber';
}
