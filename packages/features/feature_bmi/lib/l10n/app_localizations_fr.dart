// ignore: unused_import
import 'package:intl/intl.dart' as intl;


// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Calculateur IMC';

  @override
  String get calculator => 'Calculatrice';

  @override
  String get history => 'Historique';

  @override
  String get evolution => 'Évolution';

  @override
  String get weight => 'Poids (kg)';

  @override
  String get height => 'Taille (cm)';

  @override
  String get calculate => 'Calculer';

  @override
  String get save => 'Enregistrer le résultat';

  @override
  String get result => 'Résultat';

  @override
  String yourBmi(String bmi) {
    return 'Votre IMC est $bmi';
  }

  @override
  String category(String category) {
    return 'Catégorie : $category';
  }

  @override
  String get infoTitle => 'Informations IMC';

  @override
  String get infoDescription =>
      'L\'indice de masse corporelle (IMC) est une mesure de la graisse corporelle basée sur la taille et le poids qui s\'applique aux hommes et aux femmes adultes.';

  @override
  String get source => 'Source : Organisation mondiale de la Santé (OMS)';

  @override
  String get underweight => 'Insuffisance pondérale';

  @override
  String get normal => 'Poids normal';

  @override
  String get overweight => 'Surpoids';

  @override
  String get obesity1 => 'Obésité Classe I';

  @override
  String get obesity2 => 'Obésité Classe II';

  @override
  String get obesity3 => 'Obésité Classe III';

  @override
  String get delete => 'Supprimer';

  @override
  String get noHistory => 'Aucun historique pour le moment';

  @override
  String get evolutionGraph => 'Graphique d\'évolution';

  @override
  String get needTwoEntries =>
      'Continuez à enregistrer ! Vous avez besoin d\'au moins 2 entrées pour voir l\'évolution.';

  @override
  String get bmiEvolutionTitle => 'Évolution de l\'IMC';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get resultSaved => 'Résultat enregistré !';
}
