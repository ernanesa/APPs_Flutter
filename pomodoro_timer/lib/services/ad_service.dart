import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Service for managing AdMob advertisements.
class AdService {
  static AdService? _instance;
  static AdService get instance => _instance ??= AdService._();
  
  AdService._();

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  AppOpenAd? _appOpenAd;
  
  bool _isInitialized = false;
  bool _canShowAds = false;
  int _actionCount = 0;
  int _openCount = 0;
  DateTime? _appOpenLoadTime;
  
  static const int _showInterstitialAfterActions = 3;
  static const Duration _maxAppOpenAdAge = Duration(hours: 4);

  // Test Ad Unit IDs (use production IDs in release)
  static String get _bannerAdUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Test Banner
    }
    return 'ca-app-pub-9691622617864549/3648255832'; // Production Banner
  }

  static String get _interstitialAdUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test Interstitial
    }
    return 'ca-app-pub-9691622617864549/7251608861'; // Production Interstitial
  }

  static String get _appOpenAdUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/9257990691'; // Test App Open
    }
    return 'ca-app-pub-9691622617864549/2957990691'; // Production App Open
  }

  /// Initializes the Mobile Ads SDK.
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await MobileAds.instance.initialize();
    _isInitialized = true;
    _canShowAds = true; // Will be updated by consent service
    
    // Pre-load ads
    _loadBannerAd();
    _loadInterstitialAd();
    _loadAppOpenAd();
  }

  /// Sets whether ads can be shown (based on consent).
  void setCanShowAds(bool canShow) {
    _canShowAds = canShow;
    if (canShow && _isInitialized) {
      _loadBannerAd();
      _loadInterstitialAd();
      _loadAppOpenAd();
    }
  }

  // ===== Banner Ad =====

  void _loadBannerAd() {
    if (!_canShowAds) return;
    
    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Banner ad failed: ${error.message}');
          ad.dispose();
          _bannerAd = null;
        },
      ),
    )..load();
  }

  /// Creates an adaptive banner ad for the given width.
  Future<BannerAd?> createAdaptiveBannerAd(int width) async {
    if (!_canShowAds) return null;
    
    final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (size == null) return null;
    
    return BannerAd(
      adUnitId: _bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('Adaptive banner loaded');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('Adaptive banner failed: ${error.message}');
          ad.dispose();
        },
      ),
    )..load();
  }

  /// Gets the current banner ad if loaded.
  BannerAd? get bannerAd => _bannerAd;

  // ===== Interstitial Ad =====

  void _loadInterstitialAd() {
    if (!_canShowAds) return;
    
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          debugPrint('Interstitial ad loaded');
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial ad failed: ${error.message}');
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Increments action count and shows interstitial if threshold reached.
  void incrementActionAndShowIfNeeded() {
    _actionCount++;
    if (_actionCount >= _showInterstitialAfterActions) {
      showInterstitialAd();
      _actionCount = 0;
    }
  }

  /// Shows the interstitial ad if available.
  void showInterstitialAd() {
    if (!_canShowAds || _interstitialAd == null) return;
    
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('Interstitial show failed: ${error.message}');
        ad.dispose();
        _interstitialAd = null;
        _loadInterstitialAd();
      },
    );
    
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  // ===== App Open Ad =====

  void _loadAppOpenAd() {
    if (!_canShowAds || _appOpenAd != null) return;
    
    AppOpenAd.load(
      adUnitId: _appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenLoadTime = DateTime.now();
          debugPrint('App Open ad loaded');
        },
        onAdFailedToLoad: (error) {
          debugPrint('App Open ad failed: ${error.message}');
        },
      ),
    );
  }

  bool get _isAppOpenAdExpired {
    if (_appOpenLoadTime == null) return true;
    return DateTime.now().difference(_appOpenLoadTime!) > _maxAppOpenAdAge;
  }

  /// Shows the App Open ad if available and not expired.
  void showAppOpenAdIfAvailable() {
    _openCount++;
    
    // Don't show on first 2 opens for better UX
    if (_openCount < 2) {
      _loadAppOpenAd();
      return;
    }
    
    if (!_canShowAds || _appOpenAd == null || _isAppOpenAdExpired) {
      _loadAppOpenAd();
      return;
    }
    
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _appOpenAd = null;
        _loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('App Open show failed: ${error.message}');
        ad.dispose();
        _appOpenAd = null;
        _loadAppOpenAd();
      },
    );
    
    _appOpenAd!.show();
    _appOpenAd = null;
  }

  /// Disposes all loaded ads.
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _appOpenAd?.dispose();
    _bannerAd = null;
    _interstitialAd = null;
    _appOpenAd = null;
  }
}
