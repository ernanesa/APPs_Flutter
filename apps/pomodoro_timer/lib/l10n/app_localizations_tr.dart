// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Pomodoro Zamanlayıcı';

  @override
  String get focusSession => 'Odaklanma Oturumu';

  @override
  String get shortBreak => 'Kısa Mola';

  @override
  String get longBreak => 'Uzun Mola';

  @override
  String get start => 'Başlangıç';

  @override
  String get pause => 'Duraklat';

  @override
  String get resume => 'Sürdürmek';

  @override
  String get reset => 'Sıfırla';

  @override
  String get skip => 'Atlamak';

  @override
  String get sessions => 'Oturumlar';

  @override
  String get sessionsCompleted => 'Tamamlanan Oturumlar';

  @override
  String get totalFocusTime => 'Toplam Odaklanma Süresi';

  @override
  String get todayStats => 'Bugünün İstatistikleri';

  @override
  String get weeklyStats => 'Haftalık İstatistikler';

  @override
  String get settings => 'Ayarlar';

  @override
  String get focusDuration => 'Odaklanma Süresi';

  @override
  String get shortBreakDuration => 'Kısa Mola Süresi';

  @override
  String get longBreakDuration => 'Uzun Mola Süresi';

  @override
  String get sessionsUntilLongBreak => 'Uzun Araya Kadar Oturumlar';

  @override
  String get soundEnabled => 'Ses Etkin';

  @override
  String get vibrationEnabled => 'Titreşim Etkin';

  @override
  String get autoStartBreaks => 'Molaları Otomatik Başlat';

  @override
  String get autoStartFocus => 'Otomatik Başlatılan Odaklama';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get minutes => 'dakika';

  @override
  String get min => 'dk.';

  @override
  String get hours => 'saat';

  @override
  String get history => 'Tarih';

  @override
  String get statistics => 'İstatistikler';

  @override
  String get timer => 'Zamanlayıcı';

  @override
  String get keepFocused => 'Odaklanmaya devam edin!';

  @override
  String get timeForBreak => 'Mola Zamanı!';

  @override
  String get breakOver => 'Mola bitti!';

  @override
  String get greatJob => 'Harika İş!';

  @override
  String get sessionComplete => 'Oturum Tamamlandı';

  @override
  String get ready => 'Hazır';

  @override
  String get focusMode => 'Odak Modu';

  @override
  String get breakMode => 'Mola Modu';

  @override
  String get darkMode => 'Karanlık Mod';

  @override
  String get language => 'Dil';

  @override
  String get about => 'Hakkında';

  @override
  String get version => 'Sürüm';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get rateApp => 'Uygulamayı Değerlendirin';

  @override
  String get noSessionsYet => 'Henüz oturum yok. İlk Pomodoro\'nuza başlayın!';

  @override
  String get pomodoroTechnique =>
      'Pomodoro Tekniği, çalışmayı geleneksel olarak 25 dakika uzunluğunda ve kısa molalarla ayrılmış aralıklarla bölerek odaklanmanıza yardımcı olur.';

  @override
  String get getStarted => 'Başlayın';

  @override
  String get letsGo => 'Hadi gidelim!';

  @override
  String get streakDays => 'gün serisi';

  @override
  String get currentStreak => 'Mevcut Seri';

  @override
  String get bestStreak => 'En İyi Seri';

  @override
  String get days => 'günler';

  @override
  String get achievements => 'Başarılar';

  @override
  String get achievementUnlocked => 'Başarı Kilidi Açıldı!';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked/${total}Kilitli değil';
  }

  @override
  String get notUnlockedYet => 'Henüz kilidi açılmadı';

  @override
  String unlockedOn(String date) {
    return 'Kilit açma tarihi$date';
  }

  @override
  String get close => 'Kapalı';

  @override
  String get categorySession => 'Oturumlar';

  @override
  String get categoryStreak => 'Rüzgâr gibi geçmek';

  @override
  String get categoryTime => 'Odaklanma Süresi';

  @override
  String get categorySpecial => 'Özel';

  @override
  String get achievementFirstSession => 'İlk adım';

  @override
  String get achievementFirstSessionDesc =>
      'İlk odaklanma oturumunuzu tamamlayın';

  @override
  String get achievementSessions10 => 'Başlarken';

  @override
  String get achievementSessions10Desc => '10 odaklanma oturumunu tamamlayın';

  @override
  String get achievementSessions50 => 'Özel';

  @override
  String get achievementSessions50Desc => '50 odaklanma oturumunu tamamlayın';

  @override
  String get achievementSessions100 => 'Yüzbaşı';

  @override
  String get achievementSessions100Desc => '100 odaklanma oturumunu tamamla';

  @override
  String get achievementSessions500 => 'Büyük usta';

  @override
  String get achievementSessions500Desc => '500 odaklanma oturumunu tamamlayın';

  @override
  String get achievementStreak3 => 'El çabukluğu';

  @override
  String get achievementStreak3Desc => '3 günlük seriyi koruyun';

  @override
  String get achievementStreak7 => 'Hafta Savaşçısı';

  @override
  String get achievementStreak7Desc => '7 günlük seriyi koruyun';

  @override
  String get achievementStreak30 => 'Aylık Şampiyon';

  @override
  String get achievementStreak30Desc => '30 günlük seriyi koruyun';

  @override
  String get achievementTime1h => 'İlk Saat';

  @override
  String get achievementTime1hDesc => '1 saatlik odaklanma süresi biriktirin';

  @override
  String get achievementTime10h => 'Zaman Yatırımcısı';

  @override
  String get achievementTime10hDesc => '10 saatlik odaklanma süresi biriktirin';

  @override
  String get achievementTime100h => 'Zaman Ustası';

  @override
  String get achievementTime100hDesc =>
      '100 saatlik odaklanma süresi biriktirin';

  @override
  String get achievementEarlyBird => 'Erken Rezervasyon';

  @override
  String get achievementEarlyBirdDesc =>
      'Bir oturumu sabah 7\'den önce tamamlayın';

  @override
  String get achievementNightOwl => 'Gece Kuşu';

  @override
  String get achievementNightOwlDesc =>
      'Bir oturumu saat 22.00\'den sonra tamamlayın';

  @override
  String get achievementWeekendWarrior => 'Hafta Sonu Savaşçısı';

  @override
  String get achievementWeekendWarriorDesc => 'Hafta sonu 5 seansı tamamlayın';

  @override
  String get ambientSounds => 'Ortam Sesleri';

  @override
  String get soundSilence => 'Sessizlik';

  @override
  String get soundRain => 'Yağmur';

  @override
  String get soundForest => 'Orman';

  @override
  String get soundOcean => 'Okyanus';

  @override
  String get soundCafe => 'Kafe';

  @override
  String get soundFireplace => 'Şömine';

  @override
  String get soundWhiteNoise => 'Beyaz Gürültü';

  @override
  String get soundThunder => 'Gök gürültüsü';

  @override
  String get colorTheme => 'Renk Teması';

  @override
  String get themeTomato => 'Domates';

  @override
  String get themeOcean => 'Okyanus';

  @override
  String get themeForest => 'Orman';

  @override
  String get themeLavender => 'Lavanta';

  @override
  String get themeSunset => 'Gün batımı';

  @override
  String get themeMidnight => 'Gece yarısı';

  @override
  String get themeRose => 'Gül';

  @override
  String get themeMint => 'Nane';

  @override
  String get dailyGoal => 'Günlük Hedef';

  @override
  String get dailyGoalTarget => 'Günlük Hedef Hedefi';

  @override
  String get goalReached => 'Hedefe Ulaşıldı!';

  @override
  String sessionsProgress(int completed, int target) {
    return '$completed/${target}oturumlar';
  }

  @override
  String sessionsPerDay(int count) {
    return '${count}günlük seanslar';
  }

  @override
  String focusTimeToday(int minutes) {
    return '${minutes}bugün odaklandım';
  }

  @override
  String get newQuote => 'Yeni Teklif';

  @override
  String get quote1Text => 'İlerlemenin sırrı başlamaktır.';

  @override
  String get quote1Author => 'Mark Twain';

  @override
  String get quote2Text => 'Meşgul olmak yerine üretken olmaya odaklanın.';

  @override
  String get quote2Author => 'Tim Ferris';

  @override
  String get quote3Text =>
      'Çok akıllı olduğumdan değil, sadece sorunlarla daha uzun süre baş başa kaldığım için.';

  @override
  String get quote3Author => 'Albert Einstein';

  @override
  String get quote4Text =>
      'Başlamanın yolu konuşmayı bırakıp yapmaya başlamaktır.';

  @override
  String get quote4Author => 'Walt Disney';

  @override
  String get quote5Text =>
      'Başlamak için harika olmanıza gerek yok, ama harika olmak için başlamanız gerekiyor.';

  @override
  String get quote5Author => 'Zig Ziglar';

  @override
  String get quote6Text =>
      'Başarı her gün tekrarlanan küçük çabaların toplamıdır.';

  @override
  String get quote6Author => 'Robert Collier';

  @override
  String get quote7Text =>
      'Harika işler yapmanın tek yolu yaptığınız işi sevmektir.';

  @override
  String get quote7Author => 'Steve Jobs';

  @override
  String get quote8Text => 'Tüm düşüncelerinizi elinizdeki işe yoğunlaştırın.';

  @override
  String get quote8Author => 'Alexander Graham Bell';

  @override
  String get quote9Text =>
      'Zaman en çok istediğimiz ama en kötü kullandığımız şeydir.';

  @override
  String get quote9Author => 'William Penn';

  @override
  String get quote10Text => 'Eylem, tüm başarının temel anahtarıdır.';

  @override
  String get quote10Author => 'Pablo Picasso';

  @override
  String get quote11Text =>
      'Saate bakmayın; ne yapıyorsa onu yap. Devam etmek.';

  @override
  String get quote11Author => 'Sam Levenson';

  @override
  String get quote12Text =>
      'Sınırlamanız — bu yalnızca sizin hayal gücünüzdür.';

  @override
  String get quote12Author => 'Bilinmiyor';

  @override
  String get quote13Text => 'Hayal et. Dile. Yap.';

  @override
  String get quote13Author => 'Bilinmiyor';

  @override
  String get quote14Text =>
      'Ne kadar çok çalışırsanız o kadar şanslı olursunuz.';

  @override
  String get quote14Author => 'Gary Oyuncu';

  @override
  String get quote15Text =>
      'Bugün gelecekteki benliğinizin size teşekkür edeceği bir şey yapın.';

  @override
  String get quote15Author => 'Bilinmiyor';

  @override
  String get appearance => 'Dış görünüş';

  @override
  String get colorfulMode => 'Renkli Mod';

  @override
  String get colorfulModeDesc => 'Canlı renkler ve animasyonlu düzen kullanın';
}
