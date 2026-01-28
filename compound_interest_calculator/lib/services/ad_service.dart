import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../utils/logger.dart';

class AdService {
  static bool _initialized = false;
  static AppOpenAd? _appOpenAd;
  static DateTime? _appOpenLoadTime;
  static int _appOpenCount = 0;
  static const Duration maxAdAge = Duration(hours: 4);

  // PRODUCTION IDs - Replace with real IDs before release
  static String get appId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544~3347511713'; // Test
    }
    return 'ca-app-pub-XXXXXXX~YYYYYYY'; // TODO: Replace with real ID
  }

  static String get bannerAdUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Test
    }
    return 'ca-app-pub-XXXXXXX/ZZZZZZ'; // TODO: Replace with real ID
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test
    }
    return 'ca-app-pub-XXXXXXX/ZZZZZZ'; // TODO: Replace with real ID
  }

  static String get appOpenAdUnitId {
    if (kDebugMode) {
      return 'ca-app-pub-3940256099942544/9257395921'; // Test
    }
    return 'ca-app-pub-XXXXXXX/ZZZZZZ'; // TODO: Replace with real ID
  }

  static Future<void> initialize() async {
    if (_initialized) return;
    
    await MobileAds.instance.initialize();
    _initialized = true;
    logDebug('AdMob initialized');
  }

  // App Open Ad
  static Future<void> loadAppOpenAd() async {
    if (_appOpenAd != null) return;

    await AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenLoadTime = DateTime.now();
          logDebug('App Open Ad loaded');
        },
        onAdFailedToLoad: (error) {
          logError('App Open Ad failed to load', error);
        },
      ),
    );
  }

  static bool get _isAppOpenAdExpired {
    if (_appOpenLoadTime == null) return true;
    return DateTime.now().difference(_appOpenLoadTime!) > maxAdAge;
  }

  static void showAppOpenAdIfAvailable() {
    _appOpenCount++;
    
    // Don't show on first 2 app opens
    if (_appOpenCount < 2) {
      loadAppOpenAd();
      return;
    }

    if (_appOpenAd == null || _isAppOpenAdExpired) {
      loadAppOpenAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        logDebug('App Open Ad showed');
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        logError('App Open Ad failed to show', error);
        ad.dispose();
        _appOpenAd = null;
      },
    );

    _appOpenAd!.show();
  }

  // Banner Ad
  static BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => logDebug('Banner loaded'),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          logError('Banner failed to load', error);
        },
      ),
    );
  }
}
