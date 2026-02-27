// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Intérêt Composé';

  @override
  String get calculate => 'Calculer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get delete => 'Supprimer';

  @override
  String get close => 'Fermer';

  @override
  String get settings => 'Paramètres';

  @override
  String get history => 'Historique';

  @override
  String get chart => 'Graphique';

  @override
  String get details => 'Détails';

  @override
  String get initialCapital => 'Capital Initial';

  @override
  String get interestRate => 'Taux d\'Intérêt (% par an)';

  @override
  String get investmentPeriod => 'Période d\'Investissement';

  @override
  String get monthlyContribution => 'Contribution Mensuelle';

  @override
  String get months => 'Mois';

  @override
  String get years => 'Années';

  @override
  String get optional => 'Optionnel';

  @override
  String get calculationName => 'Nom du Calcul';

  @override
  String get calculationNameHint => 'Entrez un nom';

  @override
  String get calculationSaved => 'Calcul enregistré';

  @override
  String get requiredField => 'Champ obligatoire';

  @override
  String get invalidNumber => 'Nombre invalide';

  @override
  String get invalidRate => 'Taux invalide';

  @override
  String get totalAmount => 'Montant Total';

  @override
  String get totalContributed => 'Total Investi';

  @override
  String get totalInterest => 'Total des Intérêts';

  @override
  String get percentageGain => 'Gain en Pourcentage';

  @override
  String get result => 'Résultat';

  @override
  String get viewChart => 'Voir le graphique';

  @override
  String get growthChart => 'Graphique de croissance';

  @override
  String get month => 'Mois';

  @override
  String get monthlyBreakdown => 'Évolution Mensuelle';

  @override
  String get balanceEvolution => 'Évolution du Solde';

  @override
  String get investmentPresets => 'Préréglages d\'Investissement';

  @override
  String get presetPoupanca => 'Compte Épargne';

  @override
  String get presetPoupancaDesc =>
      'Faible risque, faible rendement (6,17% par an)';

  @override
  String get presetCDI => 'CDI 100%';

  @override
  String get presetCDIDesc => 'Conservateur post-fixé (10,65% par an)';

  @override
  String get presetTesouroSelic => 'Tesouro Selic';

  @override
  String get presetTesouroSelicDesc => 'Obligations d\'État (10,75% par an)';

  @override
  String get presetTesouroIPCA => 'Tesouro IPCA+';

  @override
  String get presetTesouroIPCADesc => 'Protection inflation (6,50% + IPCA)';

  @override
  String get presetCDB => 'CDB';

  @override
  String get presetCDBDesc => 'Certificat de dépôt bancaire (11,50% par an)';

  @override
  String get presetLCILCA => 'LCI/LCA';

  @override
  String get presetLCILCADesc =>
      'Immobilier/agro exonéré d\'impôt (9,00% par an)';

  @override
  String get calculationHistory => 'Historique des Calculs';

  @override
  String get noHistory => 'Aucun calcul encore';

  @override
  String get deleteConfirm => 'Supprimer ce calcul?';

  @override
  String get clearHistory => 'Effacer Tout l\'Historique';

  @override
  String get clearHistoryConfirm => 'Supprimer tous les calculs?';

  @override
  String get achievements => 'Succès';

  @override
  String get achievementUnlocked => 'Succès Débloqué!';

  @override
  String get achievementsProgress => 'Progrès';

  @override
  String get notUnlockedYet => 'Pas encore débloqué';

  @override
  String get unlockedOn => 'Débloqué le';

  @override
  String get categoryCalculations => 'Calculs';

  @override
  String get categoryStreak => 'Série';

  @override
  String get categoryAmounts => 'Montants';

  @override
  String get categorySpecial => 'Spécial';

  @override
  String get achievementFirstCalc => 'Premier Calcul';

  @override
  String get achievementFirstCalcDesc => 'Complétez votre premier calcul';

  @override
  String get achievementCalc10 => '10 Calculs';

  @override
  String get achievementCalc10Desc => 'Complétez 10 calculs';

  @override
  String get achievementCalc50 => '50 Calculs';

  @override
  String get achievementCalc50Desc => 'Complétez 50 calculs';

  @override
  String get achievementCalc100 => 'Centenaire';

  @override
  String get achievementCalc100Desc => 'Complétez 100 calculs';

  @override
  String get achievementStreak3 => 'Série de 3 Jours';

  @override
  String get achievementStreak3Desc =>
      'Utilisez l\'application pendant 3 jours consécutifs';

  @override
  String get achievementStreak7 => 'Guerrier de la Semaine';

  @override
  String get achievementStreak7Desc =>
      'Utilisez l\'application pendant 7 jours consécutifs';

  @override
  String get achievementStreak30 => 'Maître du Mois';

  @override
  String get achievementStreak30Desc =>
      'Utilisez l\'application pendant 30 jours consécutifs';

  @override
  String get achievementMillion => 'Premier Million';

  @override
  String get achievementMillionDesc => 'Calculez pour atteindre R\$ 1.000.000';

  @override
  String get achievementTenMillion => 'Club des Dix Millions';

  @override
  String get achievementTenMillionDesc =>
      'Calculez pour atteindre R\$ 10.000.000';

  @override
  String get achievementLongTerm => 'Penseur à Long Terme';

  @override
  String get achievementLongTermDesc => 'Calculez un investissement de 10+ ans';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String get currentStreak => 'Série Actuelle';

  @override
  String get bestStreak => 'Meilleure Série';

  @override
  String get days => 'jours';

  @override
  String get dailyGoal => 'Objectif Quotidien';

  @override
  String get dailyGoalTarget => 'Objectif de Calculs';

  @override
  String get goalReached => 'Objectif Atteint!';

  @override
  String calculationsProgress(int completed, int target) {
    return '$completed/$target calculs';
  }

  @override
  String get calculationsPerDay => 'calculs par jour';

  @override
  String get colorTheme => 'Thème de Couleur';

  @override
  String get themeGreen => 'Vert';

  @override
  String get themeBlue => 'Bleu';

  @override
  String get themePurple => 'Violet';

  @override
  String get themeOrange => 'Orange';

  @override
  String get themeTeal => 'Sarcelle';

  @override
  String get themeIndigo => 'Indigo';

  @override
  String get themeRed => 'Rouge';

  @override
  String get themeAmber => 'Ambre';
}
