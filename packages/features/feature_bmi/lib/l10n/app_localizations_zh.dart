// ignore: unused_import
import 'package:intl/intl.dart' as intl;


// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'BMI计算器';

  @override
  String get calculator => '计算器';

  @override
  String get history => '历史记录';

  @override
  String get evolution => '演变';

  @override
  String get weight => '体重 (kg)';

  @override
  String get height => '身高 (cm)';

  @override
  String get calculate => '计算';

  @override
  String get save => '保存结果';

  @override
  String get result => '结果';

  @override
  String yourBmi(String bmi) {
    return '您的BMI是 $bmi';
  }

  @override
  String category(String category) {
    return '类别: $category';
  }

  @override
  String get infoTitle => 'BMI信息';

  @override
  String get infoDescription => '身体质量指数 (BMI) 是基于身高和体重的体脂衡量标准，适用于成年男性和女性。';

  @override
  String get source => '来源: 世界卫生组织 (WHO)';

  @override
  String get underweight => '体重过轻';

  @override
  String get normal => '正常体重';

  @override
  String get overweight => '超重';

  @override
  String get obesity1 => '肥胖 I级';

  @override
  String get obesity2 => '肥胖 II级';

  @override
  String get obesity3 => '肥胖 III级';

  @override
  String get delete => '删除';

  @override
  String get noHistory => '暂无历史记录';

  @override
  String get evolutionGraph => '演变图表';

  @override
  String get needTwoEntries => '继续记录！您需要至少2条记录才能查看演变。';

  @override
  String get bmiEvolutionTitle => 'BMI演变';

  @override
  String get reset => '重置';

  @override
  String get resultSaved => '结果已保存！';
}
