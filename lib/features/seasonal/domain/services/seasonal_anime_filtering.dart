import 'package:jikan_api/jikan_api.dart';

import '../models/seasonal_filters.dart';

List<Anime> prepareSeasonalAnime({
  required List<Anime> anime,
  required SeasonalFilters filters,
  required SeasonalSort sort,
  AnimeType? typeFilter,
}) {
  final distinctAnime = distinctAnimeByPreferredTitle(anime);
  final filteredAnime = filterSeasonalAnime(
    distinctAnime,
    filters: filters,
    typeFilter: typeFilter,
  );

  return sortSeasonalAnime(filteredAnime, sort);
}

List<Anime> sortSeasonalAnime(List<Anime> anime, SeasonalSort sort) {
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

List<Anime> filterSeasonalAnime(
  List<Anime> anime, {
  required SeasonalFilters filters,
  AnimeType? typeFilter,
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
          _matchesRating(item, filters.ratings) &&
          _matchesScore(item, filters.minScore, filters.maxScore) &&
          _matchesGenres(item, filters.genres))
        item,
  ];
}

List<Anime> distinctAnimeByPreferredTitle(List<Anime> anime) {
  final seenTitles = <String>{};
  final result = <Anime>[];

  for (final item in anime) {
    final title = _normalizedPreferredTitle(item);
    if (seenTitles.add(title)) {
      result.add(item);
    }
  }

  return result;
}

bool matchesSeasonalAnimeType(Anime anime, AnimeType? typeFilter) {
  if (typeFilter == null) {
    return true;
  }

  final type = anime.type;
  if (type == null) {
    return false;
  }

  // Jikan returns labels like "TV Special", while the package enum uses
  // names like "tv_special"; normalize both before comparing.
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

String _normalizedPreferredTitle(Anime anime) {
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
