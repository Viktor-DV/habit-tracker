import 'package:yandex_mobileads/mobile_ads.dart';
import 'package:habit_tracker/features/monetization/domain/ads_repository.dart';

/// Real Yandex Mobile Ads implementation.
///
/// Swap-in for [StubAdsRepository] — same interface, no UI changes required.
class YandexAdsRepository implements AdsRepository {
  @override
  bool get adsAvailable => true;

  @override
  Future<void> initialize() => YandexAds.initialize();
}
