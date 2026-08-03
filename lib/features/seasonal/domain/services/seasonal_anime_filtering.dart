import '../../../../shared/models/anime_api_filters.dart';
import '../../../../shared/models/app_anime.dart';
import '../../../../shared/models/sort_direction.dart';
import '../models/seasonal_filters.dart';

List<AppAnime> prepareSeasonalAnime({
  required List<AppAnime> anime,
  required SeasonalFilters filters,
  required SeasonalSort sort,
  required SortDirection sortDirection,
  AppAnimeType? typeFilter,
}) {
  final distinctAnime = distinctAnimeByPreferredTitle(anime);
  final filteredAnime = filterSeasonalAnime(
    distinctAnime,
    filters: filters,
    typeFilter: typeFilter,
  );

  return sortSeasonalAnime(filteredAnime, sort, sortDirection);
}

List<AppAnime> sortSeasonalAnime(
  List<AppAnime> anime,
  SeasonalSort sort,
  SortDirection direction,
) {
  final sorted = List<AppAnime>.of(anime);

  switch (sort) {
    case SeasonalSort.apiOrder:
      return sorted;
    case SeasonalSort.titleAsc:
      sorted.sort((a, b) => _compareByDirection(a.title, b.title, direction));
    case SeasonalSort.scoreDesc:
      sorted.sort((a, b) => _compareNullable(a.score, b.score, direction));
    case SeasonalSort.popularityAsc:
      sorted.sort(
        (a, b) => _compareNullable(a.popularity, b.popularity, direction),
      );
    case SeasonalSort.membersDesc:
      sorted.sort((a, b) => _compareNullable(a.members, b.members, direction));
  }

  return sorted;
}

List<AppAnime> filterSeasonalAnime(
  List<AppAnime> anime, {
  required SeasonalFilters filters,
  AppAnimeType? typeFilter,
}) {
  if (!filters.hasActiveCachedFilters && typeFilter == null) {
    return anime;
  }

  final normalizedQuery = filters.query.trim().toLowerCase();

  return [
    for (final item in anime)
      if (matchesSeasonalAnimeType(item, typeFilter) &&
          _matchesTitle(item, normalizedQuery) &&
          _matchesAiring(item, filters.airing) &&
          _matchesScore(item, filters.minScore, filters.maxScore) &&
          _matchesReleaseWeekday(item, filters.releaseWeekdays) &&
          _matchesGenres(item, filters.genres) &&
          _matchesTags(item, filters.tags))
        item,
  ];
}

List<AppAnime> distinctAnimeByPreferredTitle(List<AppAnime> anime) {
  final seenTitles = <String>{};
  final result = <AppAnime>[];

  for (final item in anime) {
    final title = _normalizedPreferredTitle(item);
    if (seenTitles.add(title)) {
      result.add(item);
    }
  }

  return result;
}

bool matchesSeasonalAnimeType(AppAnime anime, AppAnimeType? typeFilter) {
  if (typeFilter == null) {
    return true;
  }

  final type = anime.type;
  if (type == null) {
    return false;
  }

  // API clients may return labels like "TV Special", while the app enum uses
  // values like "tv_special"; normalize both before comparing.
  return _normalizedType(type) == _normalizedType(typeFilter.apiValue);
}

String _normalizedType(String type) {
  return type.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
}

bool _matchesTitle(AppAnime anime, String query) {
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

bool _matchesAiring(AppAnime anime, bool? airing) {
  return airing == null || anime.airing == airing;
}

bool _matchesScore(AppAnime anime, double minScore, double maxScore) {
  if (minScore <= 0 && maxScore >= 10) {
    return true;
  }

  final score = anime.score;
  return score != null && score >= minScore && score <= maxScore;
}

bool _matchesReleaseWeekday(
  AppAnime anime,
  Set<ReleaseWeekday> releaseWeekdays,
) {
  if (releaseWeekdays.isEmpty) {
    return true;
  }

  final nextAiringAt = anime.nextAiringAt;
  return nextAiringAt != null &&
      releaseWeekdays.any(
        (weekday) => weekday.dateTimeValue == nextAiringAt.weekday,
      );
}

bool _matchesGenres(AppAnime anime, Set<String> genres) {
  if (genres.isEmpty) {
    return true;
  }

  final animeGenres = anime.genres.map((genre) => genre.name).toSet();
  return genres.every(animeGenres.contains);
}

bool _matchesTags(AppAnime anime, Set<String> tags) {
  if (tags.isEmpty) {
    return true;
  }

  final animeTags = anime.tags.map((tag) => tag.name).toSet();
  return tags.every(animeTags.contains);
}

String _normalizedPreferredTitle(AppAnime anime) {
  final title = anime.titleEnglish?.trim().isNotEmpty ?? false
      ? anime.titleEnglish!
      : anime.title;

  return title.trim().toLowerCase();
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

int _compareNullable(num? a, num? b, SortDirection direction) {
  return direction.isDescending
      ? _compareNullableDesc(a, b)
      : _compareNullableAsc(a, b);
}

int _compareByDirection(String a, String b, SortDirection direction) {
  return direction.isDescending ? b.compareTo(a) : a.compareTo(b);
}
