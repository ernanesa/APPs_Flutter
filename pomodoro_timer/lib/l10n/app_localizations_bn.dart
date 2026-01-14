import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'পমোডোরো টাইমার';

  @override
  String get focusSession => 'ফোকাস সেশন';

  @override
  String get shortBreak => 'ছোট বিরতি';

  @override
  String get longBreak => 'দীর্ঘ বিরতি';

  @override
  String get start => 'শুরু';

  @override
  String get pause => 'বিরতি';

  @override
  String get resume => 'পুনরায় শুরু';

  @override
  String get reset => 'রিসেট';

  @override
  String get skip => 'স্কিপ';

  @override
  String get sessions => 'সেশন';

  @override
  String get sessionsCompleted => 'সম্পন্ন সেশন';

  @override
  String get totalFocusTime => 'মোট ফোকাস সময়';

  @override
  String get todayStats => 'আজকের পরিসংখ্যান';

  @override
  String get weeklyStats => 'সাপ্তাহিক পরিসংখ্যান';

  @override
  String get settings => 'সেটিংস';

  @override
  String get focusDuration => 'ফোকাস সময়কাল';

  @override
  String get shortBreakDuration => 'ছোট বিরতির সময়কাল';

  @override
  String get longBreakDuration => 'দীর্ঘ বিরতির সময়কাল';

  @override
  String get sessionsUntilLongBreak => 'দীর্ঘ বিরতি পর্যন্ত সেশন';

  @override
  String get soundEnabled => 'শব্দ সক্রিয়';

  @override
  String get vibrationEnabled => 'কম্পন সক্রিয়';

  @override
  String get autoStartBreaks => 'স্বয়ংক্রিয়ভাবে বিরতি শুরু';

  @override
  String get autoStartFocus => 'স্বয়ংক্রিয়ভাবে ফোকাস শুরু';

  @override
  String get notifications => 'বিজ্ঞপ্তি';

  @override
  String get minutes => 'মিনিট';

  @override
  String get min => 'মি';

  @override
  String get hours => 'ঘণ্টা';

  @override
  String get history => 'ইতিহাস';

  @override
  String get statistics => 'পরিসংখ্যান';

  @override
  String get timer => 'টাইমার';

  @override
  String get keepFocused => 'মনোযোগ রাখুন!';

  @override
  String get timeForBreak => 'বিরতির সময়!';

  @override
  String get breakOver => 'বিরতি শেষ!';

  @override
  String get greatJob => 'দারুণ কাজ!';

  @override
  String get sessionComplete => 'সেশন সম্পন্ন';

  @override
  String get ready => 'প্রস্তুত';

  @override
  String get focusMode => 'ফোকাস মোড';

  @override
  String get breakMode => 'বিরতি মোড';

  @override
  String get darkMode => 'ডার্ক মোড';

  @override
  String get language => 'ভাষা';

  @override
  String get about => 'সম্পর্কে';

  @override
  String get version => 'সংস্করণ';

  @override
  String get privacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get rateApp => 'অ্যাপ রেট করুন';

  @override
  String get noSessionsYet => 'এখনো কোনো সেশন নেই। আপনার প্রথম পমোডোরো শুরু করুন!';

  @override
  String get pomodoroTechnique => 'পমোডোরো কৌশল আপনাকে কাজকে ২৫ মিনিটের বিরতিতে ভাগ করে মনোযোগ দিতে সাহায্য করে, ছোট বিরতি দিয়ে আলাদা।';

  @override
  String get getStarted => 'শুরু করুন';

  @override
  String get letsGo => 'চলুন শুরু করি!';

  @override
  String get streakDays => 'দিন ধারাবাহিক';

  @override
  String get currentStreak => 'বর্তমান ধারা';

  @override
  String get bestStreak => 'সেরা ধারা';

  @override
  String get days => 'দিন';

  @override
  String get achievements => 'অর্জন';

  @override
  String get achievementUnlocked => 'অর্জন আনলক!';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked/$total আনলক';
  }

  @override
  String get notUnlockedYet => 'এখনো আনলক হয়নি';

  @override
  String unlockedOn(String date) {
    return '$date আনলক';
  }

  @override
  String get close => 'বন্ধ';

  @override
  String get categorySession => 'সেশন';

  @override
  String get categoryStreak => 'ধারা';

  @override
  String get categoryTime => 'ফোকাস সময়';

  @override
  String get categorySpecial => 'বিশেষ';

  @override
  String get achievementFirstSession => 'প্রথম পদক্ষেপ';

  @override
  String get achievementFirstSessionDesc => 'আপনার প্রথম ফোকাস সেশন সম্পন্ন করুন';

  @override
  String get achievementSessions10 => 'ভালো শুরু';

  @override
  String get achievementSessions10Desc => '১০টি ফোকাস সেশন সম্পন্ন করুন';

  @override
  String get achievementSessions50 => 'নিবেদিত';

  @override
  String get achievementSessions50Desc => '৫০টি ফোকাস সেশন সম্পন্ন করুন';

  @override
  String get achievementSessions100 => 'শতাব্দী';

  @override
  String get achievementSessions100Desc => '১০০টি ফোকাস সেশন সম্পন্ন করুন';

  @override
  String get achievementSessions500 => 'গ্র্যান্ডমাস্টার';

  @override
  String get achievementSessions500Desc => '৫০০টি ফোকাস সেশন সম্পন্ন করুন';

  @override
  String get achievementStreak3 => 'হ্যাট ট্রিক';

  @override
  String get achievementStreak3Desc => '৩ দিনের ধারা বজায় রাখুন';

  @override
  String get achievementStreak7 => 'সাপ্তাহিক যোদ্ধা';

  @override
  String get achievementStreak7Desc => '৭ দিনের ধারা বজায় রাখুন';

  @override
  String get achievementStreak30 => 'মাসিক চ্যাম্পিয়ন';

  @override
  String get achievementStreak30Desc => '৩০ দিনের ধারা বজায় রাখুন';

  @override
  String get achievementTime1h => 'প্রথম ঘণ্টা';

  @override
  String get achievementTime1hDesc => '১ ঘণ্টা ফোকাস সময় জমা করুন';

  @override
  String get achievementTime10h => 'সময় বিনিয়োগকারী';

  @override
  String get achievementTime10hDesc => '১০ ঘণ্টা ফোকাস সময় জমা করুন';

  @override
  String get achievementTime100h => 'সময়ের মাস্টার';

  @override
  String get achievementTime100hDesc => '১০০ ঘণ্টা ফোকাস সময় জমা করুন';

  @override
  String get achievementEarlyBird => 'প্রাতঃকালীন পাখি';

  @override
  String get achievementEarlyBirdDesc => 'সকাল ৭টার আগে একটি সেশন সম্পন্ন করুন';

  @override
  String get achievementNightOwl => 'রাতের পেঁচা';

  @override
  String get achievementNightOwlDesc => 'রাত ১০টার পরে একটি সেশন সম্পন্ন করুন';

  @override
  String get achievementWeekendWarrior => 'সপ্তাহান্তের যোদ্ধা';

  @override
  String get achievementWeekendWarriorDesc => 'সপ্তাহান্তে ৫টি সেশন সম্পন্ন করুন';

  @override
  String get ambientSounds => 'পরিবেশগত শব্দ';

  @override
  String get soundSilence => 'নীরবতা';

  @override
  String get soundRain => 'বৃষ্টি';

  @override
  String get soundForest => 'বন';

  @override
  String get soundOcean => 'সমুদ্র';

  @override
  String get soundCafe => 'ক্যাফে';

  @override
  String get soundFireplace => 'অগ্নিকুণ্ড';

  @override
  String get soundWhiteNoise => 'সাদা শব্দ';

  @override
  String get soundThunder => 'বজ্র';

  @override
  String get colorTheme => 'রঙের থিম';

  @override
  String get themeTomato => 'টমেটো';

  @override
  String get themeOcean => 'সমুদ্র';

  @override
  String get themeForest => 'বন';

  @override
  String get themeLavender => 'ল্যাভেন্ডার';

  @override
  String get themeSunset => 'সূর্যাস্ত';

  @override
  String get themeMidnight => 'মধ্যরাত';

  @override
  String get themeRose => 'গোলাপ';

  @override
  String get themeMint => 'পুদিনা';

  @override
  String get dailyGoal => 'দৈনিক লক্ষ্য';

  @override
  String get dailyGoalTarget => 'দৈনিক লক্ষ্য';

  @override
  String get goalReached => 'লক্ষ্য অর্জিত!';

  @override
  String sessionsProgress(int completed, int target) {
    return '$completed/$target সেশন';
  }

  @override
  String sessionsPerDay(int count) {
    return 'প্রতিদিন $count সেশন';
  }

  @override
  String focusTimeToday(int minutes) {
    return 'আজ $minutes মিনিট মনোযোগী';
  }

  @override
  String get newQuote => 'নতুন উদ্ধৃতি';

  @override
  String get quote1Text => 'এগিয়ে যাওয়ার রহস্য হলো শুরু করা।';

  @override
  String get quote1Author => 'মার্ক টোয়েন';

  @override
  String get quote2Text => 'ব্যস্ত নয়, উৎপাদনশীল হওয়ায় মনোযোগ দিন।';

  @override
  String get quote2Author => 'টিম ফেরিস';

  @override
  String get quote3Text => 'আমি এত বুদ্ধিমান নই, আমি শুধু সমস্যার সাথে বেশি সময় থাকি।';

  @override
  String get quote3Author => 'অ্যালবার্ট আইনস্টাইন';

  @override
  String get quote4Text => 'শুরু করার উপায় হলো কথা বলা বন্ধ করে কাজ শুরু করা।';

  @override
  String get quote4Author => 'ওয়াল্ট ডিজনি';

  @override
  String get quote5Text => 'শুরু করতে আপনাকে দারুণ হতে হবে না, কিন্তু দারুণ হতে হলে শুরু করতে হবে।';

  @override
  String get quote5Author => 'জিগ জিগলার';

  @override
  String get quote6Text => 'সাফল্য হলো প্রতিদিন পুনরাবৃত্ত ছোট প্রচেষ্টার সমষ্টি।';

  @override
  String get quote6Author => 'রবার্ট কলিয়ার';

  @override
  String get quote7Text => 'দারুণ কাজ করার একমাত্র উপায় হলো আপনি যা করেন তা ভালোবাসা।';

  @override
  String get quote7Author => 'স্টিভ জবস';

  @override
  String get quote8Text => 'হাতের কাজে আপনার সব চিন্তা কেন্দ্রীভূত করুন।';

  @override
  String get quote8Author => 'আলেকজান্ডার গ্রাহাম বেল';

  @override
  String get quote9Text => 'সময় হলো যা আমরা সবচেয়ে বেশি চাই, কিন্তু সবচেয়ে খারাপভাবে ব্যবহার করি।';

  @override
  String get quote9Author => 'উইলিয়াম পেন';

  @override
  String get quote10Text => 'কর্ম হলো সব সাফল্যের মৌলিক চাবি।';

  @override
  String get quote10Author => 'পাবলো পিকাসো';

  @override
  String get quote11Text => 'ঘড়ির দিকে তাকাবেন না; এটি যা করে তাই করুন। চালিয়ে যান।';

  @override
  String get quote11Author => 'স্যাম লেভেনসন';

  @override
  String get quote12Text => 'আপনার সীমাবদ্ধতা শুধু আপনার কল্পনা।';

  @override
  String get quote12Author => 'অজানা';

  @override
  String get quote13Text => 'স্বপ্ন দেখুন। চান। করুন।';

  @override
  String get quote13Author => 'অজানা';

  @override
  String get quote14Text => 'আপনি যত কঠোর পরিশ্রম করবেন, তত ভাগ্যবান হবেন।';

  @override
  String get quote14Author => 'গ্যারি প্লেয়ার';

  @override
  String get quote15Text => 'আজ এমন কিছু করুন যার জন্য আপনার ভবিষ্যৎ স্বত্তা আপনাকে ধন্যবাদ দেবে।';

  @override
  String get quote15Author => 'অজানা';
}
