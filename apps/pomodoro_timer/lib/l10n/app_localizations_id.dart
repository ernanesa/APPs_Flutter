// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Pengatur Waktu Pomodoro';

  @override
  String get focusSession => 'Sesi Fokus';

  @override
  String get shortBreak => 'Istirahat Singkat';

  @override
  String get longBreak => 'Istirahat Panjang';

  @override
  String get start => 'Awal';

  @override
  String get pause => 'Berhenti sebentar';

  @override
  String get resume => 'Melanjutkan';

  @override
  String get reset => 'Mengatur ulang';

  @override
  String get skip => 'Melewati';

  @override
  String get sessions => 'Sesi';

  @override
  String get sessionsCompleted => 'Sesi Selesai';

  @override
  String get totalFocusTime => 'Total Waktu Fokus';

  @override
  String get todayStats => 'Statistik hari ini';

  @override
  String get weeklyStats => 'Statistik Mingguan';

  @override
  String get settings => 'Pengaturan';

  @override
  String get focusDuration => 'Durasi Fokus';

  @override
  String get shortBreakDuration => 'Durasi Istirahat Singkat';

  @override
  String get longBreakDuration => 'Durasi Istirahat Panjang';

  @override
  String get sessionsUntilLongBreak => 'Sesi Sampai Istirahat Panjang';

  @override
  String get soundEnabled => 'Suara Diaktifkan';

  @override
  String get vibrationEnabled => 'Getaran Diaktifkan';

  @override
  String get autoStartBreaks => 'Istirahat Mulai Otomatis';

  @override
  String get autoStartFocus => 'Fokus Mulai Otomatis';

  @override
  String get notifications => 'Pemberitahuan';

  @override
  String get minutes => 'menit';

  @override
  String get min => 'menit';

  @override
  String get hours => 'jam';

  @override
  String get history => 'Sejarah';

  @override
  String get statistics => 'Statistik';

  @override
  String get timer => 'pengatur waktu';

  @override
  String get keepFocused => 'Tetap Fokus!';

  @override
  String get timeForBreak => 'Waktunya istirahat!';

  @override
  String get breakOver => 'Istirahat sudah berakhir!';

  @override
  String get greatJob => 'Kerja Hebat!';

  @override
  String get sessionComplete => 'Sesi Selesai';

  @override
  String get ready => 'Siap';

  @override
  String get focusMode => 'Modus Fokus';

  @override
  String get breakMode => 'Modus Istirahat';

  @override
  String get darkMode => 'Mode Gelap';

  @override
  String get language => 'Bahasa';

  @override
  String get about => 'Tentang';

  @override
  String get version => 'Versi';

  @override
  String get privacyPolicy => 'Kebijakan Privasi';

  @override
  String get rateApp => 'Nilai Aplikasi';

  @override
  String get noSessionsYet => 'Belum ada sesi. Mulai Pomodoro pertama Anda!';

  @override
  String get pomodoroTechnique =>
      'Teknik Pomodoro membantu Anda fokus dengan membagi pekerjaan menjadi beberapa interval, biasanya berdurasi 25 menit, dipisahkan dengan istirahat singkat.';

  @override
  String get getStarted => 'Memulai';

  @override
  String get letsGo => 'Ayo Pergi!';

  @override
  String get streakDays => 'hari berturut-turut';

  @override
  String get currentStreak => 'Garis Saat Ini';

  @override
  String get bestStreak => 'Garis Terbaik';

  @override
  String get days => 'hari';

  @override
  String get achievements => 'Prestasi';

  @override
  String get achievementUnlocked => 'Prestasi Tidak Terkunci!';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked/${total}Tidak terkunci';
  }

  @override
  String get notUnlockedYet => 'Belum dibuka kuncinya';

  @override
  String unlockedOn(String date) {
    return 'Tidak terkunci$date';
  }

  @override
  String get close => 'Menutup';

  @override
  String get categorySession => 'Sesi';

  @override
  String get categoryStreak => 'Garis';

  @override
  String get categoryTime => 'Waktu Fokus';

  @override
  String get categorySpecial => 'Spesial';

  @override
  String get achievementFirstSession => 'Langkah Pertama';

  @override
  String get achievementFirstSessionDesc =>
      'Selesaikan sesi fokus pertama Anda';

  @override
  String get achievementSessions10 => 'Memulai';

  @override
  String get achievementSessions10Desc => 'Selesaikan 10 sesi fokus';

  @override
  String get achievementSessions50 => 'Berdedikasi';

  @override
  String get achievementSessions50Desc => 'Selesaikan 50 sesi fokus';

  @override
  String get achievementSessions100 => 'Perwira';

  @override
  String get achievementSessions100Desc => 'Selesaikan 100 sesi fokus';

  @override
  String get achievementSessions500 => 'Guru Besar';

  @override
  String get achievementSessions500Desc => 'Selesaikan 500 sesi fokus';

  @override
  String get achievementStreak3 => 'Trik Topi';

  @override
  String get achievementStreak3Desc =>
      'Pertahankan rekor 3 hari berturut-turut';

  @override
  String get achievementStreak7 => 'Pejuang Minggu';

  @override
  String get achievementStreak7Desc =>
      'Pertahankan rekor 7 hari berturut-turut';

  @override
  String get achievementStreak30 => 'Juara Bulanan';

  @override
  String get achievementStreak30Desc =>
      'Pertahankan rekor 30 hari berturut-turut';

  @override
  String get achievementTime1h => 'Jam Pertama';

  @override
  String get achievementTime1hDesc => 'Akumulasi 1 jam waktu fokus';

  @override
  String get achievementTime10h => 'Investor Waktu';

  @override
  String get achievementTime10hDesc => 'Akumulasi 10 jam waktu fokus';

  @override
  String get achievementTime100h => 'Tuan Waktu';

  @override
  String get achievementTime100hDesc => 'Akumulasi 100 jam waktu fokus';

  @override
  String get achievementEarlyBird => 'Burung Awal';

  @override
  String get achievementEarlyBirdDesc => 'Selesaikan sesi sebelum jam 7 pagi';

  @override
  String get achievementNightOwl => 'Burung Hantu Malam';

  @override
  String get achievementNightOwlDesc =>
      'Selesaikan satu sesi setelah jam 10 malam';

  @override
  String get achievementWeekendWarrior => 'Prajurit Akhir Pekan';

  @override
  String get achievementWeekendWarriorDesc =>
      'Selesaikan 5 sesi di akhir pekan';

  @override
  String get ambientSounds => 'Suara Sekitar';

  @override
  String get soundSilence => 'Kesunyian';

  @override
  String get soundRain => 'Hujan';

  @override
  String get soundForest => 'Hutan';

  @override
  String get soundOcean => 'Laut';

  @override
  String get soundCafe => 'Kafe';

  @override
  String get soundFireplace => 'Perapian';

  @override
  String get soundWhiteNoise => 'Kebisingan Putih';

  @override
  String get soundThunder => 'Guruh';

  @override
  String get colorTheme => 'Tema Warna';

  @override
  String get themeTomato => 'Tomat';

  @override
  String get themeOcean => 'Laut';

  @override
  String get themeForest => 'Hutan';

  @override
  String get themeLavender => 'warna lembayung muda';

  @override
  String get themeSunset => 'Matahari terbenam';

  @override
  String get themeMidnight => 'Tengah malam';

  @override
  String get themeRose => 'Mawar';

  @override
  String get themeMint => 'daun mint';

  @override
  String get dailyGoal => 'Tujuan Harian';

  @override
  String get dailyGoalTarget => 'Target Sasaran Harian';

  @override
  String get goalReached => 'Tujuan Tercapai!';

  @override
  String sessionsProgress(int completed, int target) {
    return '$completed/${target}sesi';
  }

  @override
  String sessionsPerDay(int count) {
    return '${count}sesi per hari';
  }

  @override
  String focusTimeToday(int minutes) {
    return '${minutes}min fokus hari ini';
  }

  @override
  String get newQuote => 'Kutipan Baru';

  @override
  String get quote1Text => 'Rahasia untuk maju adalah dengan memulainya.';

  @override
  String get quote1Author => 'Tandai Twain';

  @override
  String get quote2Text => 'Fokuslah untuk menjadi produktif daripada sibuk.';

  @override
  String get quote2Author => 'Tim Ferris';

  @override
  String get quote3Text =>
      'Bukannya aku begitu pintar, hanya saja aku bertahan lebih lama dengan masalah.';

  @override
  String get quote3Author => 'Albert Einstein';

  @override
  String get quote4Text =>
      'Cara memulainya adalah dengan berhenti berbicara dan mulai melakukan.';

  @override
  String get quote4Author => 'Walt Disney';

  @override
  String get quote5Text =>
      'Anda tidak harus menjadi hebat untuk memulai, tetapi Anda harus memulai untuk menjadi hebat.';

  @override
  String get quote5Author => 'Zig Ziglar';

  @override
  String get quote6Text =>
      'Kesuksesan adalah hasil dari usaha-usaha kecil yang dilakukan berulang-ulang hari demi hari.';

  @override
  String get quote6Author => 'Robert Collier';

  @override
  String get quote7Text =>
      'Satu-satunya cara untuk melakukan pekerjaan hebat adalah dengan mencintai apa yang Anda lakukan.';

  @override
  String get quote7Author => 'Steve Jobs';

  @override
  String get quote8Text =>
      'Pusatkan semua pikiran Anda pada pekerjaan yang ada.';

  @override
  String get quote8Author => 'Alexander Graham Bell';

  @override
  String get quote9Text =>
      'Waktu adalah hal yang paling kita inginkan, namun yang paling kita manfaatkan.';

  @override
  String get quote9Author => 'William Penn';

  @override
  String get quote10Text =>
      'Tindakan adalah kunci dasar dari semua kesuksesan.';

  @override
  String get quote10Author => 'Pablo Picasso';

  @override
  String get quote11Text =>
      'Jangan memperhatikan jam; melakukan apa yang dilakukannya. Terus berlanjut.';

  @override
  String get quote11Author => 'Sam Levenson';

  @override
  String get quote12Text => 'Keterbatasan Anda—itu hanya imajinasi Anda.';

  @override
  String get quote12Author => 'Tidak dikenal';

  @override
  String get quote13Text => 'Mimpikan itu. Berharap itu. Lakukan itu.';

  @override
  String get quote13Author => 'Tidak dikenal';

  @override
  String get quote14Text =>
      'Semakin keras Anda bekerja, semakin banyak keberuntungan yang Anda dapatkan.';

  @override
  String get quote14Author => 'Pemain Gary';

  @override
  String get quote15Text =>
      'Lakukan sesuatu hari ini yang akan membuat diri Anda berterima kasih di masa depan.';

  @override
  String get quote15Author => 'Tidak dikenal';

  @override
  String get appearance => 'Penampilan';

  @override
  String get colorfulMode => 'Modus Berwarna-warni';

  @override
  String get colorfulModeDesc =>
      'Gunakan warna-warna cerah dan tata letak animasi';
}
