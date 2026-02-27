// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Calculadora IMC';

  @override
  String get calculator => 'Calculadora';

  @override
  String get history => 'Historial';

  @override
  String get evolution => 'Evolución';

  @override
  String get weight => 'Peso (kg)';

  @override
  String get height => 'Altura (cm)';

  @override
  String get calculate => 'Calcular';

  @override
  String get save => 'Guardar Resultado';

  @override
  String get result => 'Resultado';

  @override
  String yourBmi(String bmi) {
    return 'Su IMC es $bmi';
  }

  @override
  String category(String category) {
    return 'Categoría: $category';
  }

  @override
  String get infoTitle => 'Información del IMC';

  @override
  String get infoDescription =>
      'El Índice de Masa Corporal (IMC) es una medida de la grasa corporal basada en la estatura y el peso que se aplica a hombres y mujeres adultos.';

  @override
  String get source => 'Fuente: Organización Mundial de la Salud (OMS)';

  @override
  String get underweight => 'Bajo peso';

  @override
  String get normal => 'Peso normal';

  @override
  String get overweight => 'Sobrepeso';

  @override
  String get obesity1 => 'Obesidad Clase I';

  @override
  String get obesity2 => 'Obesidad Clase II';

  @override
  String get obesity3 => 'Obesidad Clase III';

  @override
  String get delete => 'Eliminar';

  @override
  String get noHistory => 'Aún no hay historial';

  @override
  String get evolutionGraph => 'Gráfico de Evolución';

  @override
  String get needTwoEntries =>
      '¡Sigue registrando! Necesitas al menos 2 entradas para ver la evolución.';

  @override
  String get bmiEvolutionTitle => 'Evolución del IMC';

  @override
  String get reset => 'Reiniciar';

  @override
  String get resultSaved => '¡Resultado guardado!';
}
