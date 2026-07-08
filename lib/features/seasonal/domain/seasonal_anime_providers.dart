import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

import '../data/seasonal_anime_repository.dart';

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

  return _sortAnime(
    _filterAnime(_distinctByTitle(sourceAnime), filters, typeFilter),
    sort,
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
    if (!_matchesType(item, typeFilter)) {
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

enum SeasonalSort {
  apiOrder('Jikan order'),
  titleAsc('Title'),
  scoreDesc('Rating'),
  popularityAsc('Popularity'),
  membersDesc('Members');

  const SeasonalSort(this.label);

  final String label;
}

enum AnimeContentRating {
  g('G - All Ages'),
  pg('PG - Children'),
  pg13('PG-13 - Teens 13 or older'),
  r17('R - 17+ (violence & profanity)'),
  rPlus('R+ - Mild Nudity'),
  rx('Rx - Hentai');

  const AnimeContentRating(this.label);

  final String label;
}

final class SeasonalFilters {
  const SeasonalFilters({
    required this.query,
    required this.ratings,
    required this.airing,
    required this.minScore,
    required this.maxScore,
    required this.genres,
  });

  factory SeasonalFilters.empty() {
    return const SeasonalFilters(
      query: '',
      ratings: {},
      airing: null,
      minScore: 0,
      maxScore: 10,
      genres: {},
    );
  }

  final String query;
  final Set<AnimeContentRating> ratings;
  final bool? airing;
  final double minScore;
  final double maxScore;
  final Set<String> genres;

  bool get hasActiveCachedFilters {
    return query.trim().isNotEmpty ||
        ratings.isNotEmpty ||
        airing != null ||
        minScore > 0 ||
        maxScore < 10 ||
        genres.isNotEmpty;
  }

  SeasonalFilters copyWith({
    String? query,
    Set<AnimeContentRating>? ratings,
    bool? airing,
    bool clearAiring = false,
    double? minScore,
    double? maxScore,
    Set<String>? genres,
  }) {
    return SeasonalFilters(
      query: query ?? this.query,
      ratings: ratings ?? this.ratings,
      airing: clearAiring ? null : airing ?? this.airing,
      minScore: minScore ?? this.minScore,
      maxScore: maxScore ?? this.maxScore,
      genres: genres ?? this.genres,
    );
  }
}

List<Anime> _sortAnime(List<Anime> anime, SeasonalSort sort) {
  final sorted = List<Anime>.of(anime);

  switch (sort) {
    case SeasonalSort.apiOrder:
      return sorted;
    case SeasonalSort.titleAsc:
      sorted.sort((a, b) => a.title.compareTo(b.title));
    case SeasonalSort.scoreDesc:
      sorted.sort((a, b) => _compareNullableDesc(a.score, b.score));
    case SeasonalSort.popularityAsc:
      sorted.sort((a, b) => _compareNullableAsc(a.popularity, b.popularity));
    case SeasonalSort.membersDesc:
      sorted.sort((a, b) => _compareNullableDesc(a.members, b.members));
  }

  return sorted;
}

List<Anime> _filterAnime(
  List<Anime> anime,
  SeasonalFilters filters,
  AnimeType? typeFilter,
) {
  if (!filters.hasActiveCachedFilters && typeFilter == null) {
    return anime;
  }

  final normalizedQuery = filters.query.trim().toLowerCase();

  return [
    for (final item in anime)
      if (_matchesType(item, typeFilter) &&
          _matchesTitle(item, normalizedQuery) &&
          _matchesAiring(item, filters.airing) &&
          _matchesRating(item, filters.ratings) &&
          _matchesScore(item, filters.minScore, filters.maxScore) &&
          _matchesGenres(item, filters.genres))
        item,
  ];
}

bool _matchesType(Anime anime, AnimeType? typeFilter) {
  if (typeFilter == null) {
    return true;
  }

  final type = anime.type;
  if (type == null) {
    return false;
  }

  return _normalizedType(type) == _normalizedType(typeFilter.name);
}

String _normalizedType(String type) {
  return type.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
}

bool _matchesTitle(Anime anime, String query) {
  if (query.isEmpty) {
    return true;
  }

  final titles = [
    anime.title,
    if (anime.titleEnglish != null) anime.titleEnglish!,
    if (anime.titleJapanese != null) anime.titleJapanese!,
    ...anime.titleSynonyms,
  ];

  return titles.any((title) => title.toLowerCase().contains(query));
}

bool _matchesAiring(Anime anime, bool? airing) {
  return airing == null || anime.airing == airing;
}

bool _matchesRating(Anime anime, Set<AnimeContentRating> ratings) {
  if (ratings.isEmpty) {
    return true;
  }

  final rating = anime.rating?.trim();
  return rating != null &&
      ratings.any((selectedRating) => selectedRating.label == rating);
}

bool _matchesScore(Anime anime, double minScore, double maxScore) {
  if (minScore <= 0 && maxScore >= 10) {
    return true;
  }

  final score = anime.score;
  return score != null && score >= minScore && score <= maxScore;
}

bool _matchesGenres(Anime anime, Set<String> genres) {
  if (genres.isEmpty) {
    return true;
  }

  final animeGenres = anime.genres.map((genre) => genre.name).toSet();
  return genres.every(animeGenres.contains);
}

List<Anime> _distinctByTitle(List<Anime> anime) {
  final seenTitles = <String>{};
  final result = <Anime>[];

  for (final item in anime) {
    final title = _normalizedTitle(item);
    if (seenTitles.add(title)) {
      result.add(item);
    }
  }

  return result;
}

String _normalizedTitle(Anime anime) {
  final title = anime.titleEnglish?.trim().isNotEmpty ?? false
      ? anime.titleEnglish!
      : anime.title;

  return title.trim().toLowerCase();
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

int _compareNullableAsc(num? a, num? b) {
  if (a == null && b == null) {
    return 0;
  }
  if (a == null) {
    return 1;
  }
  if (b == null) {
    return -1;
  }

  return a.compareTo(b);
}

int _compareNullableDesc(num? a, num? b) {
  return _compareNullableAsc(b, a);
}
