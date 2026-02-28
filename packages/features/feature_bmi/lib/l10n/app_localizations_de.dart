// ignore: unused_import
import 'package:intl/intl.dart' as intl;


// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'BMI Rechner';

  @override
  String get calculator => 'Rechner';

  @override
  String get history => 'Verlauf';

  @override
  String get evolution => 'Entwicklung';

  @override
  String get weight => 'Gewicht (kg)';

  @override
  String get height => 'Größe (cm)';

  @override
  String get calculate => 'Berechnen';

  @override
  String get save => 'Ergebnis speichern';

  @override
  String get result => 'Ergebnis';

  @override
  String yourBmi(String bmi) {
    return 'Ihr BMI ist $bmi';
  }

  @override
  String category(String category) {
    return 'Kategorie: $category';
  }

  @override
  String get infoTitle => 'BMI Informationen';

  @override
  String get infoDescription =>
      'Der Body-Mass-Index (BMI) ist ein Maß für das Körperfett auf der Grundlage von Größe und Gewicht, das für erwachsene Männer und Frauen gilt.';

  @override
  String get source => 'Quelle: Weltgesundheitsorganisation (WHO)';

  @override
  String get underweight => 'Untergewicht';

  @override
  String get normal => 'Normalgewicht';

  @override
  String get overweight => 'Übergewicht';

  @override
  String get obesity1 => 'Adipositas Grad I';

  @override
  String get obesity2 => 'Adipositas Grad II';

  @override
  String get obesity3 => 'Adipositas Grad III';

  @override
  String get delete => 'Löschen';

  @override
  String get noHistory => 'Noch kein Verlauf';

  @override
  String get evolutionGraph => 'Entwicklungsdiagramm';

  @override
  String get needTwoEntries =>
      'Weiter aufzeichnen! Sie benötigen mindestens 2 Einträge, um die Entwicklung zu sehen.';

  @override
  String get bmiEvolutionTitle => 'BMI Entwicklung';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get resultSaved => 'Ergebnis gespeichert!';
}
