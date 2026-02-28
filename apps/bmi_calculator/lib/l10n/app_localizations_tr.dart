// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'BMI Hesaplayıcı';

  @override
  String get calculator => 'Hesap Makinesi';

  @override
  String get history => 'Tarih';

  @override
  String get evolution => 'Evrim';

  @override
  String get weight => 'Ağırlık (kg)';

  @override
  String get height => 'Yükseklik (cm)';

  @override
  String get calculate => 'Hesaplamak';

  @override
  String get save => 'Sonucu Kaydet';

  @override
  String get result => 'Sonuç';

  @override
  String yourBmi(String bmi) {
    return 'BMI\'ınız$bmi';
  }

  @override
  String category(String category) {
    return 'Kategori:$category';
  }

  @override
  String get infoTitle => 'BMI Bilgileri';

  @override
  String get infoDescription =>
      'Vücut Kitle İndeksi (BMI), yetişkin erkek ve kadınlar için geçerli olan, boy ve kiloya dayalı vücut yağının bir ölçüsüdür.';

  @override
  String get source => 'Kaynak: Dünya Sağlık Örgütü (WHO)';

  @override
  String get underweight => 'Düşük kilolu';

  @override
  String get normal => 'Normal ağırlık';

  @override
  String get overweight => 'Fazla kilolu';

  @override
  String get obesity1 => 'Obezite Sınıfı I';

  @override
  String get obesity2 => 'Obezite Sınıfı II';

  @override
  String get obesity3 => 'Obezite Sınıfı III';

  @override
  String get delete => 'Silmek';

  @override
  String get noHistory => 'Henüz geçmiş yok';

  @override
  String get evolutionGraph => 'Evrim Grafiği';

  @override
  String get needTwoEntries =>
      'Takip etmeye devam edin! Evrimi görmek için en az 2 girişe ihtiyacınız var.';

  @override
  String get bmiEvolutionTitle => 'BMI Gelişimi';

  @override
  String get reset => 'Sıfırla';

  @override
  String get resultSaved => 'Sonuç kaydedildi!';
}
