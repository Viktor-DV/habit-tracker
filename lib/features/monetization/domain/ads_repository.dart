/// Ad placement types used in the UI.
enum AdSlot { bannerTop }

/// Describes one ad unit. Returned to the UI layer as data;
/// the UI decides how to render it.
class AdUnit {
  const AdUnit({required this.slot, required this.unitId});
  final AdSlot slot;
  final String unitId;
}

/// Yandex Mobile Ads — production unit IDs (SDK app ID: 19502100).
/// Banner block "Баннер 25-06-2026" created in Yandex Publisher console.
///
/// NOTE: the official Flutter plugin (yandex_mobileads 8.1.0) does NOT support
/// native ads (only Banner / Interstitial / Rewarded / AppOpen). The in-list
/// placement therefore reuses the same banner block.
const AdUnit kBannerUnit = AdUnit(
  slot: AdSlot.bannerTop,
  unitId: 'R-M-19502100-1',
);

/// UI-facing contract. The real impl initialises the Yandex SDK.
abstract interface class AdsRepository {
  /// Whether ads are currently loadable (SDK initialised, consent given, etc.).
  bool get adsAvailable;

  /// Called once at startup.
  Future<void> initialize();
}
