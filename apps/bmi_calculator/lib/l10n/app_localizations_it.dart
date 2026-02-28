// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Calcolatore dell\'IMC';

  @override
  String get calculator => 'Calcolatrice';

  @override
  String get history => 'Storia';

  @override
  String get evolution => 'Evoluzione';

  @override
  String get weight => 'Peso (kg)';

  @override
  String get height => 'Altezza (cm)';

  @override
  String get calculate => 'Calcolare';

  @override
  String get save => 'Salva risultato';

  @override
  String get result => 'Risultato';

  @override
  String yourBmi(String bmi) {
    return 'Il tuo indice di massa corporea lo è$bmi';
  }

  @override
  String category(String category) {
    return 'Categoria:$category';
  }

  @override
  String get infoTitle => 'Informazioni sull\'IMC';

  @override
  String get infoDescription =>
      'L\'indice di massa corporea (BMI) è una misura del grasso corporeo basata sull\'altezza e sul peso che si applica a uomini e donne adulti.';

  @override
  String get source => 'Fonte: Organizzazione Mondiale della Sanità (OMS)';

  @override
  String get underweight => 'Sottopeso';

  @override
  String get normal => 'Peso normale';

  @override
  String get overweight => 'Sovrappeso';

  @override
  String get obesity1 => 'Classe di obesità I';

  @override
  String get obesity2 => 'Classe di obesità II';

  @override
  String get obesity3 => 'Classe di obesità III';

  @override
  String get delete => 'Eliminare';

  @override
  String get noHistory => 'Nessuna storia ancora';

  @override
  String get evolutionGraph => 'Grafico dell\'evoluzione';

  @override
  String get needTwoEntries =>
      'Continua a monitorare! Sono necessarie almeno 2 voci per vedere l\'evoluzione.';

  @override
  String get bmiEvolutionTitle => 'Evoluzione dell\'IMC';

  @override
  String get reset => 'Reset';

  @override
  String get resultSaved => 'Risultato salvato!';
}
