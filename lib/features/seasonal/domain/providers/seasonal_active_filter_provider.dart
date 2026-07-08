import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'seasonal_filter_providers.dart';

final seasonalHasActiveCachedFiltersProvider = Provider<bool>((ref) {
  return ref.watch(seasonalTypeFilterProvider) != null ||
      ref.watch(seasonalFiltersProvider).hasActiveCachedFilters;
});
