// ignore: unused_import
import 'package:intl/intl.dart' as intl;


// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'ИМТ Калькулятор';

  @override
  String get calculator => 'Калькулятор';

  @override
  String get history => 'История';

  @override
  String get evolution => 'Эволюция';

  @override
  String get weight => 'Вес (кг)';

  @override
  String get height => 'Рост (см)';

  @override
  String get calculate => 'Рассчитать';

  @override
  String get save => 'Сохранить';

  @override
  String get result => 'Результат';

  @override
  String yourBmi(String bmi) {
    return 'Ваш ИМТ: $bmi';
  }

  @override
  String category(String category) {
    return 'Категория: $category';
  }

  @override
  String get infoTitle => 'Информация об ИМТ';

  @override
  String get infoDescription =>
      'Индекс массы тела (ИМТ) — это показатель жира в организме, основанный на росте и весе, который применяется к взрослым мужчинам и женщинам.';

  @override
  String get source => 'Источник: Всемирная организация здравоохранения (ВОЗ)';

  @override
  String get underweight => 'Недостаточный вес';

  @override
  String get normal => 'Нормальный вес';

  @override
  String get overweight => 'Избыточный вес';

  @override
  String get obesity1 => 'Ожирение I степени';

  @override
  String get obesity2 => 'Ожирение II степени';

  @override
  String get obesity3 => 'Ожирение III степени';

  @override
  String get delete => 'Удалить';

  @override
  String get noHistory => 'История пуста';

  @override
  String get evolutionGraph => 'График эволюции';

  @override
  String get needTwoEntries =>
      'Продолжайте записывать! Для просмотра эволюции необходимо минимум 2 записи.';

  @override
  String get bmiEvolutionTitle => 'Эволюция ИМТ';

  @override
  String get reset => 'Сброс';

  @override
  String get resultSaved => 'Результат сохранен!';
}
