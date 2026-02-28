// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Kalkulator BMI';

  @override
  String get calculator => 'Kalkulator';

  @override
  String get history => 'Sejarah';

  @override
  String get evolution => 'Evolusi';

  @override
  String get weight => 'Berat (kg)';

  @override
  String get height => 'Tinggi (cm)';

  @override
  String get calculate => 'Menghitung';

  @override
  String get save => 'Simpan Hasil';

  @override
  String get result => 'Hasil';

  @override
  String yourBmi(String bmi) {
    return 'BMI Anda adalah$bmi';
  }

  @override
  String category(String category) {
    return 'Kategori:$category';
  }

  @override
  String get infoTitle => 'Informasi BMI';

  @override
  String get infoDescription =>
      'Indeks Massa Tubuh (BMI) merupakan ukuran lemak tubuh berdasarkan tinggi dan berat badan yang berlaku pada pria dan wanita dewasa.';

  @override
  String get source => 'Sumber: Organisasi Kesehatan Dunia (WHO)';

  @override
  String get underweight => 'Berat badan kurang';

  @override
  String get normal => 'Berat badan normal';

  @override
  String get overweight => 'Kegemukan';

  @override
  String get obesity1 => 'Obesitas Kelas I';

  @override
  String get obesity2 => 'Obesitas Kelas II';

  @override
  String get obesity3 => 'Obesitas Kelas III';

  @override
  String get delete => 'Menghapus';

  @override
  String get noHistory => 'Belum ada sejarah';

  @override
  String get evolutionGraph => 'Grafik Evolusi';

  @override
  String get needTwoEntries =>
      'Terus lacak! Anda memerlukan setidaknya 2 entri untuk melihat evolusi.';

  @override
  String get bmiEvolutionTitle => 'Evolusi BMI';

  @override
  String get reset => 'Mengatur ulang';

  @override
  String get resultSaved => 'Hasil disimpan!';
}
