import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Serviço centralizado para gerenciamento de anúncios AdMob.
/// Implementa padrão Singleton para evitar múltiplas instâncias.
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  static bool _adsEnabled = false;

  static bool get adsEnabled => _adsEnabled;

  static void disableAds() {
    _adsEnabled = false;
    dispose();
  }

  // ============================================================================
  // AD UNIT IDs - PRODUÇÃO
  // ============================================================================

  /// ID do Banner Ad (Produção)
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/6300978111' // Test ID
          : 'ca-app-pub-9691622617864549/5123837659'; // Produção
    }
    return '';
  }

  /// ID do Interstitial Ad (Produção)
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/1033173712' // Test ID
          : 'ca-app-pub-9691622617864549/7287816621'; // Produção
    }
    return '';
  }

  /// ID do App Open Ad (Produção)
  static String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? 'ca-app-pub-3940256099942544/9257395921' // Test ID
          : 'ca-app-pub-9691622617864549/5938225872'; // Produção
    }
    return '';
  }

  // ============================================================================
  // APP OPEN AD - Gerenciamento Avançado
  // ============================================================================

  static AppOpenAd? _appOpenAd;
  static DateTime? _appOpenAdLoadTime;
  static bool _isShowingAppOpenAd = false;
  static int _appOpenCount = 0;
  static const Duration _maxAdAge = Duration(hours: 4);

  /// Verifica se o App Open Ad expirou (válido por 4 horas)
  static bool get _isAppOpenAdExpired {
    if (_appOpenAdLoadTime == null) return true;
    return DateTime.now().difference(_appOpenAdLoadTime!) > _maxAdAge;
  }

  /// Inicializa o SDK do Mobile Ads
  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
    _adsEnabled = true;
  }

  /// Carrega um App Open Ad em background
  static Future<void> loadAppOpenAd() async {
    if (!_adsEnabled) return;
    if (_appOpenAd != null) return; // Já carregado
    if (!Platform.isAndroid) return;

    await AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenAdLoadTime = DateTime.now();
          debugPrint('App Open Ad loaded successfully');
        },
        onAdFailedToLoad: (error) {
          debugPrint('App Open Ad failed to load: $error');
          _appOpenAd = null;
        },
      ),
    );
  }

  /// Mostra o App Open Ad se disponível e não expirado
  /// Não mostra nas primeiras 2 aberturas do app (melhor UX)
  static void showAppOpenAdIfAvailable() {
    if (!_adsEnabled) return;
    _appOpenCount++;

    // Não mostrar nas primeiras aberturas (deixar user interagir primeiro)
    if (_appOpenCount < 2) {
      loadAppOpenAd(); // Pré-carregar para próxima vez
      return;
    }

    if (_appOpenAd == null || _isShowingAppOpenAd || _isAppOpenAdExpired) {
      loadAppOpenAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAppOpenAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAppOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd(); // Pré-carregar próximo
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAppOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
        debugPrint('App Open Ad failed to show: $error');
      },
    );

    _appOpenAd!.show();
  }

  // ============================================================================
  // INTERSTITIAL AD - Com Pre-loading
  // ============================================================================

  static InterstitialAd? _interstitialAd;
  static int _actionCount = 0;
  static const int _showAfterActions = 3; // Mostrar a cada 3 cálculos

  /// Incrementa contador de ações e mostra intersticial se atingir limite
  static void incrementActionAndShowIfNeeded() {
    _actionCount++;
    if (_actionCount >= _showAfterActions && _interstitialAd != null) {
      _showInterstitialAd();
      _actionCount = 0;
    }
  }

  /// Pré-carrega um Interstitial Ad
  static void preloadInterstitialAd() {
    if (!_adsEnabled) return;
    if (_interstitialAd != null) return; // Já carregado
    if (!Platform.isAndroid) return;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          debugPrint('Interstitial Ad loaded successfully');
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial Ad failed to load: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Mostra o Interstitial Ad carregado
  static void _showInterstitialAd() {
    if (!_adsEnabled) return;
    if (_interstitialAd == null) return;

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        preloadInterstitialAd(); // Pré-carregar próximo
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        debugPrint('Interstitial failed to show: $error');
      },
    );

    _interstitialAd!.show();
  }

  /// Método legado para compatibilidade - mostra intersticial imediatamente
  static Future<void> showInterstitialAd() async {
    if (!_adsEnabled) return;
    incrementActionAndShowIfNeeded();
  }

  // ============================================================================
  // BANNER AD - Adaptativo
  // ============================================================================

  /// Cria um Banner Ad de tamanho fixo (FullBanner)
  static BannerAd? createBannerAd({
    Function(Ad)? onAdLoaded,
    Function(Ad, LoadAdError)? onAdFailedToLoad,
  }) {
    if (!_adsEnabled) return null;
    if (!Platform.isAndroid) return null;

    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('Banner Ad loaded.');
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('Banner Ad failed to load: $error');
          onAdFailedToLoad?.call(ad, error);
        },
      ),
    );
  }

  /// Cria um Banner Ad Adaptativo baseado na largura da tela
  static Future<BannerAd?> createAdaptiveBannerAd({
    required int width,
    Function(Ad)? onAdLoaded,
    Function(Ad, LoadAdError)? onAdFailedToLoad,
  }) async {
    if (!_adsEnabled) return null;
    if (!Platform.isAndroid) return null;

    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      width,
    );
    if (size == null) return null;

    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          debugPrint('Adaptive Banner Ad loaded.');
          onAdLoaded?.call(ad);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          debugPrint('Adaptive Banner Ad failed to load: $error');
          onAdFailedToLoad?.call(ad, error);
        },
      ),
    );
  }

  // ============================================================================
  // CLEANUP
  // ============================================================================

  /// Libera todos os recursos de anúncios
  static void dispose() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
