// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '断食追踪器';

  @override
  String get settings => '设置';

  @override
  String get history => '历史';

  @override
  String get achievements => '成就';

  @override
  String get close => '关闭';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get ok => '确定';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get ofPreposition => '/';

  @override
  String get readyToFast => '准备断食';

  @override
  String get complete => '完成';

  @override
  String get endEarly => '提前结束';

  @override
  String get cancelFastingConfirm => '您确定要取消本次断食吗？进度将会丢失。';

  @override
  String get noHistory => '暂无断食记录';

  @override
  String get totalHours => '总小时数';

  @override
  String get openSource => '开源项目';

  @override
  String get openSourceDesc => '使用Flutter构建';

  @override
  String get startFasting => '开始断食';

  @override
  String get endFasting => '结束断食';

  @override
  String get cancelFasting => '取消断食';

  @override
  String get fastingInProgress => '断食进行中';

  @override
  String get fastingCompleted => '断食完成！';

  @override
  String get timeRemaining => '剩余时间';

  @override
  String get timeElapsed => '已用时间';

  @override
  String get targetReached => '目标达成！';

  @override
  String get selectProtocol => '选择方案';

  @override
  String get protocol12_12 => '12:12';

  @override
  String get protocol12_12Desc => '断食12小时，进食12小时';

  @override
  String get protocol14_10 => '14:10';

  @override
  String get protocol14_10Desc => '断食14小时，进食10小时';

  @override
  String get protocol16_8 => '16:8';

  @override
  String get protocol16_8Desc => '断食16小时，进食8小时（热门）';

  @override
  String get protocol18_6 => '18:6';

  @override
  String get protocol18_6Desc => '断食18小时，进食6小时';

  @override
  String get protocol20_4 => '20:4';

  @override
  String get protocol20_4Desc => '断食20小时，进食4小时（勇士）';

  @override
  String get protocol23_1 => '23:1';

  @override
  String get protocol23_1Desc => '断食23小时，进食1小时（OMAD）';

  @override
  String get metabolicStages => '代谢阶段';

  @override
  String get stageFed => '饱腹状态';

  @override
  String get stageFedDesc => '身体消化食物，胰岛素升高';

  @override
  String get stageEarlyFasting => '初期断食';

  @override
  String get stageEarlyFastingDesc => '血糖稳定，使用糖原';

  @override
  String get stageFatBurning => '脂肪燃烧';

  @override
  String get stageFatBurningDesc => '身体转向脂肪供能';

  @override
  String get stageKetosis => '酮症';

  @override
  String get stageKetosisDesc => '产生酮体，思维更清晰';

  @override
  String get stageDeepKetosis => '深度酮症';

  @override
  String get stageDeepKetosisDesc => '最大脂肪燃烧，生长激素提升';

  @override
  String get stageAutophagy => '自噬';

  @override
  String get stageAutophagyDesc => '细胞清洁与再生';

  @override
  String get currentStage => '当前阶段';

  @override
  String stageStartsAt(int hours) {
    return '从$hours小时开始';
  }

  @override
  String get healthInfo => '健康信息';

  @override
  String get benefits => '益处';

  @override
  String get warnings => '警告与注意事项';

  @override
  String get tips => '成功秘诀';

  @override
  String get benefitWeightLoss => '促进减重和脂肪燃烧';

  @override
  String get benefitInsulin => '改善胰岛素敏感性';

  @override
  String get benefitBrain => '增强脑功能和思维清晰度';

  @override
  String get benefitHeart => '支持心血管健康';

  @override
  String get benefitCellRepair => '触发细胞修复（自噬）';

  @override
  String get benefitInflammation => '减少炎症';

  @override
  String get benefitLongevity => '可能促进长寿';

  @override
  String get benefitMetabolism => '提升代谢健康';

  @override
  String get warningPregnant => '怀孕或哺乳期不建议断食';

  @override
  String get warningDiabetes => '糖尿病患者请咨询医生';

  @override
  String get warningMedication => '服药者请咨询医生';

  @override
  String get warningEatingDisorder => '有饮食障碍史者请避免';

  @override
  String get warningChildren => '不适合儿童或青少年';

  @override
  String get warningUnderweight => '体重过轻者不建议';

  @override
  String get warningMedical => '开始前请咨询医疗专业人员';

  @override
  String get tipHydration => '断食期间保持充足水分';

  @override
  String get tipGradual => '从较短的断食时间开始';

  @override
  String get tipNutrition => '进食窗口期注重营养食物';

  @override
  String get tipListenBody => '倾听身体，按需调整';

  @override
  String get sourceInfo => '信息基于约翰霍普金斯医学院和哈佛健康的研究';

  @override
  String get currentStreak => '当前连续';

  @override
  String get bestStreak => '最佳连续';

  @override
  String get totalFasts => '总断食次数';

  @override
  String get daysUnit => '天';

  @override
  String get dayUnit => '天';

  @override
  String streakDays(int count) {
    return '$count天';
  }

  @override
  String achievementsProgress(int unlocked, int total) {
    return '已解锁$unlocked/$total';
  }

  @override
  String get achievementUnlocked => '成就解锁！';

  @override
  String get notUnlockedYet => '尚未解锁';

  @override
  String unlockedOn(String date) {
    return '解锁于$date';
  }

  @override
  String get categorySession => '次数';

  @override
  String get categoryStreak => '连续';

  @override
  String get categoryTime => '时间';

  @override
  String get categorySpecial => '特殊';

  @override
  String get achievementFirstFast => '第一次断食';

  @override
  String get achievementFirstFastDesc => '完成您的第一次断食';

  @override
  String get achievement10Fasts => '坚定的断食者';

  @override
  String get achievement10FastsDesc => '完成10次断食';

  @override
  String get achievement50Fasts => '断食专家';

  @override
  String get achievement50FastsDesc => '完成50次断食';

  @override
  String get achievement100Fasts => '断食大师';

  @override
  String get achievement100FastsDesc => '完成100次断食';

  @override
  String get achievementStreak3 => '良好开端';

  @override
  String get achievementStreak3Desc => '保持3天连续断食';

  @override
  String get achievementStreak7 => '周冠军';

  @override
  String get achievementStreak7Desc => '保持7天连续断食';

  @override
  String get achievementStreak30 => '月冠军';

  @override
  String get achievementStreak30Desc => '保持30天连续断食';

  @override
  String get achievement24Hours => '全天断食';

  @override
  String get achievement24HoursDesc => '完成24小时断食';

  @override
  String get achievement25Fasts => '断食爱好者';

  @override
  String get achievement25FastsDesc => '完成25次断食';

  @override
  String get achievement100Hours => '百小时俱乐部';

  @override
  String get achievement100HoursDesc => '累计断食100小时';

  @override
  String get achievement500Hours => '500小时英雄';

  @override
  String get achievement500HoursDesc => '累计断食500小时';

  @override
  String get achievementStreak14 => '双周冠军';

  @override
  String get achievementStreak14Desc => '保持14天连续断食';

  @override
  String get achievementKetosis => '酮症达成者';

  @override
  String get achievementKetosisDesc => '达到酮症阶段（18+小时）';

  @override
  String get achievementAutophagy => '自噬达成者';

  @override
  String get achievementAutophagyDesc => '达到自噬阶段（48+小时）';

  @override
  String get achievementEarlyBird => '早起鸟';

  @override
  String get achievementEarlyBirdDesc => '早上8点前开始断食';

  @override
  String get achievementNightOwl => '夜猫子';

  @override
  String get achievementNightOwlDesc => '晚上10点后完成断食';

  @override
  String get achievementWeekend => '周末勇士';

  @override
  String get achievementWeekendDesc => '在周末完成断食';

  @override
  String get achievementPerfectWeek => '完美一周';

  @override
  String get achievementPerfectWeekDesc => '一周内完成7次断食';

  @override
  String get colorTheme => '颜色主题';

  @override
  String get themeForest => '森林';

  @override
  String get themeOcean => '海洋';

  @override
  String get themeSunset => '日落';

  @override
  String get themeLavender => '薰衣草';

  @override
  String get themeMidnight => '午夜';

  @override
  String get themeRose => '玫瑰';

  @override
  String get themeMint => '薄荷';

  @override
  String get themeAmber => '琥珀';

  @override
  String get noFastingHistory => '暂无断食记录';

  @override
  String get startFirstFast => '开始您的第一次断食以查看进度';

  @override
  String get fastingHistory => '断食历史';

  @override
  String get totalFastingTime => '总断食时间';

  @override
  String get averageFastDuration => '平均时长';

  @override
  String get longestFast => '最长断食';

  @override
  String hours(int count) {
    return '$count小时';
  }

  @override
  String minutes(int count) {
    return '$count分钟';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hours小时$minutes分钟';
  }

  @override
  String get completed => '已完成';

  @override
  String get cancelled => '已取消';

  @override
  String get inProgress => '进行中';

  @override
  String get appearance => '外观';

  @override
  String get language => '语言';

  @override
  String get languageDefault => '系统默认';

  @override
  String get notifications => '通知';

  @override
  String get enableReminders => '启用提醒';

  @override
  String get reminderTime => '提醒时间';

  @override
  String get notificationGoalReachedTitle => '目标达成！🎉';

  @override
  String get notificationGoalReachedBody => '您已成功达到断食目标！';

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get termsOfService => '服务条款';

  @override
  String get rateApp => '评价应用';

  @override
  String get shareApp => '分享应用';

  @override
  String get healthInfoTitle => '间歇性断食';

  @override
  String get healthInfoSubtitle => '基于科学的信息';

  @override
  String get benefitsTitle => '健康益处';

  @override
  String get warningsTitle => '警告与注意事项';

  @override
  String get tipsTitle => '成功秘诀';

  @override
  String get sources => '来源';

  @override
  String get disclaimer => '本应用仅供参考。在开始任何断食计划之前，请务必咨询医疗专业人员。';

  @override
  String get benefitWeightTitle => '体重管理';

  @override
  String get benefitWeightDesc => '间歇性断食通过限制热量摄入和促进新陈代谢，有助于减轻体重和体脂。';

  @override
  String get benefitBloodPressureTitle => '血压';

  @override
  String get benefitBloodPressureDesc => '研究表明，断食可能有助于降低血压并改善静息心率。';

  @override
  String get benefitHeartHealthTitle => '心脏健康';

  @override
  String get benefitHeartHealthDesc => '断食可以改善心血管健康指标，包括胆固醇水平和炎症标志物。';

  @override
  String get benefitDiabetesTitle => '血糖控制';

  @override
  String get benefitDiabetesDesc => '间歇性断食可能改善胰岛素敏感性并有助于管理2型糖尿病。';

  @override
  String get benefitCognitiveTitle => '脑功能';

  @override
  String get benefitCognitiveDesc => '断食刺激BDNF的产生，这是一种支持脑健康和认知功能的蛋白质。';

  @override
  String get benefitTissueTitle => '组织健康';

  @override
  String get benefitTissueDesc => '断食触发细胞修复过程，可能改善组织健康和恢复。';

  @override
  String get benefitMetabolicTitle => '代谢转换';

  @override
  String get benefitMetabolicDesc => '12-36小时后，您的身体从葡萄糖转向酮体供能，提高代谢灵活性。';

  @override
  String get benefitCellularTitle => '细胞修复';

  @override
  String get benefitCellularDesc => '断食启动自噬，这是细胞清除受损成分并再生的过程。';

  @override
  String get warningChildrenTitle => '儿童与青少年';

  @override
  String get warningChildrenDesc => '不建议仍在成长中的儿童或青少年进行间歇性断食。';

  @override
  String get warningPregnantTitle => '怀孕';

  @override
  String get warningPregnantDesc => '怀孕期间不要断食，因为这可能影响胎儿发育。';

  @override
  String get warningBreastfeedingTitle => '哺乳期';

  @override
  String get warningBreastfeedingDesc => '哺乳期断食可能减少奶量和营养质量。';

  @override
  String get warningType1DiabetesTitle => '1型糖尿病';

  @override
  String get warningType1DiabetesDesc => '1型糖尿病患者因低血糖风险，不应在无医疗监督下断食。';

  @override
  String get warningEatingDisordersTitle => '饮食障碍';

  @override
  String get warningEatingDisordersDesc => '断食可能触发或加重饮食障碍。如有相关病史，请寻求专业帮助。';

  @override
  String get warningMuscleLossTitle => '肌肉流失风险';

  @override
  String get warningMuscleLossDesc => '长时间断食可能导致肌肉流失。进食窗口期请保持蛋白质摄入。';

  @override
  String get warningConsultDoctorTitle => '咨询您的医生';

  @override
  String get warningConsultDoctorDesc => '在开始断食前请务必咨询医疗专业人员，特别是如果您有健康问题。';

  @override
  String get tipHydrationTitle => '保持水分';

  @override
  String get tipHydrationDesc => '断食期间多喝水、草本茶或黑咖啡。适当的水分补充很重要。';

  @override
  String get tipGradualStartTitle => '循序渐进';

  @override
  String get tipGradualStartDesc => '从较短的断食时间（12:12）开始，随着身体适应逐渐增加。';

  @override
  String get tipBalancedMealsTitle => '均衡饮食';

  @override
  String get tipBalancedMealsDesc => '进食窗口期注重营养丰富的全食物。包含蛋白质、健康脂肪和蔬菜。';

  @override
  String get tipExerciseTitle => '轻度运动';

  @override
  String get tipExerciseDesc => '断食期间可以进行轻度到中度运动。在适应之前避免剧烈运动。';
}
