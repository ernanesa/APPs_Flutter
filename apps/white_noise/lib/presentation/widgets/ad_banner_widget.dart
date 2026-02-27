import 'package:flutter/material.dart';
import 'package:core_logic/core_logic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';




class AdBannerWidget extends StatefulWidget {
  const AdBannerWidget({super.key});

  @override
  State<AdBannerWidget> createState() => _AdBannerWidgetState();
}

class _AdBannerWidgetState extends State<AdBannerWidget> {
  BannerAd? _bannerAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ConsentService.canRequestAds().then((canRequest) {
      if (canRequest) _load();
    });
  }

  Future<void> _load() async {
    final width = MediaQuery.of(context).size.width;
    final ad = await AdService.createAdaptiveBannerAd(width: width.toInt());
    if (!mounted && ad != null) {
      ad.dispose();
      return;
    }
    setState(() => _bannerAd = ad);
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ad = _bannerAd;
    if (ad == null) return const SizedBox.shrink();

    return SizedBox(
      width: ad.size.width.toDouble(),
      height: ad.size.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
