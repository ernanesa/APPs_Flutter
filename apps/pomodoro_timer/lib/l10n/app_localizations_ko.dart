// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '뽀모도로 타이머';

  @override
  String get focusSession => '포커스 세션';

  @override
  String get shortBreak => '짧은 휴식';

  @override
  String get longBreak => '긴 휴식';

  @override
  String get start => '시작';

  @override
  String get pause => '정지시키다';

  @override
  String get resume => '재개하다';

  @override
  String get reset => '다시 놓기';

  @override
  String get skip => '건너뛰다';

  @override
  String get sessions => '세션';

  @override
  String get sessionsCompleted => '완료된 세션';

  @override
  String get totalFocusTime => '총 집중 시간';

  @override
  String get todayStats => '오늘의 통계';

  @override
  String get weeklyStats => '주간 통계';

  @override
  String get settings => '설정';

  @override
  String get focusDuration => '집중 기간';

  @override
  String get shortBreakDuration => '짧은 휴식 시간';

  @override
  String get longBreakDuration => '긴 휴식 시간';

  @override
  String get sessionsUntilLongBreak => '긴 휴식 시간까지의 세션';

  @override
  String get soundEnabled => '소리 활성화';

  @override
  String get vibrationEnabled => '진동 활성화';

  @override
  String get autoStartBreaks => '자동 시작 휴식 시간';

  @override
  String get autoStartFocus => '자동 시작 초점';

  @override
  String get notifications => '알림';

  @override
  String get minutes => '분';

  @override
  String get min => '분';

  @override
  String get hours => '시간';

  @override
  String get history => '역사';

  @override
  String get statistics => '통계';

  @override
  String get timer => '시간제 노동자';

  @override
  String get keepFocused => '계속 집중하세요!';

  @override
  String get timeForBreak => '휴식 시간입니다!';

  @override
  String get breakOver => '휴식은 끝났습니다!';

  @override
  String get greatJob => '훌륭해요!';

  @override
  String get sessionComplete => '세션 완료';

  @override
  String get ready => '준비가 된';

  @override
  String get focusMode => '초점 모드';

  @override
  String get breakMode => '휴식 모드';

  @override
  String get darkMode => '다크 모드';

  @override
  String get language => '언어';

  @override
  String get about => '에 대한';

  @override
  String get version => '버전';

  @override
  String get privacyPolicy => '개인 정보 보호 정책';

  @override
  String get rateApp => '앱 평가';

  @override
  String get noSessionsYet => '아직 세션이 없습니다. 첫 번째 Pomodoro를 시작하세요!';

  @override
  String get pomodoroTechnique =>
      '뽀모도로 기법은 작업을 전통적으로 25분 길이로 짧은 휴식 시간으로 구분하여 집중하는 데 도움이 됩니다.';

  @override
  String get getStarted => '시작하기';

  @override
  String get letsGo => '갑시다!';

  @override
  String get streakDays => '하루 연속';

  @override
  String get currentStreak => '현재 연속';

  @override
  String get bestStreak => '최고의 연속';

  @override
  String get days => '날';

  @override
  String get achievements => '업적';

  @override
  String get achievementUnlocked => '업적 잠금 해제!';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked/$total잠금 해제됨';
  }

  @override
  String get notUnlockedYet => '아직 잠금 해제되지 않음';

  @override
  String unlockedOn(String date) {
    return '잠금 해제 날짜$date';
  }

  @override
  String get close => '닫다';

  @override
  String get categorySession => '세션';

  @override
  String get categoryStreak => '줄';

  @override
  String get categoryTime => '집중 시간';

  @override
  String get categorySpecial => '특별한';

  @override
  String get achievementFirstSession => '첫 번째 단계';

  @override
  String get achievementFirstSessionDesc => '첫 번째 집중 세션을 완료하세요';

  @override
  String get achievementSessions10 => '시작하기';

  @override
  String get achievementSessions10Desc => '집중 세션 10개 완료';

  @override
  String get achievementSessions50 => '헌신적인';

  @override
  String get achievementSessions50Desc => '집중 세션 50개 완료';

  @override
  String get achievementSessions100 => '백부장';

  @override
  String get achievementSessions100Desc => '집중 세션 100개 완료';

  @override
  String get achievementSessions500 => '그랜드마스터';

  @override
  String get achievementSessions500Desc => '집중 세션 500개 완료';

  @override
  String get achievementStreak3 => '해트트릭';

  @override
  String get achievementStreak3Desc => '3일 연속 유지';

  @override
  String get achievementStreak7 => '주간 전사';

  @override
  String get achievementStreak7Desc => '7일 연속 유지';

  @override
  String get achievementStreak30 => '월간 챔피언';

  @override
  String get achievementStreak30Desc => '30일 연속 유지';

  @override
  String get achievementTime1h => '첫 시간';

  @override
  String get achievementTime1hDesc => '집중시간 1시간 누적';

  @override
  String get achievementTime10h => '시간 투자자';

  @override
  String get achievementTime10hDesc => '집중시간 10시간 누적';

  @override
  String get achievementTime100h => '타임 마스터';

  @override
  String get achievementTime100hDesc => '집중시간 100시간 누적';

  @override
  String get achievementEarlyBird => '얼리버드';

  @override
  String get achievementEarlyBirdDesc => '오전 7시 이전에 세션을 완료하세요.';

  @override
  String get achievementNightOwl => '올빼미';

  @override
  String get achievementNightOwlDesc => '오후 10시 이후 세션 완료';

  @override
  String get achievementWeekendWarrior => '주말 전사';

  @override
  String get achievementWeekendWarriorDesc => '주말에 5개 세션을 완료하세요.';

  @override
  String get ambientSounds => '주변 소리';

  @override
  String get soundSilence => '고요';

  @override
  String get soundRain => '비';

  @override
  String get soundForest => '숲';

  @override
  String get soundOcean => '대양';

  @override
  String get soundCafe => '카페';

  @override
  String get soundFireplace => '난로';

  @override
  String get soundWhiteNoise => '백색 잡음';

  @override
  String get soundThunder => '우뢰';

  @override
  String get colorTheme => '색상 테마';

  @override
  String get themeTomato => '토마토';

  @override
  String get themeOcean => '대양';

  @override
  String get themeForest => '숲';

  @override
  String get themeLavender => '라벤더';

  @override
  String get themeSunset => '일몰';

  @override
  String get themeMidnight => '자정';

  @override
  String get themeRose => '장미';

  @override
  String get themeMint => '박하';

  @override
  String get dailyGoal => '일일 목표';

  @override
  String get dailyGoalTarget => '일일 목표 목표';

  @override
  String get goalReached => '목표 달성!';

  @override
  String sessionsProgress(int completed, int target) {
    return '$completed/$target세션';
  }

  @override
  String sessionsPerDay(int count) {
    return '$count일일 세션';
  }

  @override
  String focusTimeToday(int minutes) {
    return '$minutes오늘은 집중했어';
  }

  @override
  String get newQuote => '새로운 견적';

  @override
  String get quote1Text => '앞서가는 비결은 시작하는 것입니다.';

  @override
  String get quote1Author => '마크 트웨인';

  @override
  String get quote2Text => '바쁜 것보다 생산적인 일에 집중하세요.';

  @override
  String get quote2Author => '팀 페리스';

  @override
  String get quote3Text => '내가 너무 똑똑한 것이 아니라 문제에 더 오랫동안 머물러 있는 것뿐입니다.';

  @override
  String get quote3Author => '알베르트 아인슈타인';

  @override
  String get quote4Text => '시작하는 방법은 말을 멈추고 행동을 시작하는 것입니다.';

  @override
  String get quote4Author => '월트 디즈니';

  @override
  String get quote5Text => '시작하기 위해 위대할 필요는 없지만, 위대해지려면 시작해야 합니다.';

  @override
  String get quote5Author => '지그 지글러';

  @override
  String get quote6Text => '성공은 매일 반복되는 작은 노력의 합입니다.';

  @override
  String get quote6Author => '로버트 콜리어';

  @override
  String get quote7Text => '훌륭한 일을 하는 유일한 방법은 자신이 하는 일을 사랑하는 것입니다.';

  @override
  String get quote7Author => '스티브 잡스';

  @override
  String get quote8Text => '당면한 일에 모든 생각을 집중하십시오.';

  @override
  String get quote8Author => '알렉산더 그레이엄 벨';

  @override
  String get quote9Text => '시간은 우리가 가장 원하는 것이지만 가장 나쁘게 사용하는 것입니다.';

  @override
  String get quote9Author => '윌리엄 펜';

  @override
  String get quote10Text => '행동은 모든 성공의 기본 열쇠입니다.';

  @override
  String get quote10Author => '파블로 피카소';

  @override
  String get quote11Text => '시계를 보지 마십시오. 그것이하는 일을하십시오. 계속하세요.';

  @override
  String get quote11Author => '샘 레벤슨';

  @override
  String get quote12Text => '당신의 한계는 당신의 상상일 뿐입니다.';

  @override
  String get quote12Author => '알려지지 않은';

  @override
  String get quote13Text => '꿈을 꾸세요. 그것을 바란다. 하세요.';

  @override
  String get quote13Author => '알려지지 않은';

  @override
  String get quote14Text => '열심히 일할수록 행운이 찾아옵니다.';

  @override
  String get quote14Author => '게리 플레이어';

  @override
  String get quote15Text => '미래의 자신이 감사할 만한 일을 오늘 하세요.';

  @override
  String get quote15Author => '알려지지 않은';

  @override
  String get appearance => '모습';

  @override
  String get colorfulMode => '컬러풀 모드';

  @override
  String get colorfulModeDesc => '생생한 색상과 애니메이션 레이아웃을 사용하세요.';
}
