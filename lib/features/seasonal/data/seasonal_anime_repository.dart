import 'package:jikan_moe/jikan_moe.dart';

import '../../../shared/models/anime_api_filters.dart';
import '../../../shared/models/app_anime.dart';
import '../../../shared/services/rate_limited_jikan_client.dart';

final class SeasonalAnimeRepository {
  SeasonalAnimeRepository({RateLimitedJikanClient? jikan})
    : _jikan = jikan ?? RateLimitedJikanClient.instance;

  final RateLimitedJikanClient _jikan;
  final Map<String, _SeasonCache> _seasonCaches = {};
  List<AnimeGenreData>? _animeGenres;

  Future<List<AppAnime>> getCurrentSeasonAnime({
    AppAnimeType? type,
    int page = 1,
  }) {
    final cache = _cacheFor(type);
    final cachedAnime = cache.pages[page];
    if (cachedAnime != null) {
      return Future.value(cachedAnime);
    }

    return _jikan
        .getSeasonNow(filter: type?.apiValue, page: page)
        .then((response) => response.data.map(AppAnime.fromAnimeData).toList())
        .then((anime) {
          cache.pages[page] = anime;
          if (anime.isEmpty) {
            cache.rememberLastPage(page - 1);
          } else if (page > cache.maxContiguousLoadedPage) {
            cache.maxContiguousLoadedPage = _contiguousLoadedPage(cache);
          }
          return anime;
        });
  }

  int? getKnownLastPage({AppAnimeType? type}) {
    return _cacheFor(type).lastPage;
  }

  int getMaxContiguousLoadedPage({AppAnimeType? type}) {
    return _cacheFor(type).maxContiguousLoadedPage;
  }

  bool isVisiblePageCacheStarted({AppAnimeType? type}) {
    return _cacheFor(type).visiblePageCacheStarted;
  }

  void markVisiblePageCacheStarted({AppAnimeType? type}) {
    _cacheFor(type).visiblePageCacheStarted = true;
  }

  bool isFullCacheStarted({AppAnimeType? type}) {
    return _cacheFor(type).fullCacheStarted;
  }

  void markFullCacheStarted({AppAnimeType? type}) {
    _cacheFor(type).fullCacheStarted = true;
  }

  List<AppAnime> getCachedAnime({AppAnimeType? type}) {
    final cache = _cacheFor(type);
    final pages = cache.pages.keys.toList()..sort();

    return [
      for (final page in pages)
        if (cache.pages[page]?.isNotEmpty ?? false) ...cache.pages[page]!,
    ];
  }

  List<AppAnime> getCachedAnimeUpToPage(int page, {AppAnimeType? type}) {
    final cache = _cacheFor(type);
    final normalizedPage = page < 1 ? 1 : page;
    final pages =
        cache.pages.keys
            .where((cachedPage) => cachedPage <= normalizedPage)
            .toList()
          ..sort();

    return [
      for (final cachedPage in pages)
        if (cache.pages[cachedPage]?.isNotEmpty ?? false)
          ...cache.pages[cachedPage]!,
    ];
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

  _SeasonCache _cacheFor(AppAnimeType? type) {
    return _seasonCaches.putIfAbsent(type?.apiValue ?? 'all', _SeasonCache.new);
  }

  int _contiguousLoadedPage(_SeasonCache cache) {
    var page = 1;
    while (cache.pages[page]?.isNotEmpty ?? false) {
      page += 1;
    }

    return page - 1;
  }
}

final class _SeasonCache {
  final Map<int, List<AppAnime>> pages = {};
  int maxContiguousLoadedPage = 0;
  int? lastPage;
  bool visiblePageCacheStarted = false;
  bool fullCacheStarted = false;

  void rememberLastPage(int page) {
    final normalizedPage = page < 1 ? 1 : page;
    if (lastPage == null || normalizedPage < lastPage!) {
      lastPage = normalizedPage;
    }
  }
}
