// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Interés Compuesto';

  @override
  String get calculate => 'Calcular';

  @override
  String get reset => 'Borrar';

  @override
  String get save => 'Guardar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String get close => 'Cerrar';

  @override
  String get settings => 'Configuración';

  @override
  String get history => 'Historial';

  @override
  String get chart => 'Gráfico';

  @override
  String get details => 'Detalles';

  @override
  String get initialCapital => 'Capital Inicial';

  @override
  String get interestRate => 'Tasa de Interés (% anual)';

  @override
  String get investmentPeriod => 'Período de Inversión';

  @override
  String get monthlyContribution => 'Aporte Mensual';

  @override
  String get months => 'Meses';

  @override
  String get years => 'Años';

  @override
  String get optional => 'Opcional';

  @override
  String get calculationName => 'Nombre del Cálculo';

  @override
  String get calculationNameHint => 'Ingresa un nombre';

  @override
  String get calculationSaved => 'Cálculo guardado';

  @override
  String get requiredField => 'Campo obligatorio';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get invalidRate => 'Tasa inválida';

  @override
  String get totalAmount => 'Monto Total';

  @override
  String get totalContributed => 'Total Invertido';

  @override
  String get totalInterest => 'Total de Intereses';

  @override
  String get percentageGain => 'Ganancia Porcentual';

  @override
  String get result => 'Resultado';

  @override
  String get viewChart => 'Ver gráfico';

  @override
  String get growthChart => 'Gráfico de crecimiento';

  @override
  String get month => 'Mes';

  @override
  String get monthlyBreakdown => 'Evolución Mensual';

  @override
  String get balanceEvolution => 'Evolución del Saldo';

  @override
  String get investmentPresets => 'Presets de Inversión';

  @override
  String get presetPoupanca => 'Cuenta de Ahorros';

  @override
  String get presetPoupancaDesc => 'Bajo riesgo, bajo retorno (6,17% anual)';

  @override
  String get presetCDI => 'CDI 100%';

  @override
  String get presetCDIDesc => 'Conservador post-fijado (10,65% anual)';

  @override
  String get presetTesouroSelic => 'Tesouro Selic';

  @override
  String get presetTesouroSelicDesc => 'Bonos del gobierno (10,75% anual)';

  @override
  String get presetTesouroIPCA => 'Tesouro IPCA+';

  @override
  String get presetTesouroIPCADesc => 'Protección inflación (6,50% + IPCA)';

  @override
  String get presetCDB => 'CDB';

  @override
  String get presetCDBDesc => 'Certificado bancario (11,50% anual)';

  @override
  String get presetLCILCA => 'LCI/LCA';

  @override
  String get presetLCILCADesc =>
      'Exento de impuestos inmobiliario/agro (9,00% anual)';

  @override
  String get calculationHistory => 'Historial de Cálculos';

  @override
  String get noHistory => 'Sin cálculos todavía';

  @override
  String get deleteConfirm => '¿Eliminar este cálculo?';

  @override
  String get clearHistory => 'Borrar Todo Historial';

  @override
  String get clearHistoryConfirm => '¿Eliminar todos los cálculos?';

  @override
  String get achievements => 'Logros';

  @override
  String get achievementUnlocked => '¡Logro Desbloqueado!';

  @override
  String get achievementsProgress => 'Progreso';

  @override
  String get notUnlockedYet => 'Aún no desbloqueado';

  @override
  String get unlockedOn => 'Desbloqueado el';

  @override
  String get categoryCalculations => 'Cálculos';

  @override
  String get categoryStreak => 'Racha';

  @override
  String get categoryAmounts => 'Montos';

  @override
  String get categorySpecial => 'Especial';

  @override
  String get achievementFirstCalc => 'Primer Cálculo';

  @override
  String get achievementFirstCalcDesc => 'Completa tu primer cálculo';

  @override
  String get achievementCalc10 => '10 Cálculos';

  @override
  String get achievementCalc10Desc => 'Completa 10 cálculos';

  @override
  String get achievementCalc50 => '50 Cálculos';

  @override
  String get achievementCalc50Desc => 'Completa 50 cálculos';

  @override
  String get achievementCalc100 => 'Centenario';

  @override
  String get achievementCalc100Desc => 'Completa 100 cálculos';

  @override
  String get achievementStreak3 => 'Racha de 3 Días';

  @override
  String get achievementStreak3Desc => 'Usa la app durante 3 días consecutivos';

  @override
  String get achievementStreak7 => 'Guerrero de la Semana';

  @override
  String get achievementStreak7Desc => 'Usa la app durante 7 días consecutivos';

  @override
  String get achievementStreak30 => 'Maestro del Mes';

  @override
  String get achievementStreak30Desc =>
      'Usa la app durante 30 días consecutivos';

  @override
  String get achievementMillion => 'Primer Millón';

  @override
  String get achievementMillionDesc => 'Calcula llegando a R\$ 1.000.000';

  @override
  String get achievementTenMillion => 'Club de los Diez Millones';

  @override
  String get achievementTenMillionDesc => 'Calcula llegando a R\$ 10.000.000';

  @override
  String get achievementLongTerm => 'Pensador a Largo Plazo';

  @override
  String get achievementLongTermDesc => 'Calcula inversión de 10+ años';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count días',
      one: '1 día',
    );
    return '$_temp0';
  }

  @override
  String get currentStreak => 'Racha Actual';

  @override
  String get bestStreak => 'Mejor Racha';

  @override
  String get days => 'días';

  @override
  String get dailyGoal => 'Meta Diaria';

  @override
  String get dailyGoalTarget => 'Meta de Cálculos';

  @override
  String get goalReached => '¡Meta Alcanzada!';

  @override
  String calculationsProgress(int completed, int target) {
    return '$completed/$target cálculos';
  }

  @override
  String get calculationsPerDay => 'cálculos por día';

  @override
  String get colorTheme => 'Tema de Colores';

  @override
  String get themeGreen => 'Verde';

  @override
  String get themeBlue => 'Azul';

  @override
  String get themePurple => 'Púrpura';

  @override
  String get themeOrange => 'Naranja';

  @override
  String get themeTeal => 'Verde azulado';

  @override
  String get themeIndigo => 'Índigo';

  @override
  String get themeRed => 'Rojo';

  @override
  String get themeAmber => 'Ámbar';
}
