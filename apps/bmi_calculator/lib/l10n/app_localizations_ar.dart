// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'حاسبة مؤشر كتلة الجسم';

  @override
  String get calculator => 'الحاسبة';

  @override
  String get history => 'السجل';

  @override
  String get evolution => 'التطور';

  @override
  String get weight => 'الوزن (كجم)';

  @override
  String get height => 'الطول (سم)';

  @override
  String get calculate => 'احسب';

  @override
  String get save => 'حفظ النتيجة';

  @override
  String get result => 'النتيجة';

  @override
  String yourBmi(String bmi) {
    return 'مؤشر كتلة جسمك هو $bmi';
  }

  @override
  String category(String category) {
    return 'الفئة: $category';
  }

  @override
  String get infoTitle => 'معلومات مؤشر كتلة الجسم';

  @override
  String get infoDescription =>
      'مؤشر كتلة الجسم (BMI) هو مقياس لدهون الجسم بناءً على الطول والوزن ينطبق على الرجال والنساء البالغين.';

  @override
  String get source => 'المصدر: منظمة الصحة العالمية (WHO)';

  @override
  String get underweight => 'نقص الوزن';

  @override
  String get normal => 'وزن طبيعي';

  @override
  String get overweight => 'زيادة الوزن';

  @override
  String get obesity1 => 'سمنة من الدرجة الأولى';

  @override
  String get obesity2 => 'سمنة من الدرجة الثانية';

  @override
  String get obesity3 => 'سمنة من الدرجة الثالثة';

  @override
  String get delete => 'حذف';

  @override
  String get noHistory => 'لا يوجد سجل حتى الآن';

  @override
  String get evolutionGraph => 'رسم بياني للتطور';

  @override
  String get needTwoEntries =>
      'استمر في التسجيل! تحتاج إلى إدخالين على الأقل لرؤية التطور.';

  @override
  String get bmiEvolutionTitle => 'تطور مؤشر كتلة الجسم';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get resultSaved => 'تم حفظ النتيجة!';
}
