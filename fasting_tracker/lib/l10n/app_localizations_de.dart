// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Fasten-Tracker';

  @override
  String get settings => 'Einstellungen';

  @override
  String get history => 'Verlauf';

  @override
  String get achievements => 'Erfolge';

  @override
  String get close => 'Schließen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get ofPreposition => 'von';

  @override
  String get readyToFast => 'Bereit zum Fasten';

  @override
  String get complete => 'Abschließen';

  @override
  String get endEarly => 'Früher beenden';

  @override
  String get cancelFastingConfirm =>
      'Möchten Sie diese Fastensitzung wirklich abbrechen? Der Fortschritt geht verloren.';

  @override
  String get noHistory => 'Noch kein Fastenverlauf';

  @override
  String get totalHours => 'Gesamtstunden';

  @override
  String get openSource => 'Open Source';

  @override
  String get openSourceDesc => 'Erstellt mit Flutter';

  @override
  String get startFasting => 'Fasten starten';

  @override
  String get endFasting => 'Fasten beenden';

  @override
  String get cancelFasting => 'Fasten abbrechen';

  @override
  String get fastingInProgress => 'Fasten läuft';

  @override
  String get fastingCompleted => 'Fasten abgeschlossen!';

  @override
  String get timeRemaining => 'Verbleibende Zeit';

  @override
  String get timeElapsed => 'Verstrichene Zeit';

  @override
  String get targetReached => 'Ziel erreicht!';

  @override
  String get selectProtocol => 'Protokoll auswählen';

  @override
  String get protocol12_12 => '12:12';

  @override
  String get protocol12_12Desc => '12 Std. Fasten, 12 Std. Essen';

  @override
  String get protocol14_10 => '14:10';

  @override
  String get protocol14_10Desc => '14 Std. Fasten, 10 Std. Essen';

  @override
  String get protocol16_8 => '16:8';

  @override
  String get protocol16_8Desc => '16 Std. Fasten, 8 Std. Essen (Beliebt)';

  @override
  String get protocol18_6 => '18:6';

  @override
  String get protocol18_6Desc => '18 Std. Fasten, 6 Std. Essen';

  @override
  String get protocol20_4 => '20:4';

  @override
  String get protocol20_4Desc => '20 Std. Fasten, 4 Std. Essen (Krieger)';

  @override
  String get protocol23_1 => '23:1';

  @override
  String get protocol23_1Desc => '23 Std. Fasten, 1 Std. Essen (OMAD)';

  @override
  String get metabolicStages => 'Stoffwechselphasen';

  @override
  String get stageFed => 'Gesättigter Zustand';

  @override
  String get stageFedDesc => 'Körper verdaut Nahrung, Insulin erhöht';

  @override
  String get stageEarlyFasting => 'Frühes Fasten';

  @override
  String get stageEarlyFastingDesc =>
      'Blutzucker stabilisiert sich, Glykogen wird verwendet';

  @override
  String get stageFatBurning => 'Fettverbrennung';

  @override
  String get stageFatBurningDesc => 'Körper wechselt zu Fett als Energiequelle';

  @override
  String get stageKetosis => 'Ketose';

  @override
  String get stageKetosisDesc =>
      'Ketonproduktion, verbesserte geistige Klarheit';

  @override
  String get stageDeepKetosis => 'Tiefe Ketose';

  @override
  String get stageDeepKetosisDesc =>
      'Maximale Fettverbrennung, Wachstumshormon-Boost';

  @override
  String get stageAutophagy => 'Autophagie';

  @override
  String get stageAutophagyDesc => 'Zelluläre Reinigung und Regeneration';

  @override
  String get currentStage => 'Aktuelle Phase';

  @override
  String stageStartsAt(int hours) {
    return 'Beginnt bei $hours Std.';
  }

  @override
  String get healthInfo => 'Gesundheitsinformationen';

  @override
  String get benefits => 'Vorteile';

  @override
  String get warnings => 'Warnungen & Vorsichtsmaßnahmen';

  @override
  String get tips => 'Tipps für den Erfolg';

  @override
  String get benefitWeightLoss => 'Fördert Gewichtsverlust und Fettverbrennung';

  @override
  String get benefitInsulin => 'Verbessert die Insulinempfindlichkeit';

  @override
  String get benefitBrain => 'Verbessert Gehirnfunktion und geistige Klarheit';

  @override
  String get benefitHeart => 'Unterstützt die Herzgesundheit';

  @override
  String get benefitCellRepair => 'Aktiviert Zellreparatur (Autophagie)';

  @override
  String get benefitInflammation => 'Reduziert Entzündungen';

  @override
  String get benefitLongevity => 'Kann die Langlebigkeit fördern';

  @override
  String get benefitMetabolism => 'Verbessert die Stoffwechselgesundheit';

  @override
  String get warningPregnant =>
      'Nicht empfohlen während Schwangerschaft oder Stillzeit';

  @override
  String get warningDiabetes => 'Bei Diabetes Arzt konsultieren';

  @override
  String get warningMedication => 'Bei Medikamenteneinnahme Arzt konsultieren';

  @override
  String get warningEatingDisorder =>
      'Bei Essstörungen in der Vorgeschichte vermeiden';

  @override
  String get warningChildren => 'Nicht geeignet für Kinder oder Jugendliche';

  @override
  String get warningUnderweight => 'Nicht empfohlen bei Untergewicht';

  @override
  String get warningMedical => 'Vor Beginn Arzt konsultieren';

  @override
  String get tipHydration => 'Während des Fastens gut hydriert bleiben';

  @override
  String get tipGradual => 'Mit kürzeren Fastenperioden beginnen';

  @override
  String get tipNutrition =>
      'Auf nahrhafte Lebensmittel während des Essensfensters konzentrieren';

  @override
  String get tipListenBody => 'Auf Ihren Körper hören und bei Bedarf anpassen';

  @override
  String get sourceInfo =>
      'Informationen basierend auf Forschung von Johns Hopkins Medicine und Harvard Health';

  @override
  String get currentStreak => 'Aktuelle Serie';

  @override
  String get bestStreak => 'Beste Serie';

  @override
  String get totalFasts => 'Gesamte Fastenzeiten';

  @override
  String get daysUnit => 'Tage';

  @override
  String get dayUnit => 'Tag';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tage',
      one: 'Tag',
    );
    return '$count $_temp0';
  }

  @override
  String achievementsProgress(int unlocked, int total) {
    return '$unlocked von $total freigeschaltet';
  }

  @override
  String get achievementUnlocked => 'Erfolg freigeschaltet!';

  @override
  String get notUnlockedYet => 'Noch nicht freigeschaltet';

  @override
  String unlockedOn(String date) {
    return 'Freigeschaltet am $date';
  }

  @override
  String get categorySession => 'Sitzungen';

  @override
  String get categoryStreak => 'Serien';

  @override
  String get categoryTime => 'Zeit';

  @override
  String get categorySpecial => 'Spezial';

  @override
  String get achievementFirstFast => 'Erstes Fasten';

  @override
  String get achievementFirstFastDesc =>
      'Schließen Sie Ihre erste Fastensitzung ab';

  @override
  String get achievement10Fasts => 'Engagierter Faster';

  @override
  String get achievement10FastsDesc => '10 Fastensitzungen abschließen';

  @override
  String get achievement50Fasts => 'Fasten-Profi';

  @override
  String get achievement50FastsDesc => '50 Fastensitzungen abschließen';

  @override
  String get achievement100Fasts => 'Fasten-Meister';

  @override
  String get achievement100FastsDesc => '100 Fastensitzungen abschließen';

  @override
  String get achievementStreak3 => 'Guter Start';

  @override
  String get achievementStreak3Desc => 'Eine 3-Tage-Serie beibehalten';

  @override
  String get achievementStreak7 => 'Wochen-Krieger';

  @override
  String get achievementStreak7Desc => 'Eine 7-Tage-Serie beibehalten';

  @override
  String get achievementStreak30 => 'Monats-Champion';

  @override
  String get achievementStreak30Desc => 'Eine 30-Tage-Serie beibehalten';

  @override
  String get achievement24Hours => 'Ganztägiges Fasten';

  @override
  String get achievement24HoursDesc => 'Ein 24-Stunden-Fasten abschließen';

  @override
  String get achievement25Fasts => 'Fasten-Enthusiast';

  @override
  String get achievement25FastsDesc => '25 Fastensitzungen abschließen';

  @override
  String get achievement100Hours => 'Jahrhundertclub';

  @override
  String get achievement100HoursDesc => '100 Stunden Fasten sammeln';

  @override
  String get achievement500Hours => '500-Stunden-Held';

  @override
  String get achievement500HoursDesc => '500 Stunden Fasten sammeln';

  @override
  String get achievementStreak14 => 'Zwei-Wochen-Champion';

  @override
  String get achievementStreak14Desc => 'Eine 14-Tage-Serie beibehalten';

  @override
  String get achievementKetosis => 'Ketose-Erreicher';

  @override
  String get achievementKetosisDesc =>
      'Die Ketose-Phase erreichen (18+ Stunden)';

  @override
  String get achievementAutophagy => 'Autophagie-Erreicher';

  @override
  String get achievementAutophagyDesc =>
      'Die Autophagie-Phase erreichen (48+ Stunden)';

  @override
  String get achievementEarlyBird => 'Frühaufsteher';

  @override
  String get achievementEarlyBirdDesc =>
      'Ein Fasten vor 8 Uhr morgens beginnen';

  @override
  String get achievementNightOwl => 'Nachteule';

  @override
  String get achievementNightOwlDesc => 'Ein Fasten nach 22 Uhr abschließen';

  @override
  String get achievementWeekend => 'Wochenend-Krieger';

  @override
  String get achievementWeekendDesc => 'Ein Fasten am Wochenende abschließen';

  @override
  String get achievementPerfectWeek => 'Perfekte Woche';

  @override
  String get achievementPerfectWeekDesc =>
      '7 Fastenzeiten in einer Woche abschließen';

  @override
  String get colorTheme => 'Farbthema';

  @override
  String get themeForest => 'Wald';

  @override
  String get themeOcean => 'Ozean';

  @override
  String get themeSunset => 'Sonnenuntergang';

  @override
  String get themeLavender => 'Lavendel';

  @override
  String get themeMidnight => 'Mitternacht';

  @override
  String get themeRose => 'Rose';

  @override
  String get themeMint => 'Minze';

  @override
  String get themeAmber => 'Bernstein';

  @override
  String get noFastingHistory => 'Noch kein Fastenverlauf';

  @override
  String get startFirstFast =>
      'Starten Sie Ihr erstes Fasten, um Ihren Fortschritt zu sehen';

  @override
  String get fastingHistory => 'Fastenverlauf';

  @override
  String get totalFastingTime => 'Gesamte Fastenzeit';

  @override
  String get averageFastDuration => 'Durchschnittliche Dauer';

  @override
  String get longestFast => 'Längstes Fasten';

  @override
  String hours(int count) {
    return '$count Std.';
  }

  @override
  String minutes(int count) {
    return '$count Min.';
  }

  @override
  String hoursMinutes(int hours, int minutes) {
    return '$hours Std. $minutes Min.';
  }

  @override
  String get completed => 'Abgeschlossen';

  @override
  String get cancelled => 'Abgebrochen';

  @override
  String get inProgress => 'In Bearbeitung';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get language => 'Sprache';

  @override
  String get languageDefault => 'Systemstandard';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get enableReminders => 'Erinnerungen aktivieren';

  @override
  String get reminderTime => 'Erinnerungszeit';

  @override
  String get notificationGoalReachedTitle => 'Ziel erreicht! 🎉';

  @override
  String get notificationGoalReachedBody =>
      'Sie haben Ihr Fastenziel erfolgreich erreicht!';

  @override
  String get about => 'Über';

  @override
  String get version => 'Version';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get termsOfService => 'Nutzungsbedingungen';

  @override
  String get rateApp => 'App bewerten';

  @override
  String get shareApp => 'App teilen';

  @override
  String get healthInfoTitle => 'Intervallfasten';

  @override
  String get healthInfoSubtitle => 'Wissenschaftlich fundierte Informationen';

  @override
  String get benefitsTitle => 'Gesundheitsvorteile';

  @override
  String get warningsTitle => 'Warnungen & Vorsichtsmaßnahmen';

  @override
  String get tipsTitle => 'Tipps für den Erfolg';

  @override
  String get sources => 'Quellen';

  @override
  String get disclaimer =>
      'Diese App dient nur zu Informationszwecken. Konsultieren Sie immer einen Arzt, bevor Sie ein Fastenregime beginnen.';

  @override
  String get benefitWeightTitle => 'Gewichtsmanagement';

  @override
  String get benefitWeightDesc =>
      'Intervallfasten kann helfen, Körpergewicht und Körperfett zu reduzieren, indem es die Kalorienzufuhr begrenzt und den Stoffwechsel ankurbelt.';

  @override
  String get benefitBloodPressureTitle => 'Blutdruck';

  @override
  String get benefitBloodPressureDesc =>
      'Studien zeigen, dass Fasten helfen kann, den Blutdruck zu senken und die Ruheherzfrequenz zu verbessern.';

  @override
  String get benefitHeartHealthTitle => 'Herzgesundheit';

  @override
  String get benefitHeartHealthDesc =>
      'Fasten kann kardiovaskuläre Gesundheitsmarker verbessern, einschließlich Cholesterinspiegel und Entzündungsmarker.';

  @override
  String get benefitDiabetesTitle => 'Blutzuckerkontrolle';

  @override
  String get benefitDiabetesDesc =>
      'Intervallfasten kann die Insulinempfindlichkeit verbessern und bei der Behandlung von Typ-2-Diabetes helfen.';

  @override
  String get benefitCognitiveTitle => 'Gehirnfunktion';

  @override
  String get benefitCognitiveDesc =>
      'Fasten stimuliert die Produktion von BDNF, einem Protein, das die Gehirngesundheit und kognitive Funktion unterstützt.';

  @override
  String get benefitTissueTitle => 'Gewebegesundheit';

  @override
  String get benefitTissueDesc =>
      'Fasten aktiviert zelluläre Reparaturprozesse und kann die Gewebegesundheit und -erholung verbessern.';

  @override
  String get benefitMetabolicTitle => 'Stoffwechselumstellung';

  @override
  String get benefitMetabolicDesc =>
      'Nach 12-36 Stunden wechselt Ihr Körper von Glukose zu Ketonen als Energiequelle, was die Stoffwechselflexibilität verbessert.';

  @override
  String get benefitCellularTitle => 'Zellreparatur';

  @override
  String get benefitCellularDesc =>
      'Fasten initiiert die Autophagie, einen Prozess, bei dem Zellen beschädigte Komponenten entfernen und sich regenerieren.';

  @override
  String get warningChildrenTitle => 'Kinder & Jugendliche';

  @override
  String get warningChildrenDesc =>
      'Intervallfasten wird für Kinder oder Jugendliche, die noch wachsen, nicht empfohlen.';

  @override
  String get warningPregnantTitle => 'Schwangerschaft';

  @override
  String get warningPregnantDesc =>
      'Fasten Sie nicht während der Schwangerschaft, da dies die fetale Entwicklung beeinträchtigen kann.';

  @override
  String get warningBreastfeedingTitle => 'Stillzeit';

  @override
  String get warningBreastfeedingDesc =>
      'Fasten während des Stillens kann die Milchproduktion und Nährqualität reduzieren.';

  @override
  String get warningType1DiabetesTitle => 'Typ-1-Diabetes';

  @override
  String get warningType1DiabetesDesc =>
      'Menschen mit Typ-1-Diabetes sollten aufgrund des Hypoglykämierisikos nicht ohne ärztliche Aufsicht fasten.';

  @override
  String get warningEatingDisordersTitle => 'Essstörungen';

  @override
  String get warningEatingDisordersDesc =>
      'Fasten kann Essstörungen auslösen oder verschlimmern. Suchen Sie professionelle Hilfe, wenn Sie eine Vorgeschichte haben.';

  @override
  String get warningMuscleLossTitle => 'Muskelverlustrisiko';

  @override
  String get warningMuscleLossDesc =>
      'Längeres Fasten kann zu Muskelverlust führen. Achten Sie auf Proteinzufuhr während der Essensfenster.';

  @override
  String get warningConsultDoctorTitle => 'Konsultieren Sie Ihren Arzt';

  @override
  String get warningConsultDoctorDesc =>
      'Konsultieren Sie immer einen Arzt, bevor Sie mit dem Fasten beginnen, besonders wenn Sie gesundheitliche Probleme haben.';

  @override
  String get tipHydrationTitle => 'Bleiben Sie hydriert';

  @override
  String get tipHydrationDesc =>
      'Trinken Sie während der Fastenperioden viel Wasser, Kräutertee oder schwarzen Kaffee. Gute Hydration ist wichtig.';

  @override
  String get tipGradualStartTitle => 'Beginnen Sie schrittweise';

  @override
  String get tipGradualStartDesc =>
      'Beginnen Sie mit kürzeren Fastenperioden (12:12) und steigern Sie diese allmählich, während sich Ihr Körper anpasst.';

  @override
  String get tipBalancedMealsTitle => 'Ausgewogene Mahlzeiten';

  @override
  String get tipBalancedMealsDesc =>
      'Konzentrieren Sie sich auf nahrhafte, vollwertige Lebensmittel während Ihres Essensfensters. Einschließlich Proteine, gesunde Fette und Gemüse.';

  @override
  String get tipExerciseTitle => 'Leichte Bewegung';

  @override
  String get tipExerciseDesc =>
      'Leichte bis moderate Bewegung ist während des Fastens in Ordnung. Vermeiden Sie intensive Workouts, bis Sie sich angepasst haben.';
}
