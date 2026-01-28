// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '复利计算器';

  @override
  String get calculate => '计算';

  @override
  String get reset => '重置';

  @override
  String get save => '保存';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get close => '关闭';

  @override
  String get settings => '设置';

  @override
  String get history => '历史';

  @override
  String get chart => '图表';

  @override
  String get details => '详情';

  @override
  String get initialCapital => '初始资本';

  @override
  String get interestRate => '利率（年%）';

  @override
  String get investmentPeriod => '投资期限';

  @override
  String get monthlyContribution => '每月投入';

  @override
  String get months => '月';

  @override
  String get years => '年';

  @override
  String get optional => '可选';

  @override
  String get calculationName => '计算名称';

  @override
  String get calculationNameHint => '输入名称';

  @override
  String get calculationSaved => '计算已保存';

  @override
  String get requiredField => '必填字段';

  @override
  String get invalidNumber => '无效数字';

  @override
  String get invalidRate => '无效利率';

  @override
  String get totalAmount => '总额';

  @override
  String get totalContributed => '投入总额';

  @override
  String get totalInterest => '利息总额';

  @override
  String get percentageGain => '收益百分比';

  @override
  String get result => '结果';

  @override
  String get viewChart => '查看图表';

  @override
  String get growthChart => '增长图表';

  @override
  String get month => '月';

  @override
  String get monthlyBreakdown => '月度明细';

  @override
  String get balanceEvolution => '余额演变';

  @override
  String get investmentPresets => '投资预设';

  @override
  String get presetPoupanca => '储蓄账户';

  @override
  String get presetPoupancaDesc => '低风险，低回报（6.17%年）';

  @override
  String get presetCDI => 'CDI 100%';

  @override
  String get presetCDIDesc => '保守后固定（10.65%年）';

  @override
  String get presetTesouroSelic => 'Tesouro Selic';

  @override
  String get presetTesouroSelicDesc => '政府债券（10.75%年）';

  @override
  String get presetTesouroIPCA => 'Tesouro IPCA+';

  @override
  String get presetTesouroIPCADesc => '通胀保护（6.50% + IPCA）';

  @override
  String get presetCDB => 'CDB';

  @override
  String get presetCDBDesc => '银行存款证（11.50%年）';

  @override
  String get presetLCILCA => 'LCI/LCA';

  @override
  String get presetLCILCADesc => '房地产/农业免税（9.00%年）';

  @override
  String get calculationHistory => '计算历史';

  @override
  String get noHistory => '暂无计算';

  @override
  String get deleteConfirm => '删除此计算？';

  @override
  String get clearHistory => '清除所有历史';

  @override
  String get clearHistoryConfirm => '删除所有计算？';

  @override
  String get achievements => '成就';

  @override
  String get achievementUnlocked => '成就解锁！';

  @override
  String get achievementsProgress => '进度';

  @override
  String get notUnlockedYet => '尚未解锁';

  @override
  String get unlockedOn => '解锁于';

  @override
  String get categoryCalculations => '计算';

  @override
  String get categoryStreak => '连续';

  @override
  String get categoryAmounts => '金额';

  @override
  String get categorySpecial => '特殊';

  @override
  String get achievementFirstCalc => '首次计算';

  @override
  String get achievementFirstCalcDesc => '完成您的第一次计算';

  @override
  String get achievementCalc10 => '10次计算';

  @override
  String get achievementCalc10Desc => '完成10次计算';

  @override
  String get achievementCalc50 => '50次计算';

  @override
  String get achievementCalc50Desc => '完成50次计算';

  @override
  String get achievementCalc100 => '百次';

  @override
  String get achievementCalc100Desc => '完成100次计算';

  @override
  String get achievementStreak3 => '3天连续';

  @override
  String get achievementStreak3Desc => '连续3天使用应用';

  @override
  String get achievementStreak7 => '周勤奋';

  @override
  String get achievementStreak7Desc => '连续7天使用应用';

  @override
  String get achievementStreak30 => '月大师';

  @override
  String get achievementStreak30Desc => '连续30天使用应用';

  @override
  String get achievementMillion => '首个百万';

  @override
  String get achievementMillionDesc => '计算达到R\$ 1,000,000';

  @override
  String get achievementTenMillion => '千万俱乐部';

  @override
  String get achievementTenMillionDesc => '计算达到R\$ 10,000,000';

  @override
  String get achievementLongTerm => '长期思考者';

  @override
  String get achievementLongTermDesc => '计算10+年的投资';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count天',
      one: '1天',
    );
    return '$_temp0';
  }

  @override
  String get currentStreak => '当前连续';

  @override
  String get bestStreak => '最佳连续';

  @override
  String get days => '天';

  @override
  String get dailyGoal => '每日目标';

  @override
  String get dailyGoalTarget => '目标计算数';

  @override
  String get goalReached => '目标达成！';

  @override
  String calculationsProgress(int completed, int target) {
    return '$completed/$target计算';
  }

  @override
  String get calculationsPerDay => '每天计算数';

  @override
  String get colorTheme => '颜色主题';

  @override
  String get themeGreen => '绿色';

  @override
  String get themeBlue => '蓝色';

  @override
  String get themePurple => '紫色';

  @override
  String get themeOrange => '橙色';

  @override
  String get themeTeal => '青色';

  @override
  String get themeIndigo => '靛蓝';

  @override
  String get themeRed => '红色';

  @override
  String get themeAmber => '琥珀';
}
