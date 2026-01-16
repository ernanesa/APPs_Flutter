import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/logger.dart';

/// Centralized Ad Service for managing all ad formats
class AdService {
  static bool _isInitialized = false;
  static AppOpenAd? _appOpenAd;
  static DateTime? _appOpenLoadTime;
  static int _appOpenCount = 0;
  static bool _isShowingAppOpenAd = false;

  // Test IDs - Replace with production IDs before release
  static String get _appOpenAdUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/9257395921'; // Test ID
    }
    return 'ca-app-pub-XXXX/YYYY'; // TODO: Replace with production ID
  }

  static String get bannerAdUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Test ID
    }
    return 'ca-app-pub-XXXX/YYYY'; // TODO: Replace with production ID
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test ID
    }
    return 'ca-app-pub-XXXX/YYYY'; // TODO: Replace with production ID
  }

  /// Initialize Mobile Ads SDK
  static Future<void> initialize() async {
    if (_isInitialized) return;

    await MobileAds.instance.initialize();
    _isInitialized = true;
    logDebug('AdService initialized');
  }

  /// Load App Open Ad
  static Future<void> loadAppOpenAd() async {
    if (_appOpenAd != null) return;

    await AppOpenAd.load(
      adUnitId: _appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenLoadTime = DateTime.now();
          logDebug('App Open Ad loaded');
        },
        onAdFailedToLoad: (error) {
          logDebug('App Open Ad failed to load: ${error.message}');
        },
      ),
    );
  }

  /// Show App Open Ad if available and not expired
  static void showAppOpenAdIfAvailable() {
    _appOpenCount++;

    // Don't show on first 2 app opens
    if (_appOpenCount < 2) {
      loadAppOpenAd();
      return;
    }

    // Check if ad is available and not expired (4 hours)
    if (_appOpenAd == null ||
        _isShowingAppOpenAd ||
        _isAdExpired()) {
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
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAppOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
        logDebug('App Open Ad failed to show: ${error.message}');
      },
    );

    _appOpenAd!.show();
  }

  static bool _isAdExpired() {
    if (_appOpenLoadTime == null) return true;
    final maxDuration = const Duration(hours: 4);
    return DateTime.now().difference(_appOpenLoadTime!) > maxDuration;
  }

  /// Create adaptive banner ad
  static Future<BannerAd> createAdaptiveBanner(int width, {
    required Function(Ad) onLoaded,
    required Function(Ad, LoadAdError) onFailed,
  }) async {
    final anchoredSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    final AdSize size = anchoredSize != null 
        ? AdSize(width: anchoredSize.width, height: anchoredSize.height)
        : AdSize.banner;

    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onLoaded,
        onAdFailedToLoad: onFailed,
      ),
    );
  }
}
