import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/features/monetization/data/stub_ads_repository.dart';
import 'package:habit_tracker/features/monetization/data/stub_premium_repository.dart';
import 'package:habit_tracker/features/monetization/domain/ads_repository.dart';
import 'package:habit_tracker/features/monetization/domain/premium_repository.dart';
import 'package:habit_tracker/features/settings/data/settings_repository.dart';

final premiumRepositoryProvider = Provider<PremiumRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).requireValue;
  return StubPremiumRepository(prefs);
});

final adsRepositoryProvider = Provider<AdsRepository>((ref) {
  return StubAdsRepository();
});

/// Live premium status — watches the repository's cached value.
/// Notifier allows refreshing after a purchase attempt.
class PremiumNotifier extends Notifier<PremiumStatus> {
  @override
  PremiumStatus build() =>
      ref.watch(premiumRepositoryProvider).cachedStatus;

  Future<PremiumStatus> purchase() async {
    state = PremiumStatus.pending;
    final result = await ref.read(premiumRepositoryProvider).purchase();
    state = result;
    return result;
  }

  Future<void> refresh() async {
    final result = await ref.read(premiumRepositoryProvider).refresh();
    state = result;
  }
}

final premiumProvider =
    NotifierProvider<PremiumNotifier, PremiumStatus>(PremiumNotifier.new);

/// Convenience: true when user has Premium.
final isPremiumProvider = Provider<bool>(
  (ref) => ref.watch(premiumProvider) == PremiumStatus.premium,
);

/// Max habits for Free tier.
const int kFreeHabitLimit = 5;
