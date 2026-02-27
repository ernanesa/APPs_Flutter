import 'package:flutter/material.dart';
import 'package:core_logic/core_logic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


import '../utils/logger.dart';

class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    // Only load if consent allows
    final canReq = await ConsentService.canRequestAds();
    if (!canReq) {
      return; 
    }

    // Prevent reloading if already loaded or if width is zero
    if (_isLoaded || _bannerAd != null) return;

    final width = MediaQuery.of(context).size.width.truncate();
    if (width <= 0) return;

    _bannerAd = await AdService.createAdaptiveBannerAd(width: width);
    if (mounted && _bannerAd != null) {
      setState(() {
        _isLoaded = true;
      });
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
