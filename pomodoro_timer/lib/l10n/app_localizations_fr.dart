import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Minuteur Pomodoro';

  @override
  String get focusSession => 'Session de Concentration';

  @override
  String get shortBreak => 'Pause Courte';

  @override
  String get longBreak => 'Pause Longue';

  @override
  String get start => 'Démarrer';

  @override
  String get pause => 'Pause';

  @override
  String get resume => 'Reprendre';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get skip => 'Passer';

  @override
  String get sessions => 'Sessions';

  @override
  String get sessionsCompleted => 'Sessions Terminées';

  @override
  String get totalFocusTime => 'Temps de Concentration Total';

  @override
  String get todayStats => 'Statistiques du Jour';

  @override
  String get weeklyStats => 'Statistiques Hebdomadaires';

  @override
  String get settings => 'Paramètres';

  @override
  String get focusDuration => 'Durée de Concentration';

  @override
  String get shortBreakDuration => 'Durée de Pause Courte';

  @override
  String get longBreakDuration => 'Durée de Pause Longue';

  @override
  String get sessionsUntilLongBreak => 'Sessions avant Pause Longue';

  @override
  String get soundEnabled => 'Son Activé';

  @override
  String get vibrationEnabled => 'Vibration Activée';

  @override
  String get autoStartBreaks => 'Démarrer les Pauses Automatiquement';

  @override
  String get autoStartFocus => 'Démarrer la Concentration Automatiquement';

  @override
  String get notifications => 'Notifications';

  @override
  String get minutes => 'minutes';

  @override
  String get min => 'min';

  @override
  String get hours => 'heures';

  @override
  String get history => 'Historique';

  @override
  String get statistics => 'Statistiques';

  @override
  String get timer => 'Minuteur';

  @override
  String get keepFocused => 'Restez Concentré!';

  @override
  String get timeForBreak => 'Temps de Pause!';

  @override
  String get breakOver => 'Pause Terminée!';

  @override
  String get greatJob => 'Excellent Travail!';

  @override
  String get sessionComplete => 'Session Terminée';

  @override
  String get ready => 'Prêt';

  @override
  String get focusMode => 'Mode Concentration';

  @override
  String get breakMode => 'Mode Pause';

  @override
  String get darkMode => 'Mode Sombre';

  @override
  String get language => 'Langue';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Politique de Confidentialité';

  @override
  String get rateApp => 'Noter l\'App';

  @override
  String get noSessionsYet => 'Pas encore de sessions. Commencez votre premier Pomodoro!';

  @override
  String get pomodoroTechnique => 'La Technique Pomodoro vous aide à vous concentrer en divisant le travail en intervalles, traditionnellement de 25 minutes, séparés par de courtes pauses.';

  @override
  String get getStarted => 'Commencer';

  @override
  String get letsGo => 'C\'est parti!';

  @override
  String get streakDays => 'jours consécutifs';

  @override
  String get currentStreak => 'Série Actuelle';

  @override
  String get bestStreak => 'Meilleure Série';

  @override
  String get days => 'jours';

  @override
  String get achievements => 'Succès';

  @override
  String get achievementUnlocked => 'Succès Débloqué!';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked/$total Débloqués';
  }

  @override
  String get notUnlockedYet => 'Pas encore débloqué';

  @override
  String unlockedOn(String date) {
    return 'Débloqué le $date';
  }

  @override
  String get close => 'Fermer';

  @override
  String get categorySession => 'Sessions';

  @override
  String get categoryStreak => 'Série';

  @override
  String get categoryTime => 'Temps de Concentration';

  @override
  String get categorySpecial => 'Spécial';

  @override
  String get achievementFirstSession => 'Premier Pas';

  @override
  String get achievementFirstSessionDesc => 'Complétez votre première session de concentration';

  @override
  String get achievementSessions10 => 'Bon Départ';

  @override
  String get achievementSessions10Desc => 'Complétez 10 sessions de concentration';

  @override
  String get achievementSessions50 => 'Dévoué';

  @override
  String get achievementSessions50Desc => 'Complétez 50 sessions de concentration';

  @override
  String get achievementSessions100 => 'Centurion';

  @override
  String get achievementSessions100Desc => 'Complétez 100 sessions de concentration';

  @override
  String get achievementSessions500 => 'Grand Maître';

  @override
  String get achievementSessions500Desc => 'Complétez 500 sessions de concentration';

  @override
  String get achievementStreak3 => 'Hat Trick';

  @override
  String get achievementStreak3Desc => 'Maintenez une série de 3 jours';

  @override
  String get achievementStreak7 => 'Guerrier de la Semaine';

  @override
  String get achievementStreak7Desc => 'Maintenez une série de 7 jours';

  @override
  String get achievementStreak30 => 'Champion Mensuel';

  @override
  String get achievementStreak30Desc => 'Maintenez une série de 30 jours';

  @override
  String get achievementTime1h => 'Première Heure';

  @override
  String get achievementTime1hDesc => 'Accumulez 1 heure de temps de concentration';

  @override
  String get achievementTime10h => 'Investisseur de Temps';

  @override
  String get achievementTime10hDesc => 'Accumulez 10 heures de temps de concentration';

  @override
  String get achievementTime100h => 'Maître du Temps';

  @override
  String get achievementTime100hDesc => 'Accumulez 100 heures de temps de concentration';

  @override
  String get achievementEarlyBird => 'Lève-tôt';

  @override
  String get achievementEarlyBirdDesc => 'Complétez une session avant 7h';

  @override
  String get achievementNightOwl => 'Oiseau de Nuit';

  @override
  String get achievementNightOwlDesc => 'Complétez une session après 22h';

  @override
  String get achievementWeekendWarrior => 'Guerrier du Week-end';

  @override
  String get achievementWeekendWarriorDesc => 'Complétez 5 sessions un week-end';

  @override
  String get ambientSounds => 'Sons Ambiants';

  @override
  String get soundSilence => 'Silence';

  @override
  String get soundRain => 'Pluie';

  @override
  String get soundForest => 'Forêt';

  @override
  String get soundOcean => 'Océan';

  @override
  String get soundCafe => 'Café';

  @override
  String get soundFireplace => 'Cheminée';

  @override
  String get soundWhiteNoise => 'Bruit Blanc';

  @override
  String get soundThunder => 'Tonnerre';

  @override
  String get colorTheme => 'Thème de Couleur';

  @override
  String get themeTomato => 'Tomate';

  @override
  String get themeOcean => 'Océan';

  @override
  String get themeForest => 'Forêt';

  @override
  String get themeLavender => 'Lavande';

  @override
  String get themeSunset => 'Coucher de Soleil';

  @override
  String get themeMidnight => 'Minuit';

  @override
  String get themeRose => 'Rose';

  @override
  String get themeMint => 'Menthe';

  @override
  String get dailyGoal => 'Objectif Quotidien';

  @override
  String get dailyGoalTarget => 'Objectif Quotidien';

  @override
  String get goalReached => 'Objectif Atteint!';

  @override
  String sessionsProgress(int completed, int target) {
    return '$completed/$target sessions';
  }

  @override
  String sessionsPerDay(int count) {
    return '$count sessions par jour';
  }

  @override
  String focusTimeToday(int minutes) {
    return '$minutes min concentré aujourd\'hui';
  }

  @override
  String get newQuote => 'Nouvelle Citation';

  @override
  String get quote1Text => 'Le secret pour avancer est de commencer.';

  @override
  String get quote1Author => 'Mark Twain';

  @override
  String get quote2Text => 'Concentrez-vous sur être productif, pas occupé.';

  @override
  String get quote2Author => 'Tim Ferriss';

  @override
  String get quote3Text => 'Ce n\'est pas que je suis si intelligent, c\'est que je reste plus longtemps avec les problèmes.';

  @override
  String get quote3Author => 'Albert Einstein';

  @override
  String get quote4Text => 'La façon de commencer est d\'arrêter de parler et de commencer à faire.';

  @override
  String get quote4Author => 'Walt Disney';

  @override
  String get quote5Text => 'Vous n\'avez pas besoin d\'être génial pour commencer, mais vous devez commencer pour être génial.';

  @override
  String get quote5Author => 'Zig Ziglar';

  @override
  String get quote6Text => 'Le succès est la somme de petits efforts répétés jour après jour.';

  @override
  String get quote6Author => 'Robert Collier';

  @override
  String get quote7Text => 'La seule façon de faire du bon travail est d\'aimer ce que vous faites.';

  @override
  String get quote7Author => 'Steve Jobs';

  @override
  String get quote8Text => 'Concentrez toutes vos pensées sur le travail en cours.';

  @override
  String get quote8Author => 'Alexander Graham Bell';

  @override
  String get quote9Text => 'Le temps est ce que nous voulons le plus, mais ce que nous utilisons le moins bien.';

  @override
  String get quote9Author => 'William Penn';

  @override
  String get quote10Text => 'L\'action est la clé fondamentale de tout succès.';

  @override
  String get quote10Author => 'Pablo Picasso';

  @override
  String get quote11Text => 'Ne regardez pas l\'horloge; faites ce qu\'elle fait. Continuez.';

  @override
  String get quote11Author => 'Sam Levenson';

  @override
  String get quote12Text => 'Votre limitation n\'est que votre imagination.';

  @override
  String get quote12Author => 'Inconnu';

  @override
  String get quote13Text => 'Rêvez-le. Souhaitez-le. Faites-le.';

  @override
  String get quote13Author => 'Inconnu';

  @override
  String get quote14Text => 'Plus vous travaillez dur, plus vous avez de chance.';

  @override
  String get quote14Author => 'Gary Player';

  @override
  String get quote15Text => 'Faites aujourd\'hui quelque chose dont votre futur vous remerciera.';

  @override
  String get quote15Author => 'Inconnu';
}
