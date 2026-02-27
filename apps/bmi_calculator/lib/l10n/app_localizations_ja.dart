// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'BMI 計算機';

  @override
  String get calculator => '計算機';

  @override
  String get history => '履歴';

  @override
  String get evolution => '推移';

  @override
  String get weight => '体重 (kg)';

  @override
  String get height => '身長 (cm)';

  @override
  String get calculate => '計算する';

  @override
  String get save => '結果を保存';

  @override
  String get result => '結果';

  @override
  String yourBmi(String bmi) {
    return 'あなたのBMIは $bmi です';
  }

  @override
  String category(String category) {
    return 'カテゴリ: $category';
  }

  @override
  String get infoTitle => 'BMI情報';

  @override
  String get infoDescription =>
      'ボディマス指数 (BMI) は、成人の男性と女性に適用される身長と体重に基づく体脂肪の尺度です。';

  @override
  String get source => '出典: 世界保健機関 (WHO)';

  @override
  String get underweight => '低体重';

  @override
  String get normal => '普通体重';

  @override
  String get overweight => '前肥満';

  @override
  String get obesity1 => '肥満 (1度)';

  @override
  String get obesity2 => '肥満 (2度以上)';

  @override
  String get obesity3 => '肥満 (3度以上)';

  @override
  String get delete => '削除';

  @override
  String get noHistory => '履歴はまだありません';

  @override
  String get evolutionGraph => '推移グラフ';

  @override
  String get needTwoEntries => '記録を続けてください！推移を見るには少なくとも2つのエントリが必要です。';

  @override
  String get bmiEvolutionTitle => 'BMI推移';

  @override
  String get reset => 'リセット';

  @override
  String get resultSaved => '結果が保存されました！';
}
