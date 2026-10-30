import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habit_tracker/features/monetization/data/yandex_ads_repository.dart';
import 'package:habit_tracker/features/monetization/domain/ads_repository.dart';

final adsRepositoryProvider = Provider<AdsRepository>((ref) {
  return YandexAdsRepository();
});
