// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Zinseszins';

  @override
  String get calculate => 'Berechnen';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get save => 'Speichern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get delete => 'Löschen';

  @override
  String get close => 'Schließen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get history => 'Verlauf';

  @override
  String get chart => 'Diagramm';

  @override
  String get details => 'Details';

  @override
  String get initialCapital => 'Anfangskapital';

  @override
  String get interestRate => 'Zinssatz (% pro Jahr)';

  @override
  String get investmentPeriod => 'Anlagezeitraum';

  @override
  String get monthlyContribution => 'Monatliche Einzahlung';

  @override
  String get months => 'Monate';

  @override
  String get years => 'Jahre';

  @override
  String get optional => 'Optional';

  @override
  String get calculationName => 'Berechnungsname';

  @override
  String get calculationNameHint => 'Namen eingeben';

  @override
  String get calculationSaved => 'Berechnung gespeichert';

  @override
  String get requiredField => 'Pflichtfeld';

  @override
  String get invalidNumber => 'Ungültige Zahl';

  @override
  String get invalidRate => 'Ungültiger Zinssatz';

  @override
  String get totalAmount => 'Gesamtbetrag';

  @override
  String get totalContributed => 'Gesamteinlage';

  @override
  String get totalInterest => 'Gesamtzinsen';

  @override
  String get percentageGain => 'Prozentualer Gewinn';

  @override
  String get result => 'Ergebnis';

  @override
  String get viewChart => 'Diagramm ansehen';

  @override
  String get growthChart => 'Wachstumsdiagramm';

  @override
  String get month => 'Monat';

  @override
  String get monthlyBreakdown => 'Monatliche Entwicklung';

  @override
  String get balanceEvolution => 'Saldoentwicklung';

  @override
  String get investmentPresets => 'Anlage-Voreinstellungen';

  @override
  String get presetPoupanca => 'Sparkonto';

  @override
  String get presetPoupancaDesc =>
      'Geringes Risiko, geringe Rendite (6,17% p.a.)';

  @override
  String get presetCDI => 'CDI 100%';

  @override
  String get presetCDIDesc => 'Konservativ nachträglich (10,65% p.a.)';

  @override
  String get presetTesouroSelic => 'Tesouro Selic';

  @override
  String get presetTesouroSelicDesc => 'Staatsanleihen (10,75% p.a.)';

  @override
  String get presetTesouroIPCA => 'Tesouro IPCA+';

  @override
  String get presetTesouroIPCADesc => 'Inflationsschutz (6,50% + IPCA)';

  @override
  String get presetCDB => 'CDB';

  @override
  String get presetCDBDesc => 'Bankdepositenzertifikat (11,50% p.a.)';

  @override
  String get presetLCILCA => 'LCI/LCA';

  @override
  String get presetLCILCADesc => 'Steuerfrei Immobilien/Agrar (9,00% p.a.)';

  @override
  String get calculationHistory => 'Berechnungsverlauf';

  @override
  String get noHistory => 'Noch keine Berechnungen';

  @override
  String get deleteConfirm => 'Diese Berechnung löschen?';

  @override
  String get clearHistory => 'Gesamten Verlauf löschen';

  @override
  String get clearHistoryConfirm => 'Alle Berechnungen löschen?';

  @override
  String get achievements => 'Erfolge';

  @override
  String get achievementUnlocked => 'Erfolg freigeschaltet!';

  @override
  String get achievementsProgress => 'Fortschritt';

  @override
  String get notUnlockedYet => 'Noch nicht freigeschaltet';

  @override
  String get unlockedOn => 'Freigeschaltet am';

  @override
  String get categoryCalculations => 'Berechnungen';

  @override
  String get categoryStreak => 'Série';

  @override
  String get categoryAmounts => 'Beträge';

  @override
  String get categorySpecial => 'Besonders';

  @override
  String get achievementFirstCalc => 'Erste Berechnung';

  @override
  String get achievementFirstCalcDesc => 'Schließe deine erste Berechnung ab';

  @override
  String get achievementCalc10 => '10 Berechnungen';

  @override
  String get achievementCalc10Desc => 'Schließe 10 Berechnungen ab';

  @override
  String get achievementCalc50 => '50 Berechnungen';

  @override
  String get achievementCalc50Desc => 'Schließe 50 Berechnungen ab';

  @override
  String get achievementCalc100 => 'Jahrhundert';

  @override
  String get achievementCalc100Desc => 'Schließe 100 Berechnungen ab';

  @override
  String get achievementStreak3 => '3-Tage-Serie';

  @override
  String get achievementStreak3Desc => 'Nutze die App 3 Tage hintereinander';

  @override
  String get achievementStreak7 => 'Wochenkrieger';

  @override
  String get achievementStreak7Desc => 'Nutze die App 7 Tage hintereinander';

  @override
  String get achievementStreak30 => 'Monatsmeister';

  @override
  String get achievementStreak30Desc => 'Nutze die App 30 Tage hintereinander';

  @override
  String get achievementMillion => 'Erste Million';

  @override
  String get achievementMillionDesc =>
      'Berechne das Erreichen von R\$ 1.000.000';

  @override
  String get achievementTenMillion => 'Zehn-Millionen-Club';

  @override
  String get achievementTenMillionDesc =>
      'Berechne das Erreichen von R\$ 10.000.000';

  @override
  String get achievementLongTerm => 'Langfristdenker';

  @override
  String get achievementLongTermDesc =>
      'Berechne eine Investition von 10+ Jahren';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get currentStreak => 'Aktuelle Serie';

  @override
  String get bestStreak => 'Beste Serie';

  @override
  String get days => 'Tage';

  @override
  String get dailyGoal => 'Tagesziel';

  @override
  String get dailyGoalTarget => 'Ziel Berechnungen';

  @override
  String get goalReached => 'Ziel erreicht!';

  @override
  String calculationsProgress(int completed, int target) {
    return '$completed/$target Berechnungen';
  }

  @override
  String get calculationsPerDay => 'Berechnungen pro Tag';

  @override
  String get colorTheme => 'Farbthema';

  @override
  String get themeGreen => 'Grün';

  @override
  String get themeBlue => 'Blau';

  @override
  String get themePurple => 'Lila';

  @override
  String get themeOrange => 'Orange';

  @override
  String get themeTeal => 'Türkis';

  @override
  String get themeIndigo => 'Indigo';

  @override
  String get themeRed => 'Rot';

  @override
  String get themeAmber => 'Bernstein';
}
