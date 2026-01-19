import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../utils/logger.dart';

class AdService {
  static AppOpenAd? _appOpenAd;
  static DateTime? _appOpenLoadedTime;
  static bool _isShowingAppOpen = false;

  static InterstitialAd? _interstitialAd;
  static int _actionCount = 0;
  static const int _showInterstitialAfter = 3;

  static Future<InitializationStatus> initialize() {
    return MobileAds.instance.initialize();
  }

  static String get appOpenAdUnitId {
    if (kDebugMode) return 'ca-app-pub-3940256099942544/9257395921';
    return 'ca-app-pub-9691622617864549/1894236758';
  }

  static String get interstitialAdUnitId {
    if (kDebugMode) return 'ca-app-pub-3940256099942544/1033173712';
    return 'ca-app-pub-9691622617864549/2680511292';
  }

  static String get bannerAdUnitId {
    if (kDebugMode) return 'ca-app-pub-3940256099942544/6300978111';
    return 'ca-app-pub-9691622617864549/8978519853';
  }

  static Future<void> loadAppOpenAd() async {
    await AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenLoadedTime = DateTime.now();
        },
        onAdFailedToLoad: (error) {
          logDebug('AppOpen failed: ${error.message}');
        },
      ),
    );
  }

  static bool get _isAppOpenExpired {
    if (_appOpenLoadedTime == null) return true;
    return DateTime.now().difference(_appOpenLoadedTime!) >
        const Duration(hours: 4);
  }

  static void showAppOpenAdIfAvailable() {
    if (_appOpenAd == null || _isShowingAppOpen || _isAppOpenExpired) {
      loadAppOpenAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) => _isShowingAppOpen = true,
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAppOpen = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAppOpen = false;
        ad.dispose();
        _appOpenAd = null;
      },
    );

    _appOpenAd!.show();
  }

  static void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (error) {
          logDebug('Interstitial failed: ${error.message}');
        },
      ),
    );
  }

  static void incrementActionAndShowInterstitial() {
    _actionCount++;
    if (_actionCount < _showInterstitialAfter) return;
    _actionCount = 0;

    final ad = _interstitialAd;
    if (ad == null) {
      loadInterstitial();
      return;
    }

    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
      },
    );

    ad.show();
    _interstitialAd = null;
  }

  static Future<BannerAd> createAdaptiveBannerAd(double width) async {
    final size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width.truncate());

    final bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: size ?? AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          logDebug('Banner failed: ${error.message}');
        },
      ),
    );

    await bannerAd.load();
    return bannerAd;
  }
}
