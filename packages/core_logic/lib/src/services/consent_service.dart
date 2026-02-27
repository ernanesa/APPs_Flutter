import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Consentimento (GDPR/UE) via User Messaging Platform (UMP).
///
/// Fluxo:
/// - Atualiza info de consentimento
/// - Se necessário, carrega e exibe o formulário
/// - Só libera carregamento de anúncios quando `canRequestAds == true`
class ConsentService {
  ConsentService._();

  static const int _maxFormShowAttempts = 3;

  static Future<void> gatherConsent() async {
    final params = ConsentRequestParameters(
      consentDebugSettings: kDebugMode
          ? ConsentDebugSettings(
              debugGeography: DebugGeography.debugGeographyDisabled,
              testIdentifiers: <String>[],
            )
          : null,
      tagForUnderAgeOfConsent: false,
    );

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        await _loadAndShowConsentFormIfRequired();
      },
      (FormError error) {
        debugPrint('Consent info update failed: ${error.message}');
      },
    );
  }

  static Future<bool> canRequestAds() =>
      ConsentInformation.instance.canRequestAds();

  static Future<PrivacyOptionsRequirementStatus>
  privacyOptionsRequirementStatus() {
    return ConsentInformation.instance.getPrivacyOptionsRequirementStatus();
  }

  static Future<void> showPrivacyOptionsForm() async {
    final status = await privacyOptionsRequirementStatus();
    if (status != PrivacyOptionsRequirementStatus.required) return;

    // O plugin Flutter não expõe um método separado em todas as versões.
    // Recarregamos o form e mostramos (normalmente abre as opções de privacidade).
    ConsentForm.loadConsentForm(
      (ConsentForm form) {
        form.show((FormError? error) {
          if (error != null) {
            debugPrint('Privacy options form error: ${error.message}');
          }
        });
      },
      (FormError error) {
        debugPrint('Failed to load privacy options form: ${error.message}');
      },
    );
  }

  static Future<void> resetConsent() async {
    ConsentInformation.instance.reset();
  }

  static Future<void> _loadAndShowConsentFormIfRequired() async {
    final isAvailable = await ConsentInformation.instance
        .isConsentFormAvailable();
    if (!isAvailable) return;

    var attempts = 0;

    Future<void> load() async {
      attempts++;

      ConsentForm.loadConsentForm(
        (ConsentForm form) async {
          final status = await ConsentInformation.instance.getConsentStatus();

          if (status == ConsentStatus.required) {
            form.show((FormError? error) async {
              if (error != null) {
                debugPrint('Consent form error: ${error.message}');
              }

              final canRequest = await ConsentInformation.instance
                  .canRequestAds();
              if (!canRequest && attempts < _maxFormShowAttempts) {
                await load();
              }
            });
            return;
          }

          // Se não for required, não mostra nada.
        },
        (FormError error) {
          debugPrint('Failed to load consent form: ${error.message}');
        },
      );
    }

    await load();
  }
}
