import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/logger.dart';
import 'ad_service.dart';

/// Service for handling GDPR consent (UMP).
class ConsentService {
  static ConsentService? _instance;
  static ConsentService get instance => _instance ??= ConsentService._();
  
  ConsentService._();

  bool _canRequestAds = false;
  bool _isPrivacyOptionsRequired = false;
  
  /// Whether ads can be requested after consent.
  bool get canRequestAds => _canRequestAds;
  
  /// Whether privacy options button should be shown.
  bool get isPrivacyOptionsRequired => _isPrivacyOptionsRequired;

  /// Gathers user consent for personalized ads (GDPR/UE/EEA/UK).
  Future<void> gatherConsent({
    required void Function(FormError?) onConsentComplete,
    bool forceTest = false,
  }) async {
    final params = ConsentRequestParameters();
    
    // For testing: enable debug settings
    if (kDebugMode && forceTest) {
      final debugSettings = ConsentDebugSettings(
        debugGeography: DebugGeography.debugGeographyEea,
        testIdentifiers: [], // Add test device IDs here
      );
      params.consentDebugSettings = debugSettings;
    }

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        // Check if consent form is available
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          await _loadAndShowConsentForm(onConsentComplete);
        } else {
          _updateCanRequestAds();
          onConsentComplete(null);
        }
      },
      (FormError error) {
        logDebug('Consent info update failed: ${error.message}');
        _updateCanRequestAds();
        onConsentComplete(error);
      },
    );
  }

  Future<void> _loadAndShowConsentForm(
    void Function(FormError?) onConsentComplete,
  ) async {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        final status = await ConsentInformation.instance.getConsentStatus();
        
        if (status == ConsentStatus.required) {
          consentForm.show((FormError? formError) {
            _updateCanRequestAds();
            onConsentComplete(formError);
          });
        } else {
          _updateCanRequestAds();
          onConsentComplete(null);
        }
      },
      (FormError error) {
        logDebug('Consent form load failed: ${error.message}');
        _updateCanRequestAds();
        onConsentComplete(error);
      },
    );
  }

  /// Updates the ad request capability based on consent status.
  void _updateCanRequestAds() async {
    _canRequestAds = await ConsentInformation.instance.canRequestAds();
    _isPrivacyOptionsRequired = await ConsentInformation.instance
        .getPrivacyOptionsRequirementStatus() ==
        PrivacyOptionsRequirementStatus.required;
    
    // Update AdService with consent status
    AdService.instance.setCanShowAds(_canRequestAds);
  }

  /// Shows the privacy options form if required.
  Future<void> showPrivacyOptionsForm({
    required void Function(FormError?) onComplete,
  }) async {
    ConsentForm.showPrivacyOptionsForm((FormError? error) {
      _updateCanRequestAds();
      onComplete(error);
    });
  }

  /// Resets consent information (for testing).
  Future<void> resetConsent() async {
    await ConsentInformation.instance.reset();
    _canRequestAds = false;
    _isPrivacyOptionsRequired = false;
  }
}
