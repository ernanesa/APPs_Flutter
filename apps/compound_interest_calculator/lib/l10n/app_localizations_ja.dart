// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '複利計算機';

  @override
  String get calculate => '計算';

  @override
  String get reset => 'リセット';

  @override
  String get save => '保存';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get close => '閉じる';

  @override
  String get settings => '設定';

  @override
  String get history => '履歴';

  @override
  String get chart => 'グラフ';

  @override
  String get details => '詳細';

  @override
  String get initialCapital => '初期資本';

  @override
  String get interestRate => '利率（年%）';

  @override
  String get investmentPeriod => '投資期間';

  @override
  String get monthlyContribution => '月額拠出';

  @override
  String get months => 'ヶ月';

  @override
  String get years => '年';

  @override
  String get optional => 'オプション';

  @override
  String get calculationName => '計算名';

  @override
  String get calculationNameHint => '名前を入力';

  @override
  String get calculationSaved => '計算を保存しました';

  @override
  String get requiredField => '必須項目';

  @override
  String get invalidNumber => '無効な数値';

  @override
  String get invalidRate => '無効な利率';

  @override
  String get totalAmount => '合計金額';

  @override
  String get totalContributed => '投資総額';

  @override
  String get totalInterest => '利息総額';

  @override
  String get percentageGain => '利益率';

  @override
  String get result => '結果';

  @override
  String get viewChart => 'グラフを見る';

  @override
  String get growthChart => '成長グラフ';

  @override
  String get month => '月';

  @override
  String get monthlyBreakdown => '月次内訳';

  @override
  String get balanceEvolution => '残高推移';

  @override
  String get investmentPresets => '投資プリセット';

  @override
  String get presetPoupanca => '普通預金';

  @override
  String get presetPoupancaDesc => '低リスク、低リターン（年6.17%）';

  @override
  String get presetCDI => 'CDI 100%';

  @override
  String get presetCDIDesc => '保守的後固定（年10.65%）';

  @override
  String get presetTesouroSelic => 'Tesouro Selic';

  @override
  String get presetTesouroSelicDesc => '国債（年10.75%）';

  @override
  String get presetTesouroIPCA => 'Tesouro IPCA+';

  @override
  String get presetTesouroIPCADesc => 'インフレ保護（6.50% + IPCA）';

  @override
  String get presetCDB => 'CDB';

  @override
  String get presetCDBDesc => '銀行預金証書（年11.50%）';

  @override
  String get presetLCILCA => 'LCI/LCA';

  @override
  String get presetLCILCADesc => '不動産/農業非課税（年9.00%）';

  @override
  String get calculationHistory => '計算履歴';

  @override
  String get noHistory => '計算がまだありません';

  @override
  String get deleteConfirm => 'この計算を削除しますか？';

  @override
  String get clearHistory => 'すべての履歴をクリア';

  @override
  String get clearHistoryConfirm => 'すべての計算を削除しますか？';

  @override
  String get achievements => '実績';

  @override
  String get achievementUnlocked => '実績解除！';

  @override
  String get achievementsProgress => '進捗';

  @override
  String get notUnlockedYet => 'まだ解除されていません';

  @override
  String get unlockedOn => '解除日';

  @override
  String get categoryCalculations => '計算';

  @override
  String get categoryStreak => '連続';

  @override
  String get categoryAmounts => '金額';

  @override
  String get categorySpecial => '特別';

  @override
  String get achievementFirstCalc => '最初の計算';

  @override
  String get achievementFirstCalcDesc => '最初の計算を完了';

  @override
  String get achievementCalc10 => '10回計算';

  @override
  String get achievementCalc10Desc => '10回の計算を完了';

  @override
  String get achievementCalc50 => '50回計算';

  @override
  String get achievementCalc50Desc => '50回の計算を完了';

  @override
  String get achievementCalc100 => 'センチュリー';

  @override
  String get achievementCalc100Desc => '100回の計算を完了';

  @override
  String get achievementStreak3 => '3日連続';

  @override
  String get achievementStreak3Desc => '3日間連続でアプリを使用';

  @override
  String get achievementStreak7 => '週の戦士';

  @override
  String get achievementStreak7Desc => '7日間連続でアプリを使用';

  @override
  String get achievementStreak30 => '月のマスター';

  @override
  String get achievementStreak30Desc => '30日間連続でアプリを使用';

  @override
  String get achievementMillion => '最初の100万';

  @override
  String get achievementMillionDesc => 'R\$ 1,000,000に到達する計算';

  @override
  String get achievementTenMillion => '1000万クラブ';

  @override
  String get achievementTenMillionDesc => 'R\$ 10,000,000に到達する計算';

  @override
  String get achievementLongTerm => '長期思考者';

  @override
  String get achievementLongTermDesc => '10年以上の投資を計算';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count日',
      one: '1日',
    );
    return '$_temp0';
  }

  @override
  String get currentStreak => '現在の連続';

  @override
  String get bestStreak => '最高の連続';

  @override
  String get days => '日';

  @override
  String get dailyGoal => '日次目標';

  @override
  String get dailyGoalTarget => '目標計算数';

  @override
  String get goalReached => '目標達成！';

  @override
  String calculationsProgress(int completed, int target) {
    return '$completed/$target計算';
  }

  @override
  String get calculationsPerDay => '1日あたりの計算数';

  @override
  String get colorTheme => 'カラーテーマ';

  @override
  String get themeGreen => '緑';

  @override
  String get themeBlue => '青';

  @override
  String get themePurple => '紫';

  @override
  String get themeOrange => 'オレンジ';

  @override
  String get themeTeal => 'ティール';

  @override
  String get themeIndigo => 'インディゴ';

  @override
  String get themeRed => '赤';

  @override
  String get themeAmber => '琥珀';
}
