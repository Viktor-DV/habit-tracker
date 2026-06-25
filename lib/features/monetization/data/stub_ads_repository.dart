import 'package:habit_tracker/features/monetization/domain/ads_repository.dart';

/// Stub AdsRepository — always reports ads as available.
///
/// ponytail: swap for `YandexAdsRepository` when Yandex Mobile Ads SDK
/// is configured (maven repo + app key in AndroidManifest).
/// Interface stays identical; only this class changes.
class StubAdsRepository implements AdsRepository {
  @override
  bool get adsAvailable => true;

  @override
  Future<void> initialize() async {
    // Real impl: MobileAds.initialize(appId: '...');
  }
}
