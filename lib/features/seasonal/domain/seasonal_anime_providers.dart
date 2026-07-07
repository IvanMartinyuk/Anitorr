import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

import '../data/seasonal_anime_repository.dart';

final seasonalAnimeRepositoryProvider = Provider<SeasonalAnimeRepository>((
  ref,
) {
  return SeasonalAnimeRepository();
});

final seasonalTypeFilterProvider =
    NotifierProvider<SeasonalTypeFilterNotifier, AnimeType?>(
      SeasonalTypeFilterNotifier.new,
    );

final seasonalSortProvider =
    NotifierProvider<SeasonalSortNotifier, SeasonalSort>(
      SeasonalSortNotifier.new,
    );

final seasonalPageProvider = NotifierProvider<SeasonalPageNotifier, int>(
  SeasonalPageNotifier.new,
);

final seasonalLastPageProvider =
    NotifierProvider<SeasonalLastPageNotifier, int?>(
      SeasonalLastPageNotifier.new,
    );

final seasonalAnimeProvider = FutureProvider<List<Anime>>((ref) async {
  final type = ref.watch(seasonalTypeFilterProvider);
  final sort = ref.watch(seasonalSortProvider);
  final page = ref.watch(seasonalPageProvider);
  final repository = ref.watch(seasonalAnimeRepositoryProvider);
  final anime = await repository.getCurrentSeasonAnime(type: type, page: page);

  if (anime.isEmpty) {
    final lastPage = page <= 1 ? 1 : page - 1;
    ref.read(seasonalLastPageProvider.notifier).rememberLastPage(lastPage);
    ref.read(seasonalPageProvider.notifier).goToPage(lastPage);
    return [];
  }

  unawaited(
    _discoverLastPageAhead(
      ref: ref,
      repository: repository,
      type: type,
      currentPage: page,
    ),
  );

  return _sortAnime(_distinctByTitle(anime), sort);
});

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

  void goToNextPage() {
    final lastPage = ref.read(seasonalLastPageProvider);
    if (lastPage != null && state >= lastPage) {
      return;
    }

    state += 1;
  }

  void goToPage(int page) {
    if (page < 1) {
      return;
    }

    final lastPage = ref.read(seasonalLastPageProvider);
    state = lastPage == null || page <= lastPage ? page : lastPage;
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

enum SeasonalSort {
  apiOrder('Jikan order'),
  titleAsc('Title'),
  scoreDesc('Rating'),
  popularityAsc('Popularity'),
  membersDesc('Members');

  const SeasonalSort(this.label);

  final String label;
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

Future<void> _discoverLastPageAhead({
  required Ref ref,
  required SeasonalAnimeRepository repository,
  required AnimeType? type,
  required int currentPage,
}) async {
  if (ref.read(seasonalLastPageProvider) != null) {
    return;
  }

  final visibleEndPage = _visiblePageRangeEnd(currentPage);
  final probeEndPage = visibleEndPage + 5;

  for (var page = currentPage + 1; page <= probeEndPage; page++) {
    final anime = await repository.getCurrentSeasonAnime(
      type: type,
      page: page,
    );
    if (anime.isEmpty) {
      if (!ref.mounted) {
        return;
      }

      ref.read(seasonalLastPageProvider.notifier).rememberLastPage(page - 1);
      return;
    }
  }
}

int _visiblePageRangeEnd(int currentPage) {
  final start = currentPage <= 3 ? 1 : currentPage - 2;
  return start + 4;
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
