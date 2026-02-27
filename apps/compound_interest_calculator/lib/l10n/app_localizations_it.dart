// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Interesse Composto';

  @override
  String get calculate => 'Calcola';

  @override
  String get reset => 'Reimposta';

  @override
  String get save => 'Salva';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Elimina';

  @override
  String get close => 'Chiudi';

  @override
  String get settings => 'Impostazioni';

  @override
  String get history => 'Cronologia';

  @override
  String get chart => 'Grafico';

  @override
  String get details => 'Dettagli';

  @override
  String get initialCapital => 'Capitale Iniziale';

  @override
  String get interestRate => 'Tasso d\'Interesse (% annuo)';

  @override
  String get investmentPeriod => 'Periodo d\'Investimento';

  @override
  String get monthlyContribution => 'Contributo Mensile';

  @override
  String get months => 'Mesi';

  @override
  String get years => 'Anni';

  @override
  String get optional => 'Opzionale';

  @override
  String get calculationName => 'Nome Calcolo';

  @override
  String get calculationNameHint => 'Inserisci un nome';

  @override
  String get calculationSaved => 'Calcolo salvato';

  @override
  String get requiredField => 'Campo obbligatorio';

  @override
  String get invalidNumber => 'Numero non valido';

  @override
  String get invalidRate => 'Tasso non valido';

  @override
  String get totalAmount => 'Importo Totale';

  @override
  String get totalContributed => 'Totale Investito';

  @override
  String get totalInterest => 'Interesse Totale';

  @override
  String get percentageGain => 'Guadagno Percentuale';

  @override
  String get result => 'Risultato';

  @override
  String get viewChart => 'Vedi grafico';

  @override
  String get growthChart => 'Grafico di crescita';

  @override
  String get month => 'Mese';

  @override
  String get monthlyBreakdown => 'Ripartizione Mensile';

  @override
  String get balanceEvolution => 'Evoluzione Saldo';

  @override
  String get investmentPresets => 'Preimpostazioni Investimento';

  @override
  String get presetPoupanca => 'Conto Risparmio';

  @override
  String get presetPoupancaDesc =>
      'Basso rischio, basso rendimento (6,17% annuo)';

  @override
  String get presetCDI => 'CDI 100%';

  @override
  String get presetCDIDesc => 'Conservativo post-fisso (10,65% annuo)';

  @override
  String get presetTesouroSelic => 'Tesouro Selic';

  @override
  String get presetTesouroSelicDesc =>
      'Obbligazioni governative (10,75% annuo)';

  @override
  String get presetTesouroIPCA => 'Tesouro IPCA+';

  @override
  String get presetTesouroIPCADesc => 'Protezione inflazione (6,50% + IPCA)';

  @override
  String get presetCDB => 'CDB';

  @override
  String get presetCDBDesc => 'Certificato deposito bancario (11,50% annuo)';

  @override
  String get presetLCILCA => 'LCI/LCA';

  @override
  String get presetLCILCADesc => 'Immobiliare/agricolo esentasse (9,00% annuo)';

  @override
  String get calculationHistory => 'Cronologia Calcoli';

  @override
  String get noHistory => 'Nessun calcolo ancora';

  @override
  String get deleteConfirm => 'Eliminare questo calcolo?';

  @override
  String get clearHistory => 'Cancella Tutta la Cronologia';

  @override
  String get clearHistoryConfirm => 'Eliminare tutti i calcoli?';

  @override
  String get achievements => 'Traguardi';

  @override
  String get achievementUnlocked => 'Traguardo Sbloccato!';

  @override
  String get achievementsProgress => 'Progresso';

  @override
  String get notUnlockedYet => 'Non ancora sbloccato';

  @override
  String get unlockedOn => 'Sbloccato il';

  @override
  String get categoryCalculations => 'Calcoli';

  @override
  String get categoryStreak => 'Serie';

  @override
  String get categoryAmounts => 'Importi';

  @override
  String get categorySpecial => 'Speciale';

  @override
  String get achievementFirstCalc => 'Primo Calcolo';

  @override
  String get achievementFirstCalcDesc => 'Completa il tuo primo calcolo';

  @override
  String get achievementCalc10 => '10 Calcoli';

  @override
  String get achievementCalc10Desc => 'Completa 10 calcoli';

  @override
  String get achievementCalc50 => '50 Calcoli';

  @override
  String get achievementCalc50Desc => 'Completa 50 calcoli';

  @override
  String get achievementCalc100 => 'Centenario';

  @override
  String get achievementCalc100Desc => 'Completa 100 calcoli';

  @override
  String get achievementStreak3 => 'Serie di 3 Giorni';

  @override
  String get achievementStreak3Desc => 'Usa l\'app per 3 giorni consecutivi';

  @override
  String get achievementStreak7 => 'Guerriero della Settimana';

  @override
  String get achievementStreak7Desc => 'Usa l\'app per 7 giorni consecutivi';

  @override
  String get achievementStreak30 => 'Maestro del Mese';

  @override
  String get achievementStreak30Desc => 'Usa l\'app per 30 giorni consecutivi';

  @override
  String get achievementMillion => 'Primo Milione';

  @override
  String get achievementMillionDesc => 'Calcola raggiungendo R\$ 1.000.000';

  @override
  String get achievementTenMillion => 'Club dei Dieci Milioni';

  @override
  String get achievementTenMillionDesc => 'Calcola raggiungendo R\$ 10.000.000';

  @override
  String get achievementLongTerm => 'Pensatore a Lungo Termine';

  @override
  String get achievementLongTermDesc => 'Calcola un investimento di 10+ anni';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count giorni',
      one: '1 giorno',
    );
    return '$_temp0';
  }

  @override
  String get currentStreak => 'Serie Attuale';

  @override
  String get bestStreak => 'Migliore Serie';

  @override
  String get days => 'giorni';

  @override
  String get dailyGoal => 'Obiettivo Giornaliero';

  @override
  String get dailyGoalTarget => 'Obiettivo Calcoli';

  @override
  String get goalReached => 'Obiettivo Raggiunto!';

  @override
  String calculationsProgress(int completed, int target) {
    return '$completed/$target calcoli';
  }

  @override
  String get calculationsPerDay => 'calcoli al giorno';

  @override
  String get colorTheme => 'Tema Colori';

  @override
  String get themeGreen => 'Verde';

  @override
  String get themeBlue => 'Blu';

  @override
  String get themePurple => 'Viola';

  @override
  String get themeOrange => 'Arancione';

  @override
  String get themeTeal => 'Turchese';

  @override
  String get themeIndigo => 'Indaco';

  @override
  String get themeRed => 'Rosso';

  @override
  String get themeAmber => 'Ambra';
}
