// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Juros Compostos';

  @override
  String get calculate => 'Calcular';

  @override
  String get reset => 'Limpar';

  @override
  String get save => 'Salvar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Excluir';

  @override
  String get close => 'Fechar';

  @override
  String get settings => 'Configurações';

  @override
  String get history => 'Histórico';

  @override
  String get chart => 'Gráfico';

  @override
  String get details => 'Detalhes';

  @override
  String get initialCapital => 'Capital Inicial';

  @override
  String get interestRate => 'Taxa de Juros (% ao ano)';

  @override
  String get investmentPeriod => 'Período de Investimento';

  @override
  String get monthlyContribution => 'Aporte Mensal';

  @override
  String get months => 'Meses';

  @override
  String get years => 'Anos';

  @override
  String get optional => 'Opcional';

  @override
  String get calculationName => 'Nome do Cálculo';

  @override
  String get calculationNameHint => 'Digite um nome';

  @override
  String get calculationSaved => 'Cálculo salvo';

  @override
  String get requiredField => 'Campo obrigatório';

  @override
  String get invalidNumber => 'Número inválido';

  @override
  String get invalidRate => 'Taxa inválida';

  @override
  String get totalAmount => 'Montante Total';

  @override
  String get totalContributed => 'Total Investido';

  @override
  String get totalInterest => 'Total de Juros';

  @override
  String get percentageGain => 'Ganho Percentual';

  @override
  String get result => 'Resultado';

  @override
  String get viewChart => 'Ver gráfico';

  @override
  String get growthChart => 'Gráfico de crescimento';

  @override
  String get month => 'Mês';

  @override
  String get monthlyBreakdown => 'Evolução Mensal';

  @override
  String get balanceEvolution => 'Evolução do Saldo';

  @override
  String get investmentPresets => 'Presets de Investimento';

  @override
  String get presetPoupanca => 'Poupança';

  @override
  String get presetPoupancaDesc => 'Baixo risco, baixo retorno (6,17% a.a.)';

  @override
  String get presetCDI => 'CDI 100%';

  @override
  String get presetCDIDesc => 'Conservador pós-fixado (10,65% a.a.)';

  @override
  String get presetTesouroSelic => 'Tesouro Selic';

  @override
  String get presetTesouroSelicDesc => 'Títulos públicos (10,75% a.a.)';

  @override
  String get presetTesouroIPCA => 'Tesouro IPCA+';

  @override
  String get presetTesouroIPCADesc => 'Proteção inflação (6,50% + IPCA)';

  @override
  String get presetCDB => 'CDB';

  @override
  String get presetCDBDesc => 'Certificado bancário (11,50% a.a.)';

  @override
  String get presetLCILCA => 'LCI/LCA';

  @override
  String get presetLCILCADesc => 'Isento de IR imobiliário/agro (9,00% a.a.)';

  @override
  String get calculationHistory => 'Histórico de Cálculos';

  @override
  String get noHistory => 'Nenhum cálculo ainda';

  @override
  String get deleteConfirm => 'Excluir este cálculo?';

  @override
  String get clearHistory => 'Limpar Todo Histórico';

  @override
  String get clearHistoryConfirm => 'Excluir todos os cálculos?';

  @override
  String get achievements => 'Conquistas';

  @override
  String get achievementUnlocked => 'Conquista Desbloqueada!';

  @override
  String get achievementsProgress => 'Progresso';

  @override
  String get notUnlockedYet => 'Ainda não desbloqueado';

  @override
  String get unlockedOn => 'Desbloqueado em';

  @override
  String get categoryCalculations => 'Cálculos';

  @override
  String get categoryStreak => 'Sequência';

  @override
  String get categoryAmounts => 'Montantes';

  @override
  String get categorySpecial => 'Especial';

  @override
  String get achievementFirstCalc => 'Primeiro Cálculo';

  @override
  String get achievementFirstCalcDesc => 'Complete seu primeiro cálculo';

  @override
  String get achievementCalc10 => '10 Cálculos';

  @override
  String get achievementCalc10Desc => 'Complete 10 cálculos';

  @override
  String get achievementCalc50 => '50 Cálculos';

  @override
  String get achievementCalc50Desc => 'Complete 50 cálculos';

  @override
  String get achievementCalc100 => 'Centenário';

  @override
  String get achievementCalc100Desc => 'Complete 100 cálculos';

  @override
  String get achievementStreak3 => 'Sequência de 3 Dias';

  @override
  String get achievementStreak3Desc => 'Use o app por 3 dias consecutivos';

  @override
  String get achievementStreak7 => 'Guerreiro da Semana';

  @override
  String get achievementStreak7Desc => 'Use o app por 7 dias consecutivos';

  @override
  String get achievementStreak30 => 'Mestre do Mês';

  @override
  String get achievementStreak30Desc => 'Use o app por 30 dias consecutivos';

  @override
  String get achievementMillion => 'Primeiro Milhão';

  @override
  String get achievementMillionDesc => 'Calcule chegando a R\$ 1.000.000';

  @override
  String get achievementTenMillion => 'Clube dos Dez Milhões';

  @override
  String get achievementTenMillionDesc => 'Calcule chegando a R\$ 10.000.000';

  @override
  String get achievementLongTerm => 'Pensador de Longo Prazo';

  @override
  String get achievementLongTermDesc => 'Calcule investimento de 10+ anos';

  @override
  String streakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String get currentStreak => 'Sequência Atual';

  @override
  String get bestStreak => 'Melhor Sequência';

  @override
  String get days => 'dias';

  @override
  String get dailyGoal => 'Meta Diária';

  @override
  String get dailyGoalTarget => 'Meta de Cálculos';

  @override
  String get goalReached => 'Meta Alcançada!';

  @override
  String calculationsProgress(int completed, int target) {
    return '$completed/$target cálculos';
  }

  @override
  String get calculationsPerDay => 'cálculos por dia';

  @override
  String get colorTheme => 'Tema de Cores';

  @override
  String get themeGreen => 'Verde';

  @override
  String get themeBlue => 'Azul';

  @override
  String get themePurple => 'Roxo';

  @override
  String get themeOrange => 'Laranja';

  @override
  String get themeTeal => 'Azul-petróleo';

  @override
  String get themeIndigo => 'Índigo';

  @override
  String get themeRed => 'Vermelho';

  @override
  String get themeAmber => 'Âmbar';
}
