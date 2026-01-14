import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Помодоро Таймер';

  @override
  String get focusSession => 'Сессия Фокуса';

  @override
  String get shortBreak => 'Короткий Перерыв';

  @override
  String get longBreak => 'Длинный Перерыв';

  @override
  String get start => 'Старт';

  @override
  String get pause => 'Пауза';

  @override
  String get resume => 'Продолжить';

  @override
  String get reset => 'Сброс';

  @override
  String get skip => 'Пропустить';

  @override
  String get sessions => 'Сессии';

  @override
  String get sessionsCompleted => 'Завершённые Сессии';

  @override
  String get totalFocusTime => 'Общее Время Фокуса';

  @override
  String get todayStats => 'Статистика Сегодня';

  @override
  String get weeklyStats => 'Недельная Статистика';

  @override
  String get settings => 'Настройки';

  @override
  String get focusDuration => 'Длительность Фокуса';

  @override
  String get shortBreakDuration => 'Длительность Короткого Перерыва';

  @override
  String get longBreakDuration => 'Длительность Длинного Перерыва';

  @override
  String get sessionsUntilLongBreak => 'Сессий до Длинного Перерыва';

  @override
  String get soundEnabled => 'Звук Включён';

  @override
  String get vibrationEnabled => 'Вибрация Включена';

  @override
  String get autoStartBreaks => 'Автозапуск Перерывов';

  @override
  String get autoStartFocus => 'Автозапуск Фокуса';

  @override
  String get notifications => 'Уведомления';

  @override
  String get minutes => 'минут';

  @override
  String get min => 'мин';

  @override
  String get hours => 'часов';

  @override
  String get history => 'История';

  @override
  String get statistics => 'Статистика';

  @override
  String get timer => 'Таймер';

  @override
  String get keepFocused => 'Сохраняйте Фокус!';

  @override
  String get timeForBreak => 'Время Перерыва!';

  @override
  String get breakOver => 'Перерыв Окончен!';

  @override
  String get greatJob => 'Отличная Работа!';

  @override
  String get sessionComplete => 'Сессия Завершена';

  @override
  String get ready => 'Готов';

  @override
  String get focusMode => 'Режим Фокуса';

  @override
  String get breakMode => 'Режим Перерыва';

  @override
  String get darkMode => 'Тёмный Режим';

  @override
  String get language => 'Язык';

  @override
  String get about => 'О Приложении';

  @override
  String get version => 'Версия';

  @override
  String get privacyPolicy => 'Политика Конфиденциальности';

  @override
  String get rateApp => 'Оценить Приложение';

  @override
  String get noSessionsYet => 'Пока нет сессий. Начните свой первый Помодоро!';

  @override
  String get pomodoroTechnique => 'Техника Помодоро помогает сосредоточиться, разбивая работу на интервалы, традиционно 25 минут, разделённые короткими перерывами.';

  @override
  String get getStarted => 'Начать';

  @override
  String get letsGo => 'Поехали!';

  @override
  String get streakDays => 'дней подряд';

  @override
  String get currentStreak => 'Текущая серия';

  @override
  String get bestStreak => 'Лучшая серия';

  @override
  String get days => 'дней';

  @override
  String get achievements => 'Достижения';

  @override
  String get achievementUnlocked => 'Достижение разблокировано!';

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked/$total разблокировано';
  }

  @override
  String get notUnlockedYet => 'Ещё не разблокировано';

  @override
  String unlockedOn(String date) {
    return 'Разблокировано $date';
  }

  @override
  String get close => 'Закрыть';

  @override
  String get categorySession => 'Сессии';

  @override
  String get categoryStreak => 'Серия';

  @override
  String get categoryTime => 'Время фокуса';

  @override
  String get categorySpecial => 'Особые';

  @override
  String get achievementFirstSession => 'Первый шаг';

  @override
  String get achievementFirstSessionDesc => 'Завершите первую сессию фокуса';

  @override
  String get achievementSessions10 => 'Хороший старт';

  @override
  String get achievementSessions10Desc => 'Завершите 10 сессий фокуса';

  @override
  String get achievementSessions50 => 'Преданный';

  @override
  String get achievementSessions50Desc => 'Завершите 50 сессий фокуса';

  @override
  String get achievementSessions100 => 'Сотня';

  @override
  String get achievementSessions100Desc => 'Завершите 100 сессий фокуса';

  @override
  String get achievementSessions500 => 'Гроссмейстер';

  @override
  String get achievementSessions500Desc => 'Завершите 500 сессий фокуса';

  @override
  String get achievementStreak3 => 'Хет-трик';

  @override
  String get achievementStreak3Desc => 'Достигните серии в 3 дня';

  @override
  String get achievementStreak7 => 'Недельный воин';

  @override
  String get achievementStreak7Desc => 'Достигните серии в 7 дней';

  @override
  String get achievementStreak30 => 'Месячный чемпион';

  @override
  String get achievementStreak30Desc => 'Достигните серии в 30 дней';

  @override
  String get achievementTime1h => 'Первый час';

  @override
  String get achievementTime1hDesc => 'Накопите 1 час времени фокуса';

  @override
  String get achievementTime10h => 'Инвестор времени';

  @override
  String get achievementTime10hDesc => 'Накопите 10 часов времени фокуса';

  @override
  String get achievementTime100h => 'Мастер времени';

  @override
  String get achievementTime100hDesc => 'Накопите 100 часов времени фокуса';

  @override
  String get achievementEarlyBird => 'Ранняя пташка';

  @override
  String get achievementEarlyBirdDesc => 'Завершите сессию до 7 утра';

  @override
  String get achievementNightOwl => 'Ночная сова';

  @override
  String get achievementNightOwlDesc => 'Завершите сессию после 10 вечера';

  @override
  String get achievementWeekendWarrior => 'Воин выходных';

  @override
  String get achievementWeekendWarriorDesc => 'Завершите 5 сессий в выходные';

  @override
  String get ambientSounds => 'Фоновые звуки';

  @override
  String get soundSilence => 'Тишина';

  @override
  String get soundRain => 'Дождь';

  @override
  String get soundForest => 'Лес';

  @override
  String get soundOcean => 'Океан';

  @override
  String get soundCafe => 'Кафе';

  @override
  String get soundFireplace => 'Камин';

  @override
  String get soundWhiteNoise => 'Белый шум';

  @override
  String get soundThunder => 'Гроза';

  @override
  String get colorTheme => 'Цветовая тема';

  @override
  String get themeTomato => 'Томат';

  @override
  String get themeOcean => 'Океан';

  @override
  String get themeForest => 'Лес';

  @override
  String get themeLavender => 'Лаванда';

  @override
  String get themeSunset => 'Закат';

  @override
  String get themeMidnight => 'Полночь';

  @override
  String get themeRose => 'Роза';

  @override
  String get themeMint => 'Мята';

  @override
  String get dailyGoal => 'Дневная цель';

  @override
  String get dailyGoalTarget => 'Дневная цель';

  @override
  String get goalReached => 'Цель достигнута!';

  @override
  String sessionsProgress(int completed, int target) {
    return '$completed/$target сессий';
  }

  @override
  String sessionsPerDay(int count) {
    return '$count сессий в день';
  }

  @override
  String focusTimeToday(int minutes) {
    return '$minutes минут фокуса сегодня';
  }

  @override
  String get newQuote => 'Новая цитата';

  @override
  String get quote1Text => 'Секрет движения вперёд — начать.';

  @override
  String get quote1Author => 'Марк Твен';

  @override
  String get quote2Text => 'Сосредоточьтесь на продуктивности, а не на занятости.';

  @override
  String get quote2Author => 'Тим Феррис';

  @override
  String get quote3Text => 'Я не такой умный, я просто дольше остаюсь с проблемами.';

  @override
  String get quote3Author => 'Альберт Эйнштейн';

  @override
  String get quote4Text => 'Способ начать — перестать говорить и начать делать.';

  @override
  String get quote4Author => 'Уолт Дисней';

  @override
  String get quote5Text => 'Не нужно быть великим, чтобы начать, но нужно начать, чтобы стать великим.';

  @override
  String get quote5Author => 'Зиг Зиглар';

  @override
  String get quote6Text => 'Успех — это сумма небольших усилий, повторяемых изо дня в день.';

  @override
  String get quote6Author => 'Роберт Коллиер';

  @override
  String get quote7Text => 'Единственный способ делать великую работу — любить то, что делаешь.';

  @override
  String get quote7Author => 'Стив Джобс';

  @override
  String get quote8Text => 'Сконцентрируйте все мысли на текущей задаче.';

  @override
  String get quote8Author => 'Александр Грэхем Белл';

  @override
  String get quote9Text => 'Время — то, чего мы хотим больше всего, но используем хуже всего.';

  @override
  String get quote9Author => 'Уильям Пенн';

  @override
  String get quote10Text => 'Действие — основной ключ ко всякому успеху.';

  @override
  String get quote10Author => 'Пабло Пикассо';

  @override
  String get quote11Text => 'Не смотрите на часы; делайте то, что они делают. Продолжайте двигаться.';

  @override
  String get quote11Author => 'Сэм Левенсон';

  @override
  String get quote12Text => 'Ваши ограничения — только ваше воображение.';

  @override
  String get quote12Author => 'Неизвестен';

  @override
  String get quote13Text => 'Мечтай. Желай. Делай.';

  @override
  String get quote13Author => 'Неизвестен';

  @override
  String get quote14Text => 'Чем усерднее работаешь, тем удачливее становишься.';

  @override
  String get quote14Author => 'Гэри Плейер';

  @override
  String get quote15Text => 'Сделай сегодня то, за что будущий ты скажет спасибо.';

  @override
  String get quote15Author => 'Неизвестен';
}
