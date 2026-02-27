// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '番茄计时器';

  @override
  String get focusSession => '专注时间';

  @override
  String get shortBreak => '短休息';

  @override
  String get longBreak => '长休息';

  @override
  String get start => '开始';

  @override
  String get pause => '暂停';

  @override
  String get resume => '继续';

  @override
  String get reset => '重置';

  @override
  String get skip => '跳过';

  @override
  String get sessions => '次数';

  @override
  String get sessionsCompleted => '完成次数';

  @override
  String get totalFocusTime => '总专注时间';

  @override
  String get todayStats => '今日统计';

  @override
  String get weeklyStats => '本周统计';

  @override
  String get settings => '设置';

  @override
  String get focusDuration => '专注时长';

  @override
  String get shortBreakDuration => '短休息时长';

  @override
  String get longBreakDuration => '长休息时长';

  @override
  String get sessionsUntilLongBreak => '长休息前的次数';

  @override
  String get soundEnabled => '声音开启';

  @override
  String get vibrationEnabled => '振动开启';

  @override
  String get autoStartBreaks => '自动开始休息';

  @override
  String get autoStartFocus => '自动开始专注';

  @override
  String get notifications => '通知';

  @override
  String get minutes => '分钟';

  @override
  String get min => '分';

  @override
  String get hours => '小时';

  @override
  String get history => '历史';

  @override
  String get statistics => '统计';

  @override
  String get timer => '计时器';

  @override
  String get keepFocused => '保持专注！';

  @override
  String get timeForBreak => '休息时间！';

  @override
  String get breakOver => '休息结束！';

  @override
  String get greatJob => '做得好！';

  @override
  String get sessionComplete => '完成一次';

  @override
  String get ready => '准备';

  @override
  String get focusMode => '专注模式';

  @override
  String get breakMode => '休息模式';

  @override
  String get darkMode => '深色模式';

  @override
  String get language => '语言';

  @override
  String get about => '关于';

  @override
  String get version => '版本';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get rateApp => '评分';

  @override
  String get noSessionsYet => '还没有记录。开始你的第一个番茄钟吧！';

  @override
  String get pomodoroTechnique =>
      '番茄工作法通过将工作分成时间段来帮助您集中注意力，传统上是25分钟的专注时间，中间穿插短暂休息。';

  @override
  String get getStarted => '开始';

  @override
  String get letsGo => '开始吧！';

  @override
  String get streakDays => '天连续';

  @override
  String get currentStreak => '当前连续';

  @override
  String get bestStreak => '最佳连续';

  @override
  String get days => '天';

  @override
  String get achievements => '成就';

  @override
  String get achievementUnlocked => '成就解锁！';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked/$total 已解锁';
  }

  @override
  String get notUnlockedYet => '尚未解锁';

  @override
  String unlockedOn(String date) {
    return '解锁于 $date';
  }

  @override
  String get close => '关闭';

  @override
  String get categorySession => '专注次数';

  @override
  String get categoryStreak => '连续天数';

  @override
  String get categoryTime => '专注时间';

  @override
  String get categorySpecial => '特殊成就';

  @override
  String get achievementFirstSession => '第一步';

  @override
  String get achievementFirstSessionDesc => '完成你的第一次专注';

  @override
  String get achievementSessions10 => '良好开端';

  @override
  String get achievementSessions10Desc => '完成10次专注';

  @override
  String get achievementSessions50 => '专注达人';

  @override
  String get achievementSessions50Desc => '完成50次专注';

  @override
  String get achievementSessions100 => '百人斩';

  @override
  String get achievementSessions100Desc => '完成100次专注';

  @override
  String get achievementSessions500 => '大师级';

  @override
  String get achievementSessions500Desc => '完成500次专注';

  @override
  String get achievementStreak3 => '三连胜';

  @override
  String get achievementStreak3Desc => '保持3天连续';

  @override
  String get achievementStreak7 => '周冠军';

  @override
  String get achievementStreak7Desc => '保持7天连续';

  @override
  String get achievementStreak30 => '月冠军';

  @override
  String get achievementStreak30Desc => '保持30天连续';

  @override
  String get achievementTime1h => '第一小时';

  @override
  String get achievementTime1hDesc => '累计1小时专注时间';

  @override
  String get achievementTime10h => '时间投资者';

  @override
  String get achievementTime10hDesc => '累计10小时专注时间';

  @override
  String get achievementTime100h => '时间大师';

  @override
  String get achievementTime100hDesc => '累计100小时专注时间';

  @override
  String get achievementEarlyBird => '早起鸟';

  @override
  String get achievementEarlyBirdDesc => '在早上7点前完成一次专注';

  @override
  String get achievementNightOwl => '夜猫子';

  @override
  String get achievementNightOwlDesc => '在晚上10点后完成一次专注';

  @override
  String get achievementWeekendWarrior => '周末战士';

  @override
  String get achievementWeekendWarriorDesc => '在周末完成5次专注';

  @override
  String get ambientSounds => '环境音';

  @override
  String get soundSilence => '静音';

  @override
  String get soundRain => '雨声';

  @override
  String get soundForest => '森林';

  @override
  String get soundOcean => '海浪';

  @override
  String get soundCafe => '咖啡馆';

  @override
  String get soundFireplace => '壁炉';

  @override
  String get soundWhiteNoise => '白噪音';

  @override
  String get soundThunder => '雷声';

  @override
  String get colorTheme => '颜色主题';

  @override
  String get themeTomato => '番茄红';

  @override
  String get themeOcean => '海洋蓝';

  @override
  String get themeForest => '森林绿';

  @override
  String get themeLavender => '薰衣草';

  @override
  String get themeSunset => '日落橙';

  @override
  String get themeMidnight => '午夜蓝';

  @override
  String get themeRose => '玫瑰粉';

  @override
  String get themeMint => '薄荷绿';

  @override
  String get dailyGoal => '每日目标';

  @override
  String get dailyGoalTarget => '每日目标';

  @override
  String get goalReached => '目标达成！';

  @override
  String sessionsProgress(int completed, int target) {
    return '$completed/$target 次';
  }

  @override
  String sessionsPerDay(int count) {
    return '每天 $count 次';
  }

  @override
  String focusTimeToday(int minutes) {
    return '今日已专注 $minutes 分钟';
  }

  @override
  String get newQuote => '新语录';

  @override
  String get quote1Text => '开始行动是成功的秘诀。';

  @override
  String get quote1Author => '马克·吐温';

  @override
  String get quote2Text => '专注于高效，而非忙碌。';

  @override
  String get quote2Author => '蒂姆·费里斯';

  @override
  String get quote3Text => '不是我聪明，而是我与问题相处的时间更长。';

  @override
  String get quote3Author => '阿尔伯特·爱因斯坦';

  @override
  String get quote4Text => '开始的方法就是停止空谈，开始行动。';

  @override
  String get quote4Author => '沃尔特·迪士尼';

  @override
  String get quote5Text => '你不必很厉害才能开始，但你必须开始才能变得厉害。';

  @override
  String get quote5Author => '齐格·金克拉';

  @override
  String get quote6Text => '成功是每天重复的小努力的总和。';

  @override
  String get quote6Author => '罗伯特·科利尔';

  @override
  String get quote7Text => '做伟大工作的唯一方法就是热爱你所做的事。';

  @override
  String get quote7Author => '史蒂夫·乔布斯';

  @override
  String get quote8Text => '将所有思想集中在手头的工作上。';

  @override
  String get quote8Author => '亚历山大·格雷厄姆·贝尔';

  @override
  String get quote9Text => '时间是我们最想要的，却是我们用得最差的。';

  @override
  String get quote9Author => '威廉·佩恩';

  @override
  String get quote10Text => '行动是所有成功的基础。';

  @override
  String get quote10Author => '巴勃罗·毕加索';

  @override
  String get quote11Text => '不要看时钟；做它做的事。继续前进。';

  @override
  String get quote11Author => '山姆·莱文森';

  @override
  String get quote12Text => '你的限制只是你的想象。';

  @override
  String get quote12Author => '佚名';

  @override
  String get quote13Text => '梦想它。渴望它。实现它。';

  @override
  String get quote13Author => '佚名';

  @override
  String get quote14Text => '你越努力，你就越幸运。';

  @override
  String get quote14Author => '加里·普莱耶';

  @override
  String get quote15Text => '今天做一些你未来的自己会感谢的事。';

  @override
  String get quote15Author => '佚名';

  @override
  String get appearance => '外观';

  @override
  String get colorfulMode => '多彩模式';

  @override
  String get colorfulModeDesc => '使用鲜艳的颜色和动画布局';
}
