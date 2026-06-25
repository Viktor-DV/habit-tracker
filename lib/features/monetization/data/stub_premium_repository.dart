import 'package:shared_preferences/shared_preferences.dart';
import 'package:habit_tracker/features/monetization/domain/premium_repository.dart';

const String _kPremiumKey = 'premium_status';

/// Stub implementation: persists status in SharedPreferences.
///
/// ponytail: replaces the real RuStore Billing impl.
/// Upgrade path: swap this class for `RuStorePremiumRepository` that wraps
/// the RuStore Billing SDK and calls `_prefs.setString` on purchase.
/// No other code changes needed.
class StubPremiumRepository implements PremiumRepository {
  StubPremiumRepository(this._prefs);

  final SharedPreferences _prefs;

  @override
  PremiumStatus get cachedStatus {
    final raw = _prefs.getString(_kPremiumKey) ?? 'free';
    return PremiumStatus.values.firstWhere(
      (s) => s.name == raw,
      orElse: () => PremiumStatus.free,
    );
  }

  @override
  bool get isPremium => cachedStatus == PremiumStatus.premium;

  @override
  Future<PremiumStatus> refresh() async {
    // ponytail: no live billing backend in stub.
    // Real impl: call RuStore SDK, then persist result.
    return cachedStatus;
  }

  @override
  Future<PremiumStatus> purchase() async {
    // ponytail: stub grants premium immediately (for dev/testing).
    // Real impl: launch RuStore purchase flow, await confirmation.
    await _prefs.setString(_kPremiumKey, PremiumStatus.premium.name);
    return PremiumStatus.premium;
  }

  /// Dev helper — resets to free (useful for testing the paywall).
  Future<void> resetToFree() async {
    await _prefs.setString(_kPremiumKey, PremiumStatus.free.name);
  }
}
