import 'package:flutter/material.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

/// Real Yandex banner ad widget.
///
/// Replaces the previous `_BannerAdStub` / `_NativeAdStub` placeholders.
/// Renders nothing if the ad fails to load (e.g. offline, no fill).
class YandexBannerAd extends StatefulWidget {
  const YandexBannerAd({
    super.key,
    required this.unitId,
    this.height = 80,
  });

  final String unitId;
  final double height;

  @override
  State<YandexBannerAd> createState() => _YandexBannerAdState();
}

class _YandexBannerAdState extends State<YandexBannerAd> {
  BannerAd? _banner;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final width = MediaQuery.of(context).size.width.round();
    final banner = BannerAd(
      adSize: BannerAdSize.inline(
        width: width,
        maxHeight: widget.height.round(),
      ),
    );
    banner.loadStateStream.listen((state) {
      if (state is BannerAdLoadStateError && mounted) {
        setState(() => _failed = true);
      }
    });
    try {
      await banner.load(AdRequest(adUnitId: widget.unitId));
      if (mounted) setState(() => _banner = banner);
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failed || _banner == null) return const SizedBox.shrink();
    return SizedBox(
      width: double.infinity,
      height: widget.height,
      child: AdWidget(bannerAd: _banner!),
    );
  }

  @override
  void dispose() {
    _banner?.destroy();
    super.dispose();
  }
}
