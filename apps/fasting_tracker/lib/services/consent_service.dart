import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/logger.dart';

/// Consent service for GDPR compliance using UMP
class ConsentService {
  static bool _canRequestAds = false;
  static bool _isPrivacyOptionsRequired = false;

  static bool get canRequestAds => _canRequestAds;
  static bool get isPrivacyOptionsRequired => _isPrivacyOptionsRequired;

  /// Gather consent from user (call before initializing ads)
  static Future<void> gatherConsent({bool forceReset = false}) async {
    final params = ConsentRequestParameters();

    if (forceReset) {
      ConsentInformation.instance.reset();
    }

    try {
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () async {
          if (await ConsentInformation.instance.isConsentFormAvailable()) {
            await _loadAndShowConsentForm();
          }
          await _updateCanRequestAds();
        },
        (error) {
          logDebug('Consent error: ${error.message}');
          // Fallback: allow ads on error
          _canRequestAds = true;
        },
      );
    } catch (e) {
      logDebug('Consent exception: $e');
      _canRequestAds = true;
    }
  }

  static Future<void> _loadAndShowConsentForm() async {
    ConsentForm.loadConsentForm(
      (form) async {
        final status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          form.show((error) async {
            if (error != null) {
              logDebug('Consent form error: ${error.message}');
            }
            await _updateCanRequestAds();
          });
        }
      },
      (error) {
        logDebug('Consent form load error: ${error.message}');
      },
    );
  }

  static Future<void> _updateCanRequestAds() async {
    _canRequestAds = await ConsentInformation.instance.canRequestAds();

    final privacyStatus =
        await ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
    _isPrivacyOptionsRequired =
        privacyStatus == PrivacyOptionsRequirementStatus.required;
  }

  /// Show privacy options form (for settings screen)
  static Future<void> showPrivacyOptions() async {
    ConsentForm.showPrivacyOptionsForm((error) {
      if (error != null) {
        logDebug('Privacy options error: ${error.message}');
      }
    });
  }
}
