import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'पोमोडोरो टाइमर';

  @override
  String get focusSession => 'फोकस सेशन';

  @override
  String get shortBreak => 'छोटा ब्रेक';

  @override
  String get longBreak => 'लंबा ब्रेक';

  @override
  String get start => 'शुरू';

  @override
  String get pause => 'रोकें';

  @override
  String get resume => 'जारी रखें';

  @override
  String get reset => 'रीसेट';

  @override
  String get skip => 'छोड़ें';

  @override
  String get sessions => 'सेशन';

  @override
  String get sessionsCompleted => 'पूर्ण सेशन';

  @override
  String get totalFocusTime => 'कुल फोकस समय';

  @override
  String get todayStats => 'आज के आंकड़े';

  @override
  String get weeklyStats => 'साप्ताहिक आंकड़े';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get focusDuration => 'फोकस अवधि';

  @override
  String get shortBreakDuration => 'छोटे ब्रेक की अवधि';

  @override
  String get longBreakDuration => 'लंबे ब्रेक की अवधि';

  @override
  String get sessionsUntilLongBreak => 'लंबे ब्रेक तक सेशन';

  @override
  String get soundEnabled => 'ध्वनि सक्षम';

  @override
  String get vibrationEnabled => 'कंपन सक्षम';

  @override
  String get autoStartBreaks => 'ब्रेक स्वचालित शुरू';

  @override
  String get autoStartFocus => 'फोकस स्वचालित शुरू';

  @override
  String get notifications => 'सूचनाएं';

  @override
  String get minutes => 'मिनट';

  @override
  String get min => 'मि';

  @override
  String get hours => 'घंटे';

  @override
  String get history => 'इतिहास';

  @override
  String get statistics => 'आंकड़े';

  @override
  String get timer => 'टाइमर';

  @override
  String get keepFocused => 'फोकस रखें!';

  @override
  String get timeForBreak => 'ब्रेक का समय!';

  @override
  String get breakOver => 'ब्रेक खत्म!';

  @override
  String get greatJob => 'शानदार काम!';

  @override
  String get sessionComplete => 'सेशन पूर्ण';

  @override
  String get ready => 'तैयार';

  @override
  String get focusMode => 'फोकस मोड';

  @override
  String get breakMode => 'ब्रेक मोड';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get language => 'भाषा';

  @override
  String get about => 'के बारे में';

  @override
  String get version => 'संस्करण';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get rateApp => 'ऐप को रेट करें';

  @override
  String get noSessionsYet => 'अभी तक कोई सेशन नहीं। अपना पहला पोमोडोरो शुरू करें!';

  @override
  String get pomodoroTechnique => 'पोमोडोरो तकनीक आपको काम को अंतराल में विभाजित करके ध्यान केंद्रित करने में मदद करती है, पारंपरिक रूप से 25 मिनट, छोटे ब्रेक से अलग।';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get letsGo => 'चलो शुरू करें!';

  @override
  String get streakDays => 'दिन लगातार';

  @override
  String get currentStreak => 'वर्तमान स्ट्रीक';

  @override
  String get bestStreak => 'सर्वश्रेष्ठ स्ट्रीक';

  @override
  String get days => 'दिन';

  @override
  String get achievements => 'उपलब्धियाँ';

  @override
  String get achievementUnlocked => 'उपलब्धि अनलॉक!';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked/$total अनलॉक';
  }

  @override
  String get notUnlockedYet => 'अभी तक अनलॉक नहीं';

  @override
  String unlockedOn(String date) {
    return '$date को अनलॉक';
  }

  @override
  String get close => 'बंद करें';

  @override
  String get categorySession => 'सेशन';

  @override
  String get categoryStreak => 'स्ट्रीक';

  @override
  String get categoryTime => 'फोकस समय';

  @override
  String get categorySpecial => 'विशेष';

  @override
  String get achievementFirstSession => 'पहला कदम';

  @override
  String get achievementFirstSessionDesc => 'अपना पहला फोकस सेशन पूरा करें';

  @override
  String get achievementSessions10 => 'अच्छी शुरुआत';

  @override
  String get achievementSessions10Desc => '10 फोकस सेशन पूरे करें';

  @override
  String get achievementSessions50 => 'समर्पित';

  @override
  String get achievementSessions50Desc => '50 फोकस सेशन पूरे करें';

  @override
  String get achievementSessions100 => 'शतक';

  @override
  String get achievementSessions100Desc => '100 फोकस सेशन पूरे करें';

  @override
  String get achievementSessions500 => 'ग्रैंडमास्टर';

  @override
  String get achievementSessions500Desc => '500 फोकस सेशन पूरे करें';

  @override
  String get achievementStreak3 => 'हैट ट्रिक';

  @override
  String get achievementStreak3Desc => '3 दिन की स्ट्रीक बनाएं';

  @override
  String get achievementStreak7 => 'साप्ताहिक योद्धा';

  @override
  String get achievementStreak7Desc => '7 दिन की स्ट्रीक बनाएं';

  @override
  String get achievementStreak30 => 'मासिक चैंपियन';

  @override
  String get achievementStreak30Desc => '30 दिन की स्ट्रीक बनाएं';

  @override
  String get achievementTime1h => 'पहला घंटा';

  @override
  String get achievementTime1hDesc => '1 घंटे का फोकस समय जमा करें';

  @override
  String get achievementTime10h => 'समय निवेशक';

  @override
  String get achievementTime10hDesc => '10 घंटे का फोकस समय जमा करें';

  @override
  String get achievementTime100h => 'समय का मास्टर';

  @override
  String get achievementTime100hDesc => '100 घंटे का फोकस समय जमा करें';

  @override
  String get achievementEarlyBird => 'अर्ली बर्ड';

  @override
  String get achievementEarlyBirdDesc => 'सुबह 7 बजे से पहले एक सेशन पूरा करें';

  @override
  String get achievementNightOwl => 'नाइट आउल';

  @override
  String get achievementNightOwlDesc => 'रात 10 बजे के बाद एक सेशन पूरा करें';

  @override
  String get achievementWeekendWarrior => 'वीकेंड वॉरियर';

  @override
  String get achievementWeekendWarriorDesc => 'सप्ताहांत पर 5 सेशन पूरे करें';

  @override
  String get ambientSounds => 'परिवेश ध्वनियाँ';

  @override
  String get soundSilence => 'शांति';

  @override
  String get soundRain => 'बारिश';

  @override
  String get soundForest => 'जंगल';

  @override
  String get soundOcean => 'समुद्र';

  @override
  String get soundCafe => 'कैफे';

  @override
  String get soundFireplace => 'चिमनी';

  @override
  String get soundWhiteNoise => 'व्हाइट नॉइज़';

  @override
  String get soundThunder => 'गरज';

  @override
  String get colorTheme => 'रंग थीम';

  @override
  String get themeTomato => 'टमाटर';

  @override
  String get themeOcean => 'समुद्र';

  @override
  String get themeForest => 'जंगल';

  @override
  String get themeLavender => 'लैवेंडर';

  @override
  String get themeSunset => 'सूर्यास्त';

  @override
  String get themeMidnight => 'मध्यरात्रि';

  @override
  String get themeRose => 'गुलाब';

  @override
  String get themeMint => 'पुदीना';

  @override
  String get dailyGoal => 'दैनिक लक्ष्य';

  @override
  String get dailyGoalTarget => 'दैनिक लक्ष्य';

  @override
  String get goalReached => 'लक्ष्य प्राप्त!';

  @override
  String sessionsProgress(int completed, int target) {
    return '$completed/$target सेशन';
  }

  @override
  String sessionsPerDay(int count) {
    return 'प्रति दिन $count सेशन';
  }

  @override
  String focusTimeToday(int minutes) {
    return 'आज $minutes मिनट केंद्रित';
  }

  @override
  String get newQuote => 'नया उद्धरण';

  @override
  String get quote1Text => 'आगे बढ़ने का रहस्य शुरू करना है।';

  @override
  String get quote1Author => 'मार्क ट्वेन';

  @override
  String get quote2Text => 'व्यस्त नहीं, उत्पादक होने पर ध्यान दें।';

  @override
  String get quote2Author => 'टिम फेरिस';

  @override
  String get quote3Text => 'मैं इतना स्मार्ट नहीं हूं, मैं बस समस्याओं के साथ अधिक समय रहता हूं।';

  @override
  String get quote3Author => 'अल्बर्ट आइंस्टीन';

  @override
  String get quote4Text => 'शुरू करने का तरीका है बात करना बंद करो और करना शुरू करो।';

  @override
  String get quote4Author => 'वॉल्ट डिज़्नी';

  @override
  String get quote5Text => 'शुरू करने के लिए आपको महान होने की आवश्यकता नहीं है, लेकिन महान होने के लिए आपको शुरू करना होगा।';

  @override
  String get quote5Author => 'ज़िग ज़िगलर';

  @override
  String get quote6Text => 'सफलता प्रतिदिन दोहराए गए छोटे प्रयासों का योग है।';

  @override
  String get quote6Author => 'रॉबर्ट कोलियर';

  @override
  String get quote7Text => 'महान काम करने का एकमात्र तरीका है कि आप जो करते हैं उससे प्यार करें।';

  @override
  String get quote7Author => 'स्टीव जॉब्स';

  @override
  String get quote8Text => 'अपने सभी विचारों को हाथ के काम पर केंद्रित करें।';

  @override
  String get quote8Author => 'अलेक्जेंडर ग्राहम बेल';

  @override
  String get quote9Text => 'समय वह है जो हम सबसे ज्यादा चाहते हैं, लेकिन सबसे बुरी तरह उपयोग करते हैं।';

  @override
  String get quote9Author => 'विलियम पेन';

  @override
  String get quote10Text => 'कार्य सभी सफलता की मूलभूत कुंजी है।';

  @override
  String get quote10Author => 'पाब्लो पिकासो';

  @override
  String get quote11Text => 'घड़ी मत देखो; वही करो जो वह करती है। आगे बढ़ते रहो।';

  @override
  String get quote11Author => 'सैम लेवेन्सन';

  @override
  String get quote12Text => 'आपकी सीमाएं केवल आपकी कल्पना हैं।';

  @override
  String get quote12Author => 'अज्ञात';

  @override
  String get quote13Text => 'सपना देखो। चाहो। करो।';

  @override
  String get quote13Author => 'अज्ञात';

  @override
  String get quote14Text => 'आप जितना कठिन परिश्रम करते हैं, उतने भाग्यशाली होते हैं।';

  @override
  String get quote14Author => 'गैरी प्लेयर';

  @override
  String get quote15Text => 'आज कुछ ऐसा करें जिसके लिए आपका भविष्य धन्यवाद करे।';

  @override
  String get quote15Author => 'अज्ञात';
}
