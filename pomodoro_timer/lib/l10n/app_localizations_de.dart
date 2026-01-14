import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Pomodoro Timer';

  @override
  String get focusSession => 'Fokus-Sitzung';

  @override
  String get shortBreak => 'Kurze Pause';

  @override
  String get longBreak => 'Lange Pause';

  @override
  String get start => 'Start';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Fortsetzen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get skip => 'Überspringen';

  @override
  String get sessions => 'Sitzungen';

  @override
  String get sessionsCompleted => 'Abgeschlossene Sitzungen';

  @override
  String get totalFocusTime => 'Gesamte Fokuszeit';

  @override
  String get todayStats => 'Heutige Statistiken';

  @override
  String get weeklyStats => 'Wöchentliche Statistiken';

  @override
  String get settings => 'Einstellungen';

  @override
  String get focusDuration => 'Fokus-Dauer';

  @override
  String get shortBreakDuration => 'Kurze Pause Dauer';

  @override
  String get longBreakDuration => 'Lange Pause Dauer';

  @override
  String get sessionsUntilLongBreak => 'Sitzungen bis zur langen Pause';

  @override
  String get soundEnabled => 'Ton aktiviert';

  @override
  String get vibrationEnabled => 'Vibration aktiviert';

  @override
  String get autoStartBreaks => 'Pausen automatisch starten';

  @override
  String get autoStartFocus => 'Fokus automatisch starten';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get minutes => 'Minuten';

  @override
  String get min => 'Min';

  @override
  String get hours => 'Stunden';

  @override
  String get history => 'Verlauf';

  @override
  String get statistics => 'Statistiken';

  @override
  String get timer => 'Timer';

  @override
  String get keepFocused => 'Bleib fokussiert!';

  @override
  String get timeForBreak => 'Zeit für eine Pause!';

  @override
  String get breakOver => 'Pause vorbei!';

  @override
  String get greatJob => 'Großartige Arbeit!';

  @override
  String get sessionComplete => 'Sitzung abgeschlossen';

  @override
  String get ready => 'Bereit';

  @override
  String get focusMode => 'Fokus-Modus';

  @override
  String get breakMode => 'Pause-Modus';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get language => 'Sprache';

  @override
  String get about => 'Über';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get rateApp => 'App bewerten';

  @override
  String get noSessionsYet => 'Noch keine Sitzungen. Starte dein erstes Pomodoro!';

  @override
  String get pomodoroTechnique => 'Die Pomodoro-Technik hilft dir, dich zu konzentrieren, indem sie die Arbeit in Intervalle aufteilt, traditionell 25 Minuten, getrennt durch kurze Pausen.';

  @override
  String get getStarted => 'Loslegen';

  @override
  String get letsGo => 'Los geht\'s!';

  @override
  String get streakDays => 'Tage Serie';

  @override
  String get currentStreak => 'Aktuelle Serie';

  @override
  String get bestStreak => 'Beste Serie';

  @override
  String get days => 'Tage';

  @override
  String get achievements => 'Erfolge';

  @override
  String get achievementUnlocked => 'Erfolg freigeschaltet!';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked/$total Freigeschaltet';
  }

  @override
  String get notUnlockedYet => 'Noch nicht freigeschaltet';

  @override
  String unlockedOn(String date) {
    return 'Freigeschaltet am $date';
  }

  @override
  String get close => 'Schließen';

  @override
  String get categorySession => 'Sitzungen';

  @override
  String get categoryStreak => 'Serie';

  @override
  String get categoryTime => 'Fokuszeit';

  @override
  String get categorySpecial => 'Spezial';

  @override
  String get achievementFirstSession => 'Erster Schritt';

  @override
  String get achievementFirstSessionDesc => 'Schließe deine erste Fokus-Sitzung ab';

  @override
  String get achievementSessions10 => 'Guter Start';

  @override
  String get achievementSessions10Desc => 'Schließe 10 Fokus-Sitzungen ab';

  @override
  String get achievementSessions50 => 'Engagiert';

  @override
  String get achievementSessions50Desc => 'Schließe 50 Fokus-Sitzungen ab';

  @override
  String get achievementSessions100 => 'Zenturio';

  @override
  String get achievementSessions100Desc => 'Schließe 100 Fokus-Sitzungen ab';

  @override
  String get achievementSessions500 => 'Großmeister';

  @override
  String get achievementSessions500Desc => 'Schließe 500 Fokus-Sitzungen ab';

  @override
  String get achievementStreak3 => 'Hat-Trick';

  @override
  String get achievementStreak3Desc => 'Halte eine 3-Tage-Serie';

  @override
  String get achievementStreak7 => 'Wochen-Krieger';

  @override
  String get achievementStreak7Desc => 'Halte eine 7-Tage-Serie';

  @override
  String get achievementStreak30 => 'Monats-Champion';

  @override
  String get achievementStreak30Desc => 'Halte eine 30-Tage-Serie';

  @override
  String get achievementTime1h => 'Erste Stunde';

  @override
  String get achievementTime1hDesc => 'Sammle 1 Stunde Fokuszeit';

  @override
  String get achievementTime10h => 'Zeit-Investor';

  @override
  String get achievementTime10hDesc => 'Sammle 10 Stunden Fokuszeit';

  @override
  String get achievementTime100h => 'Zeit-Meister';

  @override
  String get achievementTime100hDesc => 'Sammle 100 Stunden Fokuszeit';

  @override
  String get achievementEarlyBird => 'Frühaufsteher';

  @override
  String get achievementEarlyBirdDesc => 'Schließe eine Sitzung vor 7 Uhr ab';

  @override
  String get achievementNightOwl => 'Nachteule';

  @override
  String get achievementNightOwlDesc => 'Schließe eine Sitzung nach 22 Uhr ab';

  @override
  String get achievementWeekendWarrior => 'Wochenend-Krieger';

  @override
  String get achievementWeekendWarriorDesc => 'Schließe 5 Sitzungen am Wochenende ab';

  @override
  String get ambientSounds => 'Umgebungsgeräusche';

  @override
  String get soundSilence => 'Stille';

  @override
  String get soundRain => 'Regen';

  @override
  String get soundForest => 'Wald';

  @override
  String get soundOcean => 'Ozean';

  @override
  String get soundCafe => 'Café';

  @override
  String get soundFireplace => 'Kamin';

  @override
  String get soundWhiteNoise => 'Weißes Rauschen';

  @override
  String get soundThunder => 'Donner';

  @override
  String get colorTheme => 'Farbthema';

  @override
  String get themeTomato => 'Tomate';

  @override
  String get themeOcean => 'Ozean';

  @override
  String get themeForest => 'Wald';

  @override
  String get themeLavender => 'Lavendel';

  @override
  String get themeSunset => 'Sonnenuntergang';

  @override
  String get themeMidnight => 'Mitternacht';

  @override
  String get themeRose => 'Rose';

  @override
  String get themeMint => 'Minze';

  @override
  String get dailyGoal => 'Tagesziel';

  @override
  String get dailyGoalTarget => 'Tagesziel';

  @override
  String get goalReached => 'Ziel erreicht!';

  @override
  String sessionsProgress(int completed, int target) {
    return '$completed/$target Sitzungen';
  }

  @override
  String sessionsPerDay(int count) {
    return '$count Sitzungen pro Tag';
  }

  @override
  String focusTimeToday(int minutes) {
    return '$minutes Min fokussiert heute';
  }

  @override
  String get newQuote => 'Neues Zitat';

  @override
  String get quote1Text => 'Das Geheimnis des Vorankommens ist anzufangen.';

  @override
  String get quote1Author => 'Mark Twain';

  @override
  String get quote2Text => 'Konzentriere dich darauf, produktiv zu sein, nicht beschäftigt.';

  @override
  String get quote2Author => 'Tim Ferriss';

  @override
  String get quote3Text => 'Es ist nicht so, dass ich so klug bin, ich bleibe nur länger bei Problemen.';

  @override
  String get quote3Author => 'Albert Einstein';

  @override
  String get quote4Text => 'Der Weg anzufangen ist, aufzuhören zu reden und anzufangen zu handeln.';

  @override
  String get quote4Author => 'Walt Disney';

  @override
  String get quote5Text => 'Du musst nicht großartig sein um anzufangen, aber du musst anfangen um großartig zu werden.';

  @override
  String get quote5Author => 'Zig Ziglar';

  @override
  String get quote6Text => 'Erfolg ist die Summe kleiner Anstrengungen, Tag für Tag wiederholt.';

  @override
  String get quote6Author => 'Robert Collier';

  @override
  String get quote7Text => 'Der einzige Weg, großartige Arbeit zu leisten, ist zu lieben, was du tust.';

  @override
  String get quote7Author => 'Steve Jobs';

  @override
  String get quote8Text => 'Konzentriere alle deine Gedanken auf die aktuelle Aufgabe.';

  @override
  String get quote8Author => 'Alexander Graham Bell';

  @override
  String get quote9Text => 'Zeit ist das, was wir am meisten wollen, aber am schlechtesten nutzen.';

  @override
  String get quote9Author => 'William Penn';

  @override
  String get quote10Text => 'Handeln ist der grundlegende Schlüssel zu allem Erfolg.';

  @override
  String get quote10Author => 'Pablo Picasso';

  @override
  String get quote11Text => 'Schau nicht auf die Uhr; tu was sie tut. Weitermachen.';

  @override
  String get quote11Author => 'Sam Levenson';

  @override
  String get quote12Text => 'Deine Einschränkung ist nur deine Vorstellung.';

  @override
  String get quote12Author => 'Unbekannt';

  @override
  String get quote13Text => 'Träume es. Wünsche es. Tu es.';

  @override
  String get quote13Author => 'Unbekannt';

  @override
  String get quote14Text => 'Je härter du arbeitest, desto mehr Glück hast du.';

  @override
  String get quote14Author => 'Gary Player';

  @override
  String get quote15Text => 'Tu heute etwas, wofür dein zukünftiges Ich dir danken wird.';

  @override
  String get quote15Author => 'Unbekannt';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get colorfulMode => 'Bunter Modus';

  @override
  String get colorfulModeDesc => 'Verwende lebendige Farben und animiertes Layout';
}
