import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'مؤقت بومودورو';

  @override
  String get focusSession => 'جلسة تركيز';

  @override
  String get shortBreak => 'استراحة قصيرة';

  @override
  String get longBreak => 'استراحة طويلة';

  @override
  String get start => 'ابدأ';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get resume => 'استئناف';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get skip => 'تخطي';

  @override
  String get sessions => 'جلسات';

  @override
  String get sessionsCompleted => 'الجلسات المكتملة';

  @override
  String get totalFocusTime => 'إجمالي وقت التركيز';

  @override
  String get todayStats => 'إحصائيات اليوم';

  @override
  String get weeklyStats => 'إحصائيات الأسبوع';

  @override
  String get settings => 'الإعدادات';

  @override
  String get focusDuration => 'مدة التركيز';

  @override
  String get shortBreakDuration => 'مدة الاستراحة القصيرة';

  @override
  String get longBreakDuration => 'مدة الاستراحة الطويلة';

  @override
  String get sessionsUntilLongBreak => 'الجلسات حتى الاستراحة الطويلة';

  @override
  String get soundEnabled => 'الصوت مفعل';

  @override
  String get vibrationEnabled => 'الاهتزاز مفعل';

  @override
  String get autoStartBreaks => 'بدء الاستراحات تلقائياً';

  @override
  String get autoStartFocus => 'بدء التركيز تلقائياً';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get minutes => 'دقائق';

  @override
  String get min => 'د';

  @override
  String get hours => 'ساعات';

  @override
  String get history => 'السجل';

  @override
  String get statistics => 'الإحصائيات';

  @override
  String get timer => 'المؤقت';

  @override
  String get keepFocused => 'ابقَ مركزاً!';

  @override
  String get timeForBreak => 'وقت الاستراحة!';

  @override
  String get breakOver => 'انتهت الاستراحة!';

  @override
  String get greatJob => 'عمل رائع!';

  @override
  String get sessionComplete => 'اكتملت الجلسة';

  @override
  String get ready => 'جاهز';

  @override
  String get focusMode => 'وضع التركيز';

  @override
  String get breakMode => 'وضع الاستراحة';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get language => 'اللغة';

  @override
  String get about => 'حول';

  @override
  String get version => 'الإصدار';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get rateApp => 'قيّم التطبيق';

  @override
  String get noSessionsYet => 'لا توجد جلسات بعد. ابدأ بومودورو الأول!';

  @override
  String get pomodoroTechnique => 'تساعدك تقنية بومودورو على التركيز عن طريق تقسيم العمل إلى فترات، عادةً 25 دقيقة، تفصلها استراحات قصيرة.';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get letsGo => 'هيا بنا!';

  @override
  String get streakDays => 'أيام متتالية';

  @override
  String get currentStreak => 'السلسلة الحالية';

  @override
  String get bestStreak => 'أفضل سلسلة';

  @override
  String get days => 'أيام';

  @override
  String get achievements => 'الإنجازات';

  @override
  String get achievementUnlocked => 'تم فتح الإنجاز!';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked/$total مفتوحة';
  }

  @override
  String get notUnlockedYet => 'لم يفتح بعد';

  @override
  String unlockedOn(String date) {
    return 'فتح في $date';
  }

  @override
  String get close => 'إغلاق';

  @override
  String get categorySession => 'الجلسات';

  @override
  String get categoryStreak => 'السلسلة';

  @override
  String get categoryTime => 'وقت التركيز';

  @override
  String get categorySpecial => 'خاص';

  @override
  String get achievementFirstSession => 'الخطوة الأولى';

  @override
  String get achievementFirstSessionDesc => 'أكمل أول جلسة تركيز';

  @override
  String get achievementSessions10 => 'بداية جيدة';

  @override
  String get achievementSessions10Desc => 'أكمل 10 جلسات تركيز';

  @override
  String get achievementSessions50 => 'مخلص';

  @override
  String get achievementSessions50Desc => 'أكمل 50 جلسة تركيز';

  @override
  String get achievementSessions100 => 'المئوي';

  @override
  String get achievementSessions100Desc => 'أكمل 100 جلسة تركيز';

  @override
  String get achievementSessions500 => 'الأستاذ الكبير';

  @override
  String get achievementSessions500Desc => 'أكمل 500 جلسة تركيز';

  @override
  String get achievementStreak3 => 'هاتريك';

  @override
  String get achievementStreak3Desc => 'حافظ على سلسلة 3 أيام';

  @override
  String get achievementStreak7 => 'محارب الأسبوع';

  @override
  String get achievementStreak7Desc => 'حافظ على سلسلة 7 أيام';

  @override
  String get achievementStreak30 => 'بطل الشهر';

  @override
  String get achievementStreak30Desc => 'حافظ على سلسلة 30 يوم';

  @override
  String get achievementTime1h => 'الساعة الأولى';

  @override
  String get achievementTime1hDesc => 'اجمع ساعة واحدة من وقت التركيز';

  @override
  String get achievementTime10h => 'مستثمر الوقت';

  @override
  String get achievementTime10hDesc => 'اجمع 10 ساعات من وقت التركيز';

  @override
  String get achievementTime100h => 'سيد الوقت';

  @override
  String get achievementTime100hDesc => 'اجمع 100 ساعة من وقت التركيز';

  @override
  String get achievementEarlyBird => 'العصفور المبكر';

  @override
  String get achievementEarlyBirdDesc => 'أكمل جلسة قبل الساعة 7 صباحاً';

  @override
  String get achievementNightOwl => 'بومة الليل';

  @override
  String get achievementNightOwlDesc => 'أكمل جلسة بعد الساعة 10 مساءً';

  @override
  String get achievementWeekendWarrior => 'محارب نهاية الأسبوع';

  @override
  String get achievementWeekendWarriorDesc => 'أكمل 5 جلسات في عطلة نهاية الأسبوع';

  @override
  String get ambientSounds => 'أصوات محيطة';

  @override
  String get soundSilence => 'صمت';

  @override
  String get soundRain => 'مطر';

  @override
  String get soundForest => 'غابة';

  @override
  String get soundOcean => 'محيط';

  @override
  String get soundCafe => 'مقهى';

  @override
  String get soundFireplace => 'مدفأة';

  @override
  String get soundWhiteNoise => 'ضوضاء بيضاء';

  @override
  String get soundThunder => 'رعد';

  @override
  String get colorTheme => 'لون السمة';

  @override
  String get themeTomato => 'طماطم';

  @override
  String get themeOcean => 'محيط';

  @override
  String get themeForest => 'غابة';

  @override
  String get themeLavender => 'لافندر';

  @override
  String get themeSunset => 'غروب';

  @override
  String get themeMidnight => 'منتصف الليل';

  @override
  String get themeRose => 'وردي';

  @override
  String get themeMint => 'نعناع';

  @override
  String get dailyGoal => 'الهدف اليومي';

  @override
  String get dailyGoalTarget => 'الهدف اليومي';

  @override
  String get goalReached => 'تم تحقيق الهدف!';

  @override
  String sessionsProgress(int completed, int target) {
    return '$completed/$target جلسات';
  }

  @override
  String sessionsPerDay(int count) {
    return '$count جلسات يومياً';
  }

  @override
  String focusTimeToday(int minutes) {
    return '$minutes دقيقة تركيز اليوم';
  }

  @override
  String get newQuote => 'اقتباس جديد';

  @override
  String get quote1Text => 'سر التقدم هو البدء.';

  @override
  String get quote1Author => 'مارك توين';

  @override
  String get quote2Text => 'ركز على أن تكون منتجاً لا مشغولاً.';

  @override
  String get quote2Author => 'تيم فيريس';

  @override
  String get quote3Text => 'ليس لأنني ذكي جداً، بل لأنني أبقى مع المشاكل لفترة أطول.';

  @override
  String get quote3Author => 'ألبرت أينشتاين';

  @override
  String get quote4Text => 'طريقة البدء هي التوقف عن الكلام والبدء في العمل.';

  @override
  String get quote4Author => 'والت ديزني';

  @override
  String get quote5Text => 'لا يجب أن تكون عظيماً لتبدأ، لكن يجب أن تبدأ لتصبح عظيماً.';

  @override
  String get quote5Author => 'زيج زيجلار';

  @override
  String get quote6Text => 'النجاح هو مجموع الجهود الصغيرة المتكررة يوماً بعد يوم.';

  @override
  String get quote6Author => 'روبرت كوليير';

  @override
  String get quote7Text => 'الطريقة الوحيدة للقيام بعمل رائع هي أن تحب ما تفعله.';

  @override
  String get quote7Author => 'ستيف جوبز';

  @override
  String get quote8Text => 'ركز كل أفكارك على العمل الذي بين يديك.';

  @override
  String get quote8Author => 'ألكسندر غراهام بيل';

  @override
  String get quote9Text => 'الوقت هو ما نريده أكثر، لكننا نستخدمه بأسوأ طريقة.';

  @override
  String get quote9Author => 'ويليام بن';

  @override
  String get quote10Text => 'العمل هو المفتاح الأساسي لكل نجاح.';

  @override
  String get quote10Author => 'بابلو بيكاسو';

  @override
  String get quote11Text => 'لا تنظر إلى الساعة؛ افعل ما تفعله. استمر.';

  @override
  String get quote11Author => 'سام ليفنسون';

  @override
  String get quote12Text => 'قيودك هي مجرد خيالك.';

  @override
  String get quote12Author => 'مجهول';

  @override
  String get quote13Text => 'احلم به. تمناه. افعله.';

  @override
  String get quote13Author => 'مجهول';

  @override
  String get quote14Text => 'كلما عملت بجد، زاد حظك.';

  @override
  String get quote14Author => 'جاري بلاير';

  @override
  String get quote15Text => 'افعل اليوم شيئاً سيشكرك عليه نفسك في المستقبل.';

  @override
  String get quote15Author => 'مجهول';
}
