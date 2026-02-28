// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'BMI 계산기';

  @override
  String get calculator => '계산자';

  @override
  String get history => '역사';

  @override
  String get evolution => '진화';

  @override
  String get weight => '체중(kg)';

  @override
  String get height => '높이(cm)';

  @override
  String get calculate => '믿다';

  @override
  String get save => '결과 저장';

  @override
  String get result => '결과';

  @override
  String yourBmi(String bmi) {
    return '당신의 BMI는$bmi';
  }

  @override
  String category(String category) {
    return '범주:$category';
  }

  @override
  String get infoTitle => 'BMI 정보';

  @override
  String get infoDescription =>
      '체질량지수(BMI)는 성인 남성과 여성에게 적용되는 키와 몸무게를 기준으로 체지방을 측정한 것입니다.';

  @override
  String get source => '출처: 세계보건기구(WHO)';

  @override
  String get underweight => '저체중';

  @override
  String get normal => '정상 체중';

  @override
  String get overweight => '초과 중량';

  @override
  String get obesity1 => '비만 등급 I';

  @override
  String get obesity2 => '비만 등급 II';

  @override
  String get obesity3 => '비만 등급 III';

  @override
  String get delete => '삭제';

  @override
  String get noHistory => '아직 기록이 없습니다.';

  @override
  String get evolutionGraph => '진화 그래프';

  @override
  String get needTwoEntries => '계속 추적하세요! 진화를 보려면 항목이 2개 이상 필요합니다.';

  @override
  String get bmiEvolutionTitle => 'BMI 진화';

  @override
  String get reset => '다시 놓기';

  @override
  String get resultSaved => '결과가 저장되었습니다!';
}
