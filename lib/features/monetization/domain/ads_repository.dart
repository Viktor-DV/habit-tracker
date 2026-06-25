/// Ad placement types used in the UI.
enum AdSlot { bannerTop, nativeInList }

/// Describes one ad unit. Returned to the UI layer as data;
/// the UI decides how to render it.
class AdUnit {
  const AdUnit({required this.slot, required this.unitId});
  final AdSlot slot;
  final String unitId;
}

/// Yandex Mobile Ads — production unit IDs (SDK app ID: 19502100).
/// Banner block created 25-06-2026 in Yandex Publisher console.
/// ponytail: native block not yet created — create in publisher console,
/// then replace 'R-M-19502100-2' with the real native block ID.
const AdUnit kBannerUnit = AdUnit(
  slot: AdSlot.bannerTop,
  unitId: 'R-M-19502100-1',
);
const AdUnit kNativeUnit = AdUnit(
  slot: AdSlot.nativeInList,
  unitId: 'R-M-19502100-2', // ponytail: создать нативный блок в Яндекс.Паблишер
);

/// UI-facing contract. The stub always says ads are available;
/// the real impl initialises the Yandex SDK.
abstract interface class AdsRepository {
  /// Whether ads are currently loadable (SDK initialised, consent given, etc.).
  bool get adsAvailable;

  /// Called once at startup.
  Future<void> initialize();
}
