import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Pomodoro Timer';

  @override
  String get focusSession => 'Sesión de Enfoque';

  @override
  String get shortBreak => 'Descanso Corto';

  @override
  String get longBreak => 'Descanso Largo';

  @override
  String get start => 'Iniciar';

  @override
  String get pause => 'Pausar';

  @override
  String get resume => 'Reanudar';

  @override
  String get reset => 'Reiniciar';

  @override
  String get skip => 'Saltar';

  @override
  String get sessions => 'Sesiones';

  @override
  String get sessionsCompleted => 'Sesiones Completadas';

  @override
  String get totalFocusTime => 'Tiempo Total de Enfoque';

  @override
  String get todayStats => 'Estadísticas de Hoy';

  @override
  String get weeklyStats => 'Estadísticas Semanales';

  @override
  String get settings => 'Configuración';

  @override
  String get focusDuration => 'Duración del Enfoque';

  @override
  String get shortBreakDuration => 'Duración del Descanso Corto';

  @override
  String get longBreakDuration => 'Duración del Descanso Largo';

  @override
  String get sessionsUntilLongBreak => 'Sesiones hasta Descanso Largo';

  @override
  String get soundEnabled => 'Sonido Activado';

  @override
  String get vibrationEnabled => 'Vibración Activada';

  @override
  String get autoStartBreaks => 'Iniciar Descansos Automáticamente';

  @override
  String get autoStartFocus => 'Iniciar Enfoque Automáticamente';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get minutes => 'minutos';

  @override
  String get min => 'min';

  @override
  String get hours => 'horas';

  @override
  String get history => 'Historial';

  @override
  String get statistics => 'Estadísticas';

  @override
  String get timer => 'Temporizador';

  @override
  String get keepFocused => '¡Mantén el Enfoque!';

  @override
  String get timeForBreak => '¡Hora de un Descanso!';

  @override
  String get breakOver => '¡Descanso Terminado!';

  @override
  String get greatJob => '¡Excelente Trabajo!';

  @override
  String get sessionComplete => 'Sesión Completa';

  @override
  String get ready => 'Listo';

  @override
  String get focusMode => 'Modo Enfoque';

  @override
  String get breakMode => 'Modo Descanso';

  @override
  String get darkMode => 'Modo Oscuro';

  @override
  String get language => 'Idioma';

  @override
  String get about => 'Acerca de';

  @override
  String get version => 'Versión';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get rateApp => 'Calificar App';

  @override
  String get noSessionsYet => 'Sin sesiones aún. ¡Comienza tu primer Pomodoro!';

  @override
  String get pomodoroTechnique => 'La Técnica Pomodoro te ayuda a enfocarte dividiendo el trabajo en intervalos, tradicionalmente de 25 minutos, separados por descansos cortos.';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get letsGo => '¡Vamos!';

  @override
  String get streakDays => 'días seguidos';

  @override
  String get currentStreak => 'Racha Actual';

  @override
  String get bestStreak => 'Mejor Racha';

  @override
  String get days => 'días';

  @override
  String get achievements => 'Logros';

  @override
  String get achievementUnlocked => '¡Logro Desbloqueado!';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked/$total Desbloqueados';
  }

  @override
  String get notUnlockedYet => 'Aún no desbloqueado';

  @override
  String unlockedOn(String date) {
    return 'Desbloqueado el $date';
  }

  @override
  String get close => 'Cerrar';

  @override
  String get categorySession => 'Sesiones';

  @override
  String get categoryStreak => 'Racha';

  @override
  String get categoryTime => 'Tiempo de Enfoque';

  @override
  String get categorySpecial => 'Especial';

  @override
  String get achievementFirstSession => 'Primer Paso';

  @override
  String get achievementFirstSessionDesc => 'Completa tu primera sesión de enfoque';

  @override
  String get achievementSessions10 => 'Empezando Bien';

  @override
  String get achievementSessions10Desc => 'Completa 10 sesiones de enfoque';

  @override
  String get achievementSessions50 => 'Dedicado';

  @override
  String get achievementSessions50Desc => 'Completa 50 sesiones de enfoque';

  @override
  String get achievementSessions100 => 'Centurión';

  @override
  String get achievementSessions100Desc => 'Completa 100 sesiones de enfoque';

  @override
  String get achievementSessions500 => 'Gran Maestro';

  @override
  String get achievementSessions500Desc => 'Completa 500 sesiones de enfoque';

  @override
  String get achievementStreak3 => 'Hat Trick';

  @override
  String get achievementStreak3Desc => 'Mantén una racha de 3 días';

  @override
  String get achievementStreak7 => 'Guerrero Semanal';

  @override
  String get achievementStreak7Desc => 'Mantén una racha de 7 días';

  @override
  String get achievementStreak30 => 'Campeón Mensual';

  @override
  String get achievementStreak30Desc => 'Mantén una racha de 30 días';

  @override
  String get achievementTime1h => 'Primera Hora';

  @override
  String get achievementTime1hDesc => 'Acumula 1 hora de tiempo de enfoque';

  @override
  String get achievementTime10h => 'Inversor de Tiempo';

  @override
  String get achievementTime10hDesc => 'Acumula 10 horas de tiempo de enfoque';

  @override
  String get achievementTime100h => 'Maestro del Tiempo';

  @override
  String get achievementTime100hDesc => 'Acumula 100 horas de tiempo de enfoque';

  @override
  String get achievementEarlyBird => 'Madrugador';

  @override
  String get achievementEarlyBirdDesc => 'Completa una sesión antes de las 7 AM';

  @override
  String get achievementNightOwl => 'Búho Nocturno';

  @override
  String get achievementNightOwlDesc => 'Completa una sesión después de las 10 PM';

  @override
  String get achievementWeekendWarrior => 'Guerrero de Fin de Semana';

  @override
  String get achievementWeekendWarriorDesc => 'Completa 5 sesiones en un fin de semana';

  @override
  String get ambientSounds => 'Sonidos Ambientales';

  @override
  String get soundSilence => 'Silencio';

  @override
  String get soundRain => 'Lluvia';

  @override
  String get soundForest => 'Bosque';

  @override
  String get soundOcean => 'Océano';

  @override
  String get soundCafe => 'Café';

  @override
  String get soundFireplace => 'Chimenea';

  @override
  String get soundWhiteNoise => 'Ruido Blanco';

  @override
  String get soundThunder => 'Trueno';

  @override
  String get colorTheme => 'Tema de Color';

  @override
  String get themeTomato => 'Tomate';

  @override
  String get themeOcean => 'Océano';

  @override
  String get themeForest => 'Bosque';

  @override
  String get themeLavender => 'Lavanda';

  @override
  String get themeSunset => 'Atardecer';

  @override
  String get themeMidnight => 'Medianoche';

  @override
  String get themeRose => 'Rosa';

  @override
  String get themeMint => 'Menta';

  @override
  String get dailyGoal => 'Meta Diaria';

  @override
  String get dailyGoalTarget => 'Meta Diaria';

  @override
  String get goalReached => '¡Meta Alcanzada!';

  @override
  String sessionsProgress(int completed, int target) {
    return '$completed/$target sesiones';
  }

  @override
  String sessionsPerDay(int count) {
    return '$count sesiones por día';
  }

  @override
  String focusTimeToday(int minutes) {
    return '$minutes min enfocado hoy';
  }

  @override
  String get newQuote => 'Nueva Cita';

  @override
  String get quote1Text => 'El secreto de avanzar es empezar.';

  @override
  String get quote1Author => 'Mark Twain';

  @override
  String get quote2Text => 'Enfócate en ser productivo, no en estar ocupado.';

  @override
  String get quote2Author => 'Tim Ferriss';

  @override
  String get quote3Text => 'No es que sea tan inteligente, es que me quedo con los problemas más tiempo.';

  @override
  String get quote3Author => 'Albert Einstein';

  @override
  String get quote4Text => 'La manera de empezar es dejar de hablar y empezar a hacer.';

  @override
  String get quote4Author => 'Walt Disney';

  @override
  String get quote5Text => 'No tienes que ser genial para empezar, pero tienes que empezar para ser genial.';

  @override
  String get quote5Author => 'Zig Ziglar';

  @override
  String get quote6Text => 'El éxito es la suma de pequeños esfuerzos repetidos día tras día.';

  @override
  String get quote6Author => 'Robert Collier';

  @override
  String get quote7Text => 'La única manera de hacer un gran trabajo es amar lo que haces.';

  @override
  String get quote7Author => 'Steve Jobs';

  @override
  String get quote8Text => 'Concentra todos tus pensamientos en el trabajo en cuestión.';

  @override
  String get quote8Author => 'Alexander Graham Bell';

  @override
  String get quote9Text => 'El tiempo es lo que más queremos, pero lo que peor usamos.';

  @override
  String get quote9Author => 'William Penn';

  @override
  String get quote10Text => 'La acción es la clave fundamental de todo éxito.';

  @override
  String get quote10Author => 'Pablo Picasso';

  @override
  String get quote11Text => 'No mires el reloj; haz lo que él hace. Sigue adelante.';

  @override
  String get quote11Author => 'Sam Levenson';

  @override
  String get quote12Text => 'Tu limitación es solo tu imaginación.';

  @override
  String get quote12Author => 'Desconocido';

  @override
  String get quote13Text => 'Sueña. Desea. Hazlo.';

  @override
  String get quote13Author => 'Desconocido';

  @override
  String get quote14Text => 'Cuanto más trabajas, más suerte tienes.';

  @override
  String get quote14Author => 'Gary Player';

  @override
  String get quote15Text => 'Haz hoy algo que tu yo futuro te agradecerá.';

  @override
  String get quote15Author => 'Desconocido';

  @override
  String get appearance => 'Apariencia';

  @override
  String get colorfulMode => 'Modo Colorido';

  @override
  String get colorfulModeDesc => 'Usa colores vibrantes y diseño animado';
}
