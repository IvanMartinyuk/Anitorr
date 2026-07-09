import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/app_anime.dart';
import '../services/seasonal_anime_filtering.dart';
import 'seasonal_cache_controller.dart';
import 'seasonal_filter_providers.dart';
import 'seasonal_pagination_providers.dart';
import 'seasonal_repository_provider.dart';

final seasonalAnimeProvider = FutureProvider<List<AppAnime>>((ref) async {
  final typeFilter = ref.watch(seasonalTypeFilterProvider);
  final sort = ref.watch(seasonalSortProvider);
  final filters = ref.watch(seasonalFiltersProvider);
  final page = ref.watch(seasonalPageProvider);
  final repository = ref.watch(seasonalAnimeRepositoryProvider);
  final hasCachedFilters = filters.hasActiveCachedFilters || typeFilter != null;
  final apiPage = hasCachedFilters ? 1 : page;
  final anime = await repository.getCurrentSeasonAnime(page: apiPage);
  runAfterBuildIfNeeded(ref, () {
    syncSeasonalPaginationCacheState(
      ref: ref,
      repository: repository,
      type: null,
    );
  });

  if (anime.isEmpty) {
    final lastPage = apiPage <= 1 ? 1 : apiPage - 1;
    runAfterBuildIfNeeded(ref, () {
      ref.read(seasonalLastPageProvider.notifier).rememberLastPage(lastPage);
      if (!hasCachedFilters) {
        ref.read(seasonalPageProvider.notifier).goToPage(lastPage);
      }
    });
    return [];
  }

  ref
      .read(seasonalCacheControllerProvider)
      .startFullCache(repository: repository, type: null);

  final sourceAnime = hasCachedFilters
      ? repository.getCachedAnime()
      : repository.getCachedAnimeUpToPage(page);

  return prepareSeasonalAnime(
    anime: sourceAnime,
    filters: filters,
    sort: sort,
    typeFilter: typeFilter,
  );
});
