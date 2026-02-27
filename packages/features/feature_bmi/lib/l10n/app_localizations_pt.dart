// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Calculadora IMC';

  @override
  String get calculator => 'Calculadora';

  @override
  String get history => 'Histórico';

  @override
  String get evolution => 'Evolução';

  @override
  String get weight => 'Peso (kg)';

  @override
  String get height => 'Altura (cm)';

  @override
  String get calculate => 'Calcular';

  @override
  String get save => 'Salvar Resultado';

  @override
  String get result => 'Resultado';

  @override
  String yourBmi(String bmi) {
    return 'Seu IMC é $bmi';
  }

  @override
  String category(String category) {
    return 'Categoria: $category';
  }

  @override
  String get infoTitle => 'Informações sobre IMC';

  @override
  String get infoDescription =>
      'O Índice de Massa Corporal (IMC) é uma medida da gordura corporal com base na altura e no peso que se aplica a homens e mulheres adultos.';

  @override
  String get source => 'Fonte: Organização Mundial da Saúde (OMS)';

  @override
  String get underweight => 'Abaixo do peso';

  @override
  String get normal => 'Peso normal';

  @override
  String get overweight => 'Sobrepeso';

  @override
  String get obesity1 => 'Obesidade Grau I';

  @override
  String get obesity2 => 'Obesidade Grau II';

  @override
  String get obesity3 => 'Obesidade Grau III';

  @override
  String get delete => 'Excluir';

  @override
  String get noHistory => 'Nenhum histórico ainda';

  @override
  String get evolutionGraph => 'Gráfico de Evolução';

  @override
  String get needTwoEntries =>
      'Continue registrando! Você precisa de pelo menos 2 entradas para ver a evolução.';

  @override
  String get bmiEvolutionTitle => 'Evolução do IMC';

  @override
  String get reset => 'Limpar';

  @override
  String get resultSaved => 'Resultado salvo!';
}
