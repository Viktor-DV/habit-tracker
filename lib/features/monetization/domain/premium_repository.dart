/// Premium purchase status.
enum PremiumStatus { free, premium, pending }

/// All habit-domain code depends on this interface only.
/// The stub uses SharedPreferences; the real impl plugs RuStore Billing in.
abstract interface class PremiumRepository {
  /// Returns the current status from local cache (instant, offline-safe).
  PremiumStatus get cachedStatus;

  /// Refresh from the billing backend. Throws on network error.
  /// Updates cache and returns the new status.
  Future<PremiumStatus> refresh();

  /// Initiates the purchase flow. Returns the resulting status.
  Future<PremiumStatus> purchase();

  bool get isPremium => cachedStatus == PremiumStatus.premium;
}

/// The single product ID registered in RuStore.
const String kRuStorePremiumProductId = 'premium_forever';
