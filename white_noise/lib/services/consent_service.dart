import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/logger.dart';

class ConsentService {
  static bool _canRequestAds = false;
  static bool _isPrivacyOptionsRequired = false;

  static bool get canRequestAds => _canRequestAds;
  static bool get isPrivacyOptionsRequired => _isPrivacyOptionsRequired;

  static Future<void> gatherConsent({bool forceReset = false}) async {
    final params = ConsentRequestParameters();

    if (forceReset) {
      ConsentInformation.instance.reset();
    }

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          await _loadAndShowConsentForm();
        }
        await _updateCanRequestAds();
      },
      (error) {
        logError('Consent error: ${error.message}');
        _canRequestAds = true; // Fail-safe
      },
    );
  }

  static Future<void> _loadAndShowConsentForm() async {
    ConsentForm.loadConsentForm((form) {
      ConsentInformation.instance.getConsentStatus().then((status) {
        if (status == ConsentStatus.required) {
          form.show((error) => _updateCanRequestAds());
        } else {
          _updateCanRequestAds();
        }
      });
    }, (error) => logError('Consent form error: ${error.message}'));
  }

  static Future<void> _updateCanRequestAds() async {
    _canRequestAds = await ConsentInformation.instance.canRequestAds();
    _isPrivacyOptionsRequired =
        await ConsentInformation.instance
            .getPrivacyOptionsRequirementStatus() ==
        PrivacyOptionsRequirementStatus.required;
  }

  static Future<void> showPrivacyOptions() async {
    ConsentForm.showPrivacyOptionsForm((error) {
      if (error != null) {
        logError('Privacy options error: ${error.message}');
      }
    });
  }
}
