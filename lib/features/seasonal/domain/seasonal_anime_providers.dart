import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

import '../data/seasonal_anime_repository.dart';
import 'models/seasonal_filters.dart';
import 'services/seasonal_anime_filtering.dart';

const visibleSeasonalPageCount = 5;

final seasonalAnimeRepositoryProvider = Provider<SeasonalAnimeRepository>((
  ref,
) {
  return SeasonalAnimeRepository();
});

final seasonalCacheControllerProvider = Provider<SeasonalCacheController>((
  ref,
) {
  return SeasonalCacheController(ref);
});

final seasonalTypeFilterProvider =
    NotifierProvider<SeasonalTypeFilterNotifier, AnimeType?>(
      SeasonalTypeFilterNotifier.new,
    );

final seasonalSortProvider =
    NotifierProvider<SeasonalSortNotifier, SeasonalSort>(
      SeasonalSortNotifier.new,
    );

final seasonalFiltersProvider =
    NotifierProvider<SeasonalFiltersNotifier, SeasonalFilters>(
      SeasonalFiltersNotifier.new,
    );

final seasonalPageProvider = NotifierProvider<SeasonalPageNotifier, int>(
  SeasonalPageNotifier.new,
);

final seasonalLastPageProvider =
    NotifierProvider<SeasonalLastPageNotifier, int?>(
      SeasonalLastPageNotifier.new,
    );

final seasonalMaxLoadedPageProvider =
    NotifierProvider<SeasonalMaxLoadedPageNotifier, int>(
      SeasonalMaxLoadedPageNotifier.new,
    );

final seasonalCacheGenerationProvider =
    NotifierProvider<SeasonalCacheGenerationNotifier, int>(
      SeasonalCacheGenerationNotifier.new,
    );

final seasonalFullCacheLoadingProvider =
    NotifierProvider<SeasonalFullCacheLoadingNotifier, bool>(
      SeasonalFullCacheLoadingNotifier.new,
    );

final seasonalAnimeProvider = FutureProvider<List<Anime>>((ref) async {
  final typeFilter = ref.watch(seasonalTypeFilterProvider);
  final sort = ref.watch(seasonalSortProvider);
  final filters = ref.watch(seasonalFiltersProvider);
  final page = ref.watch(seasonalPageProvider);
  ref.watch(seasonalCacheGenerationProvider);
  final repository = ref.watch(seasonalAnimeRepositoryProvider);
  final hasCachedFilters = filters.hasActiveCachedFilters || typeFilter != null;
  final apiPage = hasCachedFilters ? 1 : page;
  final anime = await repository.getCurrentSeasonAnime(page: apiPage);
  _syncPaginationCacheState(ref: ref, repository: repository, type: null);

  if (anime.isEmpty) {
    final lastPage = apiPage <= 1 ? 1 : apiPage - 1;
    ref.read(seasonalLastPageProvider.notifier).rememberLastPage(lastPage);
    if (!hasCachedFilters) {
      ref.read(seasonalPageProvider.notifier).goToPage(lastPage);
    }
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

final seasonalAvailableGenresProvider = Provider<List<String>>((ref) {
  final typeFilter = ref.watch(seasonalTypeFilterProvider);
  final anime = ref
      .watch(seasonalAnimeProvider)
      .maybeWhen(data: (items) => items, orElse: () => const <Anime>[]);
  final repository = ref.watch(seasonalAnimeRepositoryProvider);
  final genres = <String>{};

  for (final item in [...repository.getCachedAnime(), ...anime]) {
    if (!matchesSeasonalAnimeType(item, typeFilter)) {
      continue;
    }

    for (final genre in item.genres) {
      final name = genre.name.trim();
      if (name.isNotEmpty) {
        genres.add(name);
      }
    }
  }

  return genres.toList()..sort();
});

final seasonalHasActiveCachedFiltersProvider = Provider<bool>((ref) {
  return ref.watch(seasonalTypeFilterProvider) != null ||
      ref.watch(seasonalFiltersProvider).hasActiveCachedFilters;
});

final class SeasonalCacheController {
  SeasonalCacheController(this._ref);

  final Ref _ref;
  int _activeCacheCount = 0;

  void startFullCache({
    required SeasonalAnimeRepository repository,
    required AnimeType? type,
  }) {
    if (repository.isFullCacheStarted(type: type)) {
      return;
    }

    repository.markFullCacheStarted(type: type);
    _activeCacheCount += 1;
    _ref.read(seasonalFullCacheLoadingProvider.notifier).setLoading(true);

    unawaited(
      _cacheRemainingPages(
        ref: _ref,
        repository: repository,
        type: type,
      ).whenComplete(() {
        _activeCacheCount -= 1;
        _ref
            .read(seasonalFullCacheLoadingProvider.notifier)
            .setLoading(_activeCacheCount > 0);
      }),
    );
  }
}

class SeasonalTypeFilterNotifier extends Notifier<AnimeType?> {
  @override
  AnimeType? build() {
    return null;
  }

  void setType(AnimeType? type) {
    state = type;
  }
}

class SeasonalSortNotifier extends Notifier<SeasonalSort> {
  @override
  SeasonalSort build() {
    return SeasonalSort.apiOrder;
  }

  void setSort(SeasonalSort sort) {
    state = sort;
  }
}

class SeasonalFiltersNotifier extends Notifier<SeasonalFilters> {
  @override
  SeasonalFilters build() {
    return SeasonalFilters.empty();
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
    ref.read(seasonalPageProvider.notifier).reset();
  }

  void setAiring(bool? airing) {
    state = state.copyWith(airing: airing, clearAiring: airing == null);
    ref.read(seasonalPageProvider.notifier).reset();
  }

  void toggleRating(AnimeContentRating rating) {
    final ratings = Set<AnimeContentRating>.of(state.ratings);
    if (!ratings.add(rating)) {
      ratings.remove(rating);
    }

    state = state.copyWith(ratings: ratings);
    ref.read(seasonalPageProvider.notifier).reset();
  }

  void setScoreRange(double minScore, double maxScore) {
    state = state.copyWith(minScore: minScore, maxScore: maxScore);
    ref.read(seasonalPageProvider.notifier).reset();
  }

  void toggleGenre(String genre) {
    final genres = Set<String>.of(state.genres);
    if (!genres.add(genre)) {
      genres.remove(genre);
    }

    state = state.copyWith(genres: genres);
    ref.read(seasonalPageProvider.notifier).reset();
  }

  void clear() {
    state = SeasonalFilters.empty();
    ref.read(seasonalPageProvider.notifier).reset();
  }
}

class SeasonalPageNotifier extends Notifier<int> {
  @override
  int build() {
    return 1;
  }

  void goToPreviousPage() {
    if (state <= 1) {
      return;
    }

    state -= 1;
  }

  void goToNextPage({int? lastPageOverride}) {
    final lastPage = lastPageOverride ?? ref.read(seasonalLastPageProvider);
    if (lastPage != null && state >= lastPage) {
      return;
    }

    final maxLoadedPage = ref.read(seasonalMaxLoadedPageProvider);
    if (lastPage == null && state >= maxLoadedPage) {
      return;
    }

    state += 1;
  }

  void loadNextPage() {
    final lastPage = ref.read(seasonalLastPageProvider);
    if (lastPage != null && state >= lastPage) {
      return;
    }

    state += 1;
  }

  void goToPage(int page, {int? lastPageOverride}) {
    if (page < 1) {
      return;
    }

    final maxLoadedPage = ref.read(seasonalMaxLoadedPageProvider);
    final availablePage =
        lastPageOverride ?? ref.read(seasonalLastPageProvider) ?? maxLoadedPage;
    state = page <= availablePage ? page : availablePage;
  }

  void reset() {
    state = 1;
  }
}

class SeasonalLastPageNotifier extends Notifier<int?> {
  @override
  int? build() {
    return null;
  }

  void rememberLastPage(int page) {
    final normalizedPage = page < 1 ? 1 : page;
    if (state == null || normalizedPage < state!) {
      state = normalizedPage;
    }
  }

  void reset() {
    state = null;
  }
}

class SeasonalMaxLoadedPageNotifier extends Notifier<int> {
  @override
  int build() {
    return 1;
  }

  void rememberMaxLoadedPage(int page) {
    if (page > state) {
      state = page;
    }
  }

  void reset() {
    state = 1;
  }
}

class SeasonalCacheGenerationNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void bump() {
    state += 1;
  }
}

class SeasonalFullCacheLoadingNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setLoading(bool loading) {
    state = loading;
  }
}

Future<void> _cacheRemainingPages({
  required Ref ref,
  required SeasonalAnimeRepository repository,
  required AnimeType? type,
}) async {
  await _cachePagesUntilEmpty(
    ref: ref,
    repository: repository,
    type: type,
    startPage: 2,
  );
}

Future<void> _cachePagesUntilEmpty({
  required Ref ref,
  required SeasonalAnimeRepository repository,
  required AnimeType? type,
  required int startPage,
  int? endPage,
}) async {
  var page = startPage;
  while (endPage == null || page <= endPage) {
    final anime = await repository.getCurrentSeasonAnime(
      type: type,
      page: page,
    );

    if (!ref.mounted) {
      return;
    }

    _syncPaginationCacheState(ref: ref, repository: repository, type: type);
    ref.read(seasonalCacheGenerationProvider.notifier).bump();

    if (anime.isEmpty) {
      ref.read(seasonalLastPageProvider.notifier).rememberLastPage(page - 1);
      return;
    }

    page += 1;
  }
}

void _syncPaginationCacheState({
  required Ref ref,
  required SeasonalAnimeRepository repository,
  required AnimeType? type,
}) {
  final lastPage = repository.getKnownLastPage(type: type);
  final maxLoadedPage = repository.getMaxContiguousLoadedPage(type: type);
  if (lastPage != null) {
    ref.read(seasonalLastPageProvider.notifier).rememberLastPage(lastPage);
  }

  ref
      .read(seasonalMaxLoadedPageProvider.notifier)
      .rememberMaxLoadedPage(maxLoadedPage);
}
