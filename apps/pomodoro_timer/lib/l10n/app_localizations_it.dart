// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Temporizzatore del pomodoro';

  @override
  String get focusSession => 'Sessione focalizzata';

  @override
  String get shortBreak => 'Breve pausa';

  @override
  String get longBreak => 'Lunga pausa';

  @override
  String get start => 'Inizio';

  @override
  String get pause => 'Pausa';

  @override
  String get resume => 'Riprendere';

  @override
  String get reset => 'Reset';

  @override
  String get skip => 'Saltare';

  @override
  String get sessions => 'Sessioni';

  @override
  String get sessionsCompleted => 'Sessioni completate';

  @override
  String get totalFocusTime => 'Tempo di concentrazione totale';

  @override
  String get todayStats => 'Le statistiche di oggi';

  @override
  String get weeklyStats => 'Statistiche settimanali';

  @override
  String get settings => 'Impostazioni';

  @override
  String get focusDuration => 'Durata della messa a fuoco';

  @override
  String get shortBreakDuration => 'Durata della pausa breve';

  @override
  String get longBreakDuration => 'Durata della pausa lunga';

  @override
  String get sessionsUntilLongBreak => 'Sessioni fino alla lunga pausa';

  @override
  String get soundEnabled => 'Suono abilitato';

  @override
  String get vibrationEnabled => 'Vibrazione abilitata';

  @override
  String get autoStartBreaks => 'Pause con avvio automatico';

  @override
  String get autoStartFocus => 'Messa a fuoco con avvio automatico';

  @override
  String get notifications => 'Notifiche';

  @override
  String get minutes => 'minuti';

  @override
  String get min => 'min';

  @override
  String get hours => 'ore';

  @override
  String get history => 'Storia';

  @override
  String get statistics => 'Statistiche';

  @override
  String get timer => 'Timer';

  @override
  String get keepFocused => 'Mantieni la concentrazione!';

  @override
  String get timeForBreak => 'È ora di fare una pausa!';

  @override
  String get breakOver => 'La pausa è finita!';

  @override
  String get greatJob => 'Ottimo lavoro!';

  @override
  String get sessionComplete => 'Sessione completata';

  @override
  String get ready => 'Pronto';

  @override
  String get focusMode => 'Modalità di messa a fuoco';

  @override
  String get breakMode => 'Modalità di interruzione';

  @override
  String get darkMode => 'Modalità oscura';

  @override
  String get language => 'Lingua';

  @override
  String get about => 'Di';

  @override
  String get version => 'Versione';

  @override
  String get privacyPolicy => 'politica sulla riservatezza';

  @override
  String get rateApp => 'Valuta l\'app';

  @override
  String get noSessionsYet =>
      'Nessuna sessione ancora. Inizia il tuo primo Pomodoro!';

  @override
  String get pomodoroTechnique =>
      'La Tecnica del Pomodoro ti aiuta a concentrarti suddividendo il lavoro in intervalli, tradizionalmente di 25 minuti, separati da brevi pause.';

  @override
  String get getStarted => 'Inizia';

  @override
  String get letsGo => 'Andiamo!';

  @override
  String get streakDays => 'serie di giorni';

  @override
  String get currentStreak => 'Serie attuale';

  @override
  String get bestStreak => 'Miglior serie';

  @override
  String get days => 'giorni';

  @override
  String get achievements => 'Risultati';

  @override
  String get achievementUnlocked => 'Obiettivo sbloccato!';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked/${total}Sbloccato';
  }

  @override
  String get notUnlockedYet => 'Non ancora sbloccato';

  @override
  String unlockedOn(String date) {
    return 'Sbloccato$date';
  }

  @override
  String get close => 'Vicino';

  @override
  String get categorySession => 'Sessioni';

  @override
  String get categoryStreak => 'Strisciante';

  @override
  String get categoryTime => 'Tempo di concentrazione';

  @override
  String get categorySpecial => 'Speciale';

  @override
  String get achievementFirstSession => 'Primo passo';

  @override
  String get achievementFirstSessionDesc =>
      'Completa la tua prima sessione di focus';

  @override
  String get achievementSessions10 => 'Iniziare';

  @override
  String get achievementSessions10Desc => 'Completa 10 sessioni di focus';

  @override
  String get achievementSessions50 => 'Dedicato';

  @override
  String get achievementSessions50Desc => 'Completa 50 sessioni di focus';

  @override
  String get achievementSessions100 => 'Centurione';

  @override
  String get achievementSessions100Desc => 'Completa 100 sessioni di focus';

  @override
  String get achievementSessions500 => 'Gran Maestro';

  @override
  String get achievementSessions500Desc => 'Completa 500 sessioni di focus';

  @override
  String get achievementStreak3 => 'Tripletta';

  @override
  String get achievementStreak3Desc => 'Mantenere una serie di 3 giorni';

  @override
  String get achievementStreak7 => 'Settimana Guerriero';

  @override
  String get achievementStreak7Desc => 'Mantieni una serie di 7 giorni';

  @override
  String get achievementStreak30 => 'Campione mensile';

  @override
  String get achievementStreak30Desc => 'Mantenere una serie di 30 giorni';

  @override
  String get achievementTime1h => 'Prima Ora';

  @override
  String get achievementTime1hDesc =>
      'Accumula 1 ora di tempo di concentrazione';

  @override
  String get achievementTime10h => 'Investitore nel tempo';

  @override
  String get achievementTime10hDesc => 'Accumulate 10 hours of focus time';

  @override
  String get achievementTime100h => 'Maestro del tempo';

  @override
  String get achievementTime100hDesc => 'Accumulate 100 hours of focus time';

  @override
  String get achievementEarlyBird => 'Mattiniero';

  @override
  String get achievementEarlyBirdDesc =>
      'Completa una sessione prima delle 7:00';

  @override
  String get achievementNightOwl => 'Nottambulo';

  @override
  String get achievementNightOwlDesc => 'Completa una sessione dopo le 22:00';

  @override
  String get achievementWeekendWarrior => 'Guerriero del fine settimana';

  @override
  String get achievementWeekendWarriorDesc =>
      'Completa 5 sessioni in un fine settimana';

  @override
  String get ambientSounds => 'Suoni ambientali';

  @override
  String get soundSilence => 'Silenzio';

  @override
  String get soundRain => 'Piovere';

  @override
  String get soundForest => 'Foresta';

  @override
  String get soundOcean => 'Oceano';

  @override
  String get soundCafe => 'Caffetteria';

  @override
  String get soundFireplace => 'Camino';

  @override
  String get soundWhiteNoise => 'Rumore bianco';

  @override
  String get soundThunder => 'Tuono';

  @override
  String get colorTheme => 'Tema del colore';

  @override
  String get themeTomato => 'Pomodoro';

  @override
  String get themeOcean => 'Oceano';

  @override
  String get themeForest => 'Foresta';

  @override
  String get themeLavender => 'Lavanda';

  @override
  String get themeSunset => 'Tramonto';

  @override
  String get themeMidnight => 'Mezzanotte';

  @override
  String get themeRose => 'Rosa';

  @override
  String get themeMint => 'Menta';

  @override
  String get dailyGoal => 'Obiettivo quotidiano';

  @override
  String get dailyGoalTarget => 'Obiettivo giornaliero';

  @override
  String get goalReached => 'Obiettivo raggiunto!';

  @override
  String sessionsProgress(int completed, int target) {
    return '$completed/${target}sessioni';
  }

  @override
  String sessionsPerDay(int count) {
    return '${count}sessioni al giorno';
  }

  @override
  String focusTimeToday(int minutes) {
    return '${minutes}minuto concentrato oggi';
  }

  @override
  String get newQuote => 'Nuova citazione';

  @override
  String get quote1Text => 'Il segreto per andare avanti è iniziare.';

  @override
  String get quote1Author => 'Mark Twain';

  @override
  String get quote2Text => 'Focus on being productive instead of busy.';

  @override
  String get quote2Author => 'Tim Ferriss';

  @override
  String get quote3Text =>
      'Non è che io sia così intelligente, è solo che rimango con i problemi più a lungo.';

  @override
  String get quote3Author => 'Albert Einstein';

  @override
  String get quote4Text =>
      'Il modo per iniziare è smettere di parlare e iniziare a fare.';

  @override
  String get quote4Author => 'Walt Disney';

  @override
  String get quote5Text =>
      'Non devi essere eccezionale per iniziare, ma devi iniziare ad essere eccezionale.';

  @override
  String get quote5Author => 'Zig Ziglar';

  @override
  String get quote6Text =>
      'Il successo è la somma di piccoli sforzi ripetuti giorno dopo giorno.';

  @override
  String get quote6Author => 'Roberto Collier';

  @override
  String get quote7Text =>
      'L’unico modo per fare un ottimo lavoro è amare ciò che fai.';

  @override
  String get quote7Author => 'Steve Jobs';

  @override
  String get quote8Text =>
      'Concentra tutti i tuoi pensieri sul lavoro da svolgere.';

  @override
  String get quote8Author => 'Alexander Graham Bell';

  @override
  String get quote9Text =>
      'Il tempo è ciò che desideriamo di più, ma ciò che usiamo peggio.';

  @override
  String get quote9Author => 'William Penn';

  @override
  String get quote10Text =>
      'L’azione è la chiave fondamentale di ogni successo.';

  @override
  String get quote10Author => 'Pablo Picasso';

  @override
  String get quote11Text =>
      'Non guardare l\'orologio; fare quello che fa. Continuare.';

  @override
  String get quote11Author => 'Sam Levenson';

  @override
  String get quote12Text => 'Il tuo limite: è solo la tua immaginazione.';

  @override
  String get quote12Author => 'Sconosciuto';

  @override
  String get quote13Text => 'Sognatelo. Lo auguro. Fallo.';

  @override
  String get quote13Author => 'Sconosciuto';

  @override
  String get quote14Text => 'Più lavori duro, più sarai fortunato.';

  @override
  String get quote14Author => 'Gary Giocatore';

  @override
  String get quote15Text =>
      'Fai qualcosa oggi per cui il tuo io futuro ti ringrazierà.';

  @override
  String get quote15Author => 'Sconosciuto';

  @override
  String get appearance => 'Aspetto';

  @override
  String get colorfulMode => 'Modalità colorata';

  @override
  String get colorfulModeDesc => 'Utilizza colori vivaci e layout animato';
}
