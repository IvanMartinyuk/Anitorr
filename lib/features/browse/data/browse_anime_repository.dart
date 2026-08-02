import 'package:anilist_api/anilist_api.dart';

import '../../../shared/models/anime_api_filters.dart';
import '../../../shared/models/app_anime.dart';
import '../../../shared/models/sort_direction.dart';
import '../../../shared/services/rate_limited_anilist_client.dart';
import '../domain/models/browse_filters.dart';

final class BrowseAnimeRepository {
  BrowseAnimeRepository({RateLimitedAniListClient? anilist})
    : _anilist = anilist ?? RateLimitedAniListClient.instance;

  final RateLimitedAniListClient _anilist;
  List<String>? _animeGenres;
  List<String>? _animeTags;

  Future<BrowseAnimePage> searchAnime({
    required BrowseFilters filters,
    required BrowseSort sort,
    required SortDirection sortDirection,
    required int page,
  }) async {
    final response = await _anilist.getAnimeSearch(
      q: filters.normalizedQuery,
      format: _format(filters.type),
      status: _status(filters.status),
      averageScoreGreater: _minimumScore(filters.minScore),
      averageScoreLesser: _maximumScore(filters.maxScore),
      startDateGreater: _inclusiveStartDate(filters.startDate),
      startDateLesser: _inclusiveEndDate(filters.endDate),
      genres: _genres(filters.genres),
      genresNotIn: _genres(filters.excludedGenres),
      tags: _tags(filters.tags),
      tagsNotIn: _tags(filters.excludedTags),
      sort: _sort(sort, sortDirection),
      isAdult: filters.sfw ? false : null,
      page: page,
    );

    return BrowseAnimePage(
      items: response.data
          .map(AppAnime.fromAnimeSearchData)
          .where((anime) => _matchesUnsupportedFilters(anime, filters))
          .toList(),
      currentPage: response.pageInfo.currentPage ?? page,
      lastPage: response.pageInfo.lastPage ?? page,
      hasNextPage: response.pageInfo.hasNextPage ?? false,
    );
  }

  Future<List<String>> getAnimeGenres() async {
    final cachedGenres = _animeGenres;
    if (cachedGenres != null) {
      return cachedGenres;
    }

    final genres = await _anilist.getGenres();
    _animeGenres = genres;
    return genres;
  }

  Future<List<String>> getAnimeTags() async {
    final cachedTags = _animeTags;
    if (cachedTags != null) {
      return cachedTags;
    }

    final tags = await _anilist.getMediaTags();
    final names = {
      for (final tag in tags)
        if (tag.isAdult != true && tag.name.trim().isNotEmpty) tag.name,
    }.toList()..sort();
    _animeTags = names;
    return names;
  }

  List<String>? _genres(Set<String> genres) {
    if (genres.isEmpty) {
      return null;
    }

    final values = genres.toList()..sort();
    return values;
  }

  List<String>? _tags(Set<String> tags) {
    if (tags.isEmpty) {
      return null;
    }

    final values = tags.toList()..sort();
    return values;
  }

  MediaFormat? _format(AppAnimeType? type) {
    return switch (type) {
      AppAnimeType.tv => MediaFormat.tv,
      AppAnimeType.movie => MediaFormat.movie,
      AppAnimeType.ova => MediaFormat.ova,
      AppAnimeType.ona => MediaFormat.ona,
      AppAnimeType.special || AppAnimeType.tvSpecial => MediaFormat.special,
      AppAnimeType.music => MediaFormat.music,
      AppAnimeType.cm || AppAnimeType.pv || null => null,
    };
  }

  MediaStatus? _status(AnimeSearchStatus? status) {
    return switch (status) {
      AnimeSearchStatus.airing => MediaStatus.releasing,
      AnimeSearchStatus.complete => MediaStatus.finished,
      AnimeSearchStatus.upcoming => MediaStatus.notYetReleased,
      null => null,
    };
  }

  List<MediaSort> _sort(BrowseSort sort, SortDirection direction) {
    final descending = direction.isDescending;
    return switch (sort) {
      BrowseSort.scoreDesc => [
        descending ? MediaSort.scoreDesc : MediaSort.score,
      ],
      BrowseSort.popularityAsc => [
        descending ? MediaSort.popularityDesc : MediaSort.popularity,
      ],
      BrowseSort.membersDesc => [
        descending ? MediaSort.popularityDesc : MediaSort.popularity,
      ],
      BrowseSort.favoritesDesc => [
        descending ? MediaSort.favouritesDesc : MediaSort.favourites,
      ],
      BrowseSort.titleAsc => [
        descending ? MediaSort.titleRomajiDesc : MediaSort.titleRomaji,
      ],
    };
  }

  bool _matchesUnsupportedFilters(AppAnime anime, BrowseFilters filters) {
    return _matchesRating(anime, filters.rating);
  }

  bool _matchesRating(AppAnime anime, AnimeSearchRating? rating) {
    if (rating == null) {
      return true;
    }

    return anime.rating == rating.label;
  }

  int? _minimumScore(double score) {
    if (score <= 0) {
      return null;
    }

    return (score * 10).round() - 1;
  }

  int? _maximumScore(double score) {
    if (score >= 10) {
      return null;
    }

    return (score * 10).round() + 1;
  }

  int? _inclusiveStartDate(DateTime? date) {
    return date == null
        ? null
        : _fuzzyDateInt(date.subtract(const Duration(days: 1)));
  }

  int? _inclusiveEndDate(DateTime? date) {
    return date == null
        ? null
        : _fuzzyDateInt(date.add(const Duration(days: 1)));
  }

  int _fuzzyDateInt(DateTime date) {
    return date.year * 10000 + date.month * 100 + date.day;
  }
}

final class BrowseAnimePage {
  const BrowseAnimePage({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.hasNextPage,
  });

  final List<AppAnime> items;
  final int currentPage;
  final int lastPage;
  final bool hasNextPage;
}
