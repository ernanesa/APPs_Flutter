// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'BMI Calculator';

  @override
  String get calculator => 'Calculator';

  @override
  String get history => 'History';

  @override
  String get evolution => 'Evolution';

  @override
  String get weight => 'Weight (kg)';

  @override
  String get height => 'Height (cm)';

  @override
  String get calculate => 'Calculate';

  @override
  String get save => 'Save Result';

  @override
  String get result => 'Result';

  @override
  String yourBmi(String bmi) {
    return 'Your BMI is $bmi';
  }

  @override
  String category(String category) {
    return 'Category: $category';
  }

  @override
  String get infoTitle => 'BMI Information';

  @override
  String get infoDescription =>
      'Body Mass Index (BMI) is a measure of body fat based on height and weight that applies to adult men and women.';

  @override
  String get source => 'Source: World Health Organization (WHO)';

  @override
  String get underweight => 'Underweight';

  @override
  String get normal => 'Normal weight';

  @override
  String get overweight => 'Overweight';

  @override
  String get obesity1 => 'Obesity Class I';

  @override
  String get obesity2 => 'Obesity Class II';

  @override
  String get obesity3 => 'Obesity Class III';

  @override
  String get delete => 'Delete';

  @override
  String get noHistory => 'No history yet';

  @override
  String get evolutionGraph => 'Evolution Graph';

  @override
  String get needTwoEntries =>
      'Keep tracking! You need at least 2 entries to see evolution.';

  @override
  String get bmiEvolutionTitle => 'BMI Evolution';

  @override
  String get reset => 'Reset';

  @override
  String get resultSaved => 'Result saved!';
}
