import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ポモドーロタイマー';

  @override
  String get focusSession => '集中セッション';

  @override
  String get shortBreak => '短い休憩';

  @override
  String get longBreak => '長い休憩';

  @override
  String get start => '開始';

  @override
  String get pause => '一時停止';

  @override
  String get resume => '再開';

  @override
  String get reset => 'リセット';

  @override
  String get skip => 'スキップ';

  @override
  String get sessions => 'セッション';

  @override
  String get sessionsCompleted => '完了したセッション';

  @override
  String get totalFocusTime => '合計集中時間';

  @override
  String get todayStats => '今日の統計';

  @override
  String get weeklyStats => '週間統計';

  @override
  String get settings => '設定';

  @override
  String get focusDuration => '集中時間';

  @override
  String get shortBreakDuration => '短い休憩時間';

  @override
  String get longBreakDuration => '長い休憩時間';

  @override
  String get sessionsUntilLongBreak => '長い休憩までのセッション数';

  @override
  String get soundEnabled => 'サウンド有効';

  @override
  String get vibrationEnabled => 'バイブレーション有効';

  @override
  String get autoStartBreaks => '休憩を自動開始';

  @override
  String get autoStartFocus => '集中を自動開始';

  @override
  String get notifications => '通知';

  @override
  String get minutes => '分';

  @override
  String get min => '分';

  @override
  String get hours => '時間';

  @override
  String get history => '履歴';

  @override
  String get statistics => '統計';

  @override
  String get timer => 'タイマー';

  @override
  String get keepFocused => '集中を維持！';

  @override
  String get timeForBreak => '休憩の時間！';

  @override
  String get breakOver => '休憩終了！';

  @override
  String get greatJob => 'よくできました！';

  @override
  String get sessionComplete => 'セッション完了';

  @override
  String get ready => '準備完了';

  @override
  String get focusMode => '集中モード';

  @override
  String get breakMode => '休憩モード';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get language => '言語';

  @override
  String get about => '情報';

  @override
  String get version => 'バージョン';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get rateApp => 'アプリを評価';

  @override
  String get noSessionsYet => 'まだセッションがありません。最初のポモドーロを始めましょう！';

  @override
  String get pomodoroTechnique => 'ポモドーロ・テクニックは、作業を25分間隔に分割し、短い休憩を挟むことで集中力を高めます。';

  @override
  String get getStarted => '始める';

  @override
  String get letsGo => 'さあ始めよう！';

  @override
  String get streakDays => '日連続';

  @override
  String get currentStreak => '現在の連続日数';

  @override
  String get bestStreak => '最高の連続日数';

  @override
  String get days => '日';

  @override
  String get achievements => '実績';

  @override
  String get achievementUnlocked => '実績解除！';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked/$total 解除済み';
  }

  @override
  String get notUnlockedYet => 'まだ解除されていません';

  @override
  String unlockedOn(String date) {
    return '$dateに解除';
  }

  @override
  String get close => '閉じる';

  @override
  String get categorySession => 'セッション';

  @override
  String get categoryStreak => '連続日数';

  @override
  String get categoryTime => '集中時間';

  @override
  String get categorySpecial => '特別';

  @override
  String get achievementFirstSession => '最初の一歩';

  @override
  String get achievementFirstSessionDesc => '最初の集中セッションを完了する';

  @override
  String get achievementSessions10 => '良いスタート';

  @override
  String get achievementSessions10Desc => '10回の集中セッションを完了する';

  @override
  String get achievementSessions50 => '献身的';

  @override
  String get achievementSessions50Desc => '50回の集中セッションを完了する';

  @override
  String get achievementSessions100 => 'センチュリオン';

  @override
  String get achievementSessions100Desc => '100回の集中セッションを完了する';

  @override
  String get achievementSessions500 => 'グランドマスター';

  @override
  String get achievementSessions500Desc => '500回の集中セッションを完了する';

  @override
  String get achievementStreak3 => 'ハットトリック';

  @override
  String get achievementStreak3Desc => '3日連続を達成する';

  @override
  String get achievementStreak7 => '週間ウォリアー';

  @override
  String get achievementStreak7Desc => '7日連続を達成する';

  @override
  String get achievementStreak30 => '月間チャンピオン';

  @override
  String get achievementStreak30Desc => '30日連続を達成する';

  @override
  String get achievementTime1h => '最初の1時間';

  @override
  String get achievementTime1hDesc => '累計1時間の集中時間を達成する';

  @override
  String get achievementTime10h => 'タイムインベスター';

  @override
  String get achievementTime10hDesc => '累計10時間の集中時間を達成する';

  @override
  String get achievementTime100h => 'タイムマスター';

  @override
  String get achievementTime100hDesc => '累計100時間の集中時間を達成する';

  @override
  String get achievementEarlyBird => '早起き鳥';

  @override
  String get achievementEarlyBirdDesc => '午前7時前にセッションを完了する';

  @override
  String get achievementNightOwl => '夜更かしフクロウ';

  @override
  String get achievementNightOwlDesc => '午後10時以降にセッションを完了する';

  @override
  String get achievementWeekendWarrior => '週末ウォリアー';

  @override
  String get achievementWeekendWarriorDesc => '週末に5回のセッションを完了する';

  @override
  String get ambientSounds => '環境音';

  @override
  String get soundSilence => '無音';

  @override
  String get soundRain => '雨';

  @override
  String get soundForest => '森';

  @override
  String get soundOcean => '海';

  @override
  String get soundCafe => 'カフェ';

  @override
  String get soundFireplace => '暖炉';

  @override
  String get soundWhiteNoise => 'ホワイトノイズ';

  @override
  String get soundThunder => '雷';

  @override
  String get colorTheme => 'カラーテーマ';

  @override
  String get themeTomato => 'トマト';

  @override
  String get themeOcean => 'オーシャン';

  @override
  String get themeForest => 'フォレスト';

  @override
  String get themeLavender => 'ラベンダー';

  @override
  String get themeSunset => 'サンセット';

  @override
  String get themeMidnight => 'ミッドナイト';

  @override
  String get themeRose => 'ローズ';

  @override
  String get themeMint => 'ミント';

  @override
  String get dailyGoal => 'デイリーゴール';

  @override
  String get dailyGoalTarget => '1日の目標';

  @override
  String get goalReached => '目標達成！';

  @override
  String sessionsProgress(int completed, int target) {
    return '$completed/$target セッション';
  }

  @override
  String sessionsPerDay(int count) {
    return '1日$countセッション';
  }

  @override
  String focusTimeToday(int minutes) {
    return '今日$minutes分集中';
  }

  @override
  String get newQuote => '新しい名言';

  @override
  String get quote1Text => '前進する秘訣は始めることだ。';

  @override
  String get quote1Author => 'マーク・トウェイン';

  @override
  String get quote2Text => '忙しくなるのではなく、生産的になることに集中せよ。';

  @override
  String get quote2Author => 'ティム・フェリス';

  @override
  String get quote3Text => '私はそれほど賢くない。ただ問題と長く向き合っているだけだ。';

  @override
  String get quote3Author => 'アルベルト・アインシュタイン';

  @override
  String get quote4Text => '始めるための方法は、話すのをやめて行動することだ。';

  @override
  String get quote4Author => 'ウォルト・ディズニー';

  @override
  String get quote5Text => '始めるのに偉大である必要はないが、偉大になるには始めなければならない。';

  @override
  String get quote5Author => 'ジグ・ジグラー';

  @override
  String get quote6Text => '成功とは、日々繰り返される小さな努力の積み重ねである。';

  @override
  String get quote6Author => 'ロバート・コリアー';

  @override
  String get quote7Text => '素晴らしい仕事をする唯一の方法は、自分のしていることを愛することだ。';

  @override
  String get quote7Author => 'スティーブ・ジョブズ';

  @override
  String get quote8Text => 'すべての思考を目の前の仕事に集中させよ。';

  @override
  String get quote8Author => 'アレクサンダー・グラハム・ベル';

  @override
  String get quote9Text => '時間は最も欲しいものだが、最も下手に使うものだ。';

  @override
  String get quote9Author => 'ウィリアム・ペン';

  @override
  String get quote10Text => '行動はすべての成功の基本的な鍵である。';

  @override
  String get quote10Author => 'パブロ・ピカソ';

  @override
  String get quote11Text => '時計を見るな。時計がすることをせよ。進み続けろ。';

  @override
  String get quote11Author => 'サム・レベンソン';

  @override
  String get quote12Text => 'あなたの限界は想像力だけだ。';

  @override
  String get quote12Author => '作者不明';

  @override
  String get quote13Text => '夢見よ。願え。実行せよ。';

  @override
  String get quote13Author => '作者不明';

  @override
  String get quote14Text => '努力すればするほど、幸運になる。';

  @override
  String get quote14Author => 'ゲーリー・プレーヤー';

  @override
  String get quote15Text => '未来の自分が感謝することを今日やれ。';

  @override
  String get quote15Author => '作者不明';

  @override
  String get appearance => '外観';

  @override
  String get colorfulMode => 'カラフルモード';

  @override
  String get colorfulModeDesc => '鮮やかな色とアニメーションレイアウトを使用';
}
