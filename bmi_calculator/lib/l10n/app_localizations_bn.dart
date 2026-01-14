// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'BMI ক্যালকুলেটর';

  @override
  String get calculator => 'ক্যালকুলেটর';

  @override
  String get history => 'ইতিহাস';

  @override
  String get evolution => 'বিবর্তন';

  @override
  String get weight => 'ওজন (kg)';

  @override
  String get height => 'উচ্চতা (cm)';

  @override
  String get calculate => 'গণনা করুন';

  @override
  String get save => 'ফলাফল সংরক্ষণ করুন';

  @override
  String get result => 'ফলাফল';

  @override
  String yourBmi(String bmi) {
    return 'আপনার BMI হলো $bmi';
  }

  @override
  String category(String category) {
    return 'বিভাগ: $category';
  }

  @override
  String get infoTitle => 'BMI তথ্য';

  @override
  String get infoDescription =>
      'বডি মাস ইনডেক্স (BMI) হলো উচ্চতা এবং ওজনের উপর ভিত্তি করে শরীরের চর্বির একটি পরিমাপ যা প্রাপ্তবয়স্ক পুরুষ এবং মহিলাদের জন্য প্রযোজ্য।';

  @override
  String get source => 'উৎস: বিশ্ব স্বাস্থ্য সংস্থা (WHO)';

  @override
  String get underweight => 'কম ওজন';

  @override
  String get normal => 'স্বাভাবিক ওজন';

  @override
  String get overweight => 'অতিরিক্ত ওজন';

  @override
  String get obesity1 => 'স্থূলতা ক্লাস I';

  @override
  String get obesity2 => 'স্থূলতা ক্লাস II';

  @override
  String get obesity3 => 'স্থূলতা ক্লাস III';

  @override
  String get delete => 'মুছুন';

  @override
  String get noHistory => 'এখনও কোন ইতিহাস নেই';

  @override
  String get evolutionGraph => 'বিবর্তন গ্রাফ';

  @override
  String get needTwoEntries =>
      'রেকর্ড করতে থাকুন! বিবর্তন দেখতে আপনার কমপক্ষে 2টি এন্ট্রি প্রয়োজন।';

  @override
  String get bmiEvolutionTitle => 'BMI বিবর্তন';

  @override
  String get reset => 'রিসেট';

  @override
  String get resultSaved => 'ফলাফল সংরক্ষিত!';
}
