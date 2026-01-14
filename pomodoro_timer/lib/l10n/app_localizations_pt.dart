import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Pomodoro Timer';

  @override
  String get focusSession => 'Sessão de Foco';

  @override
  String get shortBreak => 'Pausa Curta';

  @override
  String get longBreak => 'Pausa Longa';

  @override
  String get start => 'Iniciar';

  @override
  String get pause => 'Pausar';

  @override
  String get resume => 'Retomar';

  @override
  String get reset => 'Reiniciar';

  @override
  String get skip => 'Pular';

  @override
  String get sessions => 'Sessões';

  @override
  String get sessionsCompleted => 'Sessões Concluídas';

  @override
  String get totalFocusTime => 'Tempo Total de Foco';

  @override
  String get todayStats => 'Estatísticas de Hoje';

  @override
  String get weeklyStats => 'Estatísticas Semanais';

  @override
  String get settings => 'Configurações';

  @override
  String get focusDuration => 'Duração do Foco';

  @override
  String get shortBreakDuration => 'Duração da Pausa Curta';

  @override
  String get longBreakDuration => 'Duração da Pausa Longa';

  @override
  String get sessionsUntilLongBreak => 'Sessões até Pausa Longa';

  @override
  String get soundEnabled => 'Som Ativado';

  @override
  String get vibrationEnabled => 'Vibração Ativada';

  @override
  String get autoStartBreaks => 'Iniciar Pausas Automaticamente';

  @override
  String get autoStartFocus => 'Iniciar Foco Automaticamente';

  @override
  String get notifications => 'Notificações';

  @override
  String get minutes => 'minutos';

  @override
  String get min => 'min';

  @override
  String get hours => 'horas';

  @override
  String get history => 'Histórico';

  @override
  String get statistics => 'Estatísticas';

  @override
  String get timer => 'Timer';

  @override
  String get keepFocused => 'Mantenha o Foco!';

  @override
  String get timeForBreak => 'Hora de uma Pausa!';

  @override
  String get breakOver => 'Pausa Finalizada!';

  @override
  String get greatJob => 'Ótimo Trabalho!';

  @override
  String get sessionComplete => 'Sessão Completa';

  @override
  String get ready => 'Pronto';

  @override
  String get focusMode => 'Modo Foco';

  @override
  String get breakMode => 'Modo Pausa';

  @override
  String get darkMode => 'Modo Escuro';

  @override
  String get language => 'Idioma';

  @override
  String get about => 'Sobre';

  @override
  String get version => 'Versão';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get rateApp => 'Avaliar App';

  @override
  String get noSessionsYet => 'Nenhuma sessão ainda. Comece seu primeiro Pomodoro!';

  @override
  String get pomodoroTechnique => 'A Técnica Pomodoro ajuda você a focar dividindo o trabalho em intervalos, tradicionalmente de 25 minutos, separados por pausas curtas.';

  @override
  String get getStarted => 'Começar';

  @override
  String get letsGo => 'Vamos lá!';

  @override
  String get streakDays => 'dias seguidos';

  @override
  String get currentStreak => 'Sequência Atual';

  @override
  String get bestStreak => 'Melhor Sequência';

  @override
  String get days => 'dias';

  @override
  String get achievements => 'Conquistas';

  @override
  String get achievementUnlocked => 'Conquista Desbloqueada!';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked/$total Desbloqueadas';
  }

  @override
  String get notUnlockedYet => 'Ainda não desbloqueada';

  @override
  String unlockedOn(String date) {
    return 'Desbloqueada em $date';
  }

  @override
  String get close => 'Fechar';

  @override
  String get categorySession => 'Sessões';

  @override
  String get categoryStreak => 'Sequência';

  @override
  String get categoryTime => 'Tempo de Foco';

  @override
  String get categorySpecial => 'Especial';

  @override
  String get achievementFirstSession => 'Primeiro Passo';

  @override
  String get achievementFirstSessionDesc => 'Complete sua primeira sessão de foco';

  @override
  String get achievementSessions10 => 'Começando Bem';

  @override
  String get achievementSessions10Desc => 'Complete 10 sessões de foco';

  @override
  String get achievementSessions50 => 'Dedicado';

  @override
  String get achievementSessions50Desc => 'Complete 50 sessões de foco';

  @override
  String get achievementSessions100 => 'Centurião';

  @override
  String get achievementSessions100Desc => 'Complete 100 sessões de foco';

  @override
  String get achievementSessions500 => 'Grão-Mestre';

  @override
  String get achievementSessions500Desc => 'Complete 500 sessões de foco';

  @override
  String get achievementStreak3 => 'Hat Trick';

  @override
  String get achievementStreak3Desc => 'Mantenha uma sequência de 3 dias';

  @override
  String get achievementStreak7 => 'Guerreiro da Semana';

  @override
  String get achievementStreak7Desc => 'Mantenha uma sequência de 7 dias';

  @override
  String get achievementStreak30 => 'Campeão Mensal';

  @override
  String get achievementStreak30Desc => 'Mantenha uma sequência de 30 dias';

  @override
  String get achievementTime1h => 'Primeira Hora';

  @override
  String get achievementTime1hDesc => 'Acumule 1 hora de tempo de foco';

  @override
  String get achievementTime10h => 'Investidor de Tempo';

  @override
  String get achievementTime10hDesc => 'Acumule 10 horas de tempo de foco';

  @override
  String get achievementTime100h => 'Mestre do Tempo';

  @override
  String get achievementTime100hDesc => 'Acumule 100 horas de tempo de foco';

  @override
  String get achievementEarlyBird => 'Madrugador';

  @override
  String get achievementEarlyBirdDesc => 'Complete uma sessão antes das 7h';

  @override
  String get achievementNightOwl => 'Coruja Noturna';

  @override
  String get achievementNightOwlDesc => 'Complete uma sessão após as 22h';

  @override
  String get achievementWeekendWarrior => 'Guerreiro de Fim de Semana';

  @override
  String get achievementWeekendWarriorDesc => 'Complete 5 sessões em um fim de semana';

  @override
  String get ambientSounds => 'Sons Ambiente';

  @override
  String get soundSilence => 'Silêncio';

  @override
  String get soundRain => 'Chuva';

  @override
  String get soundForest => 'Floresta';

  @override
  String get soundOcean => 'Oceano';

  @override
  String get soundCafe => 'Café';

  @override
  String get soundFireplace => 'Lareira';

  @override
  String get soundWhiteNoise => 'Ruído Branco';

  @override
  String get soundThunder => 'Trovão';

  @override
  String get colorTheme => 'Tema de Cor';

  @override
  String get themeTomato => 'Tomate';

  @override
  String get themeOcean => 'Oceano';

  @override
  String get themeForest => 'Floresta';

  @override
  String get themeLavender => 'Lavanda';

  @override
  String get themeSunset => 'Pôr do Sol';

  @override
  String get themeMidnight => 'Meia-Noite';

  @override
  String get themeRose => 'Rosa';

  @override
  String get themeMint => 'Menta';

  @override
  String get dailyGoal => 'Meta Diária';

  @override
  String get dailyGoalTarget => 'Meta Diária';

  @override
  String get goalReached => 'Meta Atingida!';

  @override
  String sessionsProgress(int completed, int target) {
    return '$completed/$target sessões';
  }

  @override
  String sessionsPerDay(int count) {
    return '$count sessões por dia';
  }

  @override
  String focusTimeToday(int minutes) {
    return '$minutes min focado hoje';
  }

  @override
  String get newQuote => 'Nova Citação';

  @override
  String get quote1Text => 'O segredo de progredir é começar.';

  @override
  String get quote1Author => 'Mark Twain';

  @override
  String get quote2Text => 'Foque em ser produtivo, não em estar ocupado.';

  @override
  String get quote2Author => 'Tim Ferriss';

  @override
  String get quote3Text => 'Não é que eu seja tão inteligente, é que eu fico com os problemas por mais tempo.';

  @override
  String get quote3Author => 'Albert Einstein';

  @override
  String get quote4Text => 'A maneira de começar é parar de falar e começar a fazer.';

  @override
  String get quote4Author => 'Walt Disney';

  @override
  String get quote5Text => 'Você não precisa ser ótimo para começar, mas precisa começar para ser ótimo.';

  @override
  String get quote5Author => 'Zig Ziglar';

  @override
  String get quote6Text => 'O sucesso é a soma de pequenos esforços repetidos dia após dia.';

  @override
  String get quote6Author => 'Robert Collier';

  @override
  String get quote7Text => 'A única maneira de fazer um ótimo trabalho é amar o que você faz.';

  @override
  String get quote7Author => 'Steve Jobs';

  @override
  String get quote8Text => 'Concentre todos os seus pensamentos no trabalho em mãos.';

  @override
  String get quote8Author => 'Alexander Graham Bell';

  @override
  String get quote9Text => 'Tempo é o que mais queremos, mas o que pior usamos.';

  @override
  String get quote9Author => 'William Penn';

  @override
  String get quote10Text => 'Ação é a chave fundamental para todo sucesso.';

  @override
  String get quote10Author => 'Pablo Picasso';

  @override
  String get quote11Text => 'Não olhe para o relógio; faça o que ele faz. Continue.';

  @override
  String get quote11Author => 'Sam Levenson';

  @override
  String get quote12Text => 'Sua limitação é apenas sua imaginação.';

  @override
  String get quote12Author => 'Desconhecido';

  @override
  String get quote13Text => 'Sonhe. Deseje. Faça.';

  @override
  String get quote13Author => 'Desconhecido';

  @override
  String get quote14Text => 'Quanto mais você trabalha, mais sorte você tem.';

  @override
  String get quote14Author => 'Gary Player';

  @override
  String get quote15Text => 'Faça hoje algo que seu eu futuro agradecerá.';

  @override
  String get quote15Author => 'Desconhecido';

  @override
  String get appearance => 'Aparência';

  @override
  String get colorfulMode => 'Modo Colorido';

  @override
  String get colorfulModeDesc => 'Use cores vibrantes e layout animado';
}
