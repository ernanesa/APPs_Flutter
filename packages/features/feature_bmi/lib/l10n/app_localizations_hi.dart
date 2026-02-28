// ignore: unused_import
import 'package:intl/intl.dart' as intl;


// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'BMI कैलकुलेटर';

  @override
  String get calculator => 'कैलकुलेटर';

  @override
  String get history => 'इतिहास';

  @override
  String get evolution => 'विकास';

  @override
  String get weight => 'वजन (kg)';

  @override
  String get height => 'ऊंचाई (cm)';

  @override
  String get calculate => 'गणना करें';

  @override
  String get save => 'परिणाम सहेजें';

  @override
  String get result => 'परिणाम';

  @override
  String yourBmi(String bmi) {
    return 'आपका BMI $bmi है';
  }

  @override
  String category(String category) {
    return 'श्रेणी: $category';
  }

  @override
  String get infoTitle => 'BMI जानकारी';

  @override
  String get infoDescription =>
      'बॉडी मास इंडेक्स (BMI) ऊंचाई और वजन पर आधारित शरीर की वसा का एक माप है जो वयस्क पुरुषों और महिलाओं पर लागू होता है।';

  @override
  String get source => 'स्रोत: विश्व स्वास्थ्य संगठन (WHO)';

  @override
  String get underweight => 'कम वजन';

  @override
  String get normal => 'सामान्य वजन';

  @override
  String get overweight => 'अधिक वजन';

  @override
  String get obesity1 => 'मोटापा कक्षा I';

  @override
  String get obesity2 => 'मोटापा कक्षा II';

  @override
  String get obesity3 => 'मोटापा कक्षा III';

  @override
  String get delete => 'हटाएं';

  @override
  String get noHistory => 'अभी कोई इतिहास नहीं है';

  @override
  String get evolutionGraph => 'विकास ग्राफ';

  @override
  String get needTwoEntries =>
      'रिकॉर्ड करते रहें! विकास देखने के लिए आपको कम से कम 2 प्रविष्टियों की आवश्यकता है।';

  @override
  String get bmiEvolutionTitle => 'BMI विकास';

  @override
  String get reset => 'रीसेट';

  @override
  String get resultSaved => 'परिणाम सहेजा गया!';
}
