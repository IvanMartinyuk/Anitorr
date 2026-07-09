import 'package:jikan_moe/jikan_moe.dart';

import '../../../shared/models/app_anime.dart';
import '../../../shared/services/rate_limited_jikan_client.dart';
import '../domain/models/browse_filters.dart';

final class BrowseAnimeRepository {
  BrowseAnimeRepository({RateLimitedJikanClient? jikan})
    : _jikan = jikan ?? RateLimitedJikanClient.instance;

  final RateLimitedJikanClient _jikan;
  List<AnimeGenreData>? _animeGenres;

  Future<BrowseAnimePage> searchAnime({
    required BrowseFilters filters,
    required BrowseSort sort,
    required int page,
  }) async {
    final response = await _jikan.getAnimeSearch(
      q: filters.normalizedQuery,
      type: filters.type?.apiValue,
      minScore: filters.minScore > 0 ? filters.minScore : null,
      maxScore: filters.maxScore < 10 ? filters.maxScore : null,
      status: filters.status?.apiValue,
      rating: filters.rating?.apiValue,
      sfw: filters.sfw,
      genres: _genreIds(filters.genres),
      genresExclude: _genreIds(filters.excludedGenres),
      orderBy: sort.orderBy,
      sort: sort.sort,
      startDate: _normalizedDate(filters.startDate),
      endDate: _normalizedDate(filters.endDate),
      page: page,
    );

    return BrowseAnimePage(
      items: response.data.map(AppAnime.fromAnimeSearchData).toList(),
      currentPage: response.pagination.currentPage,
      lastPage: response.pagination.lastVisiblePage,
      hasNextPage: response.pagination.hasNextPage,
    );
  }

  Future<List<AnimeGenreData>> getAnimeGenres() async {
    final cachedGenres = _animeGenres;
    if (cachedGenres != null) {
      return cachedGenres;
    }

    final genres = await _jikan.getAnimeGenres();
    _animeGenres = genres;
    return genres;
  }

  String? _genreIds(Set<int> genres) {
    if (genres.isEmpty) {
      return null;
    }

    final values = genres.toList()..sort();
    return values.join(',');
  }

  String? _normalizedDate(String value) {
    final date = value.trim();
    return date.isEmpty ? null : date;
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
