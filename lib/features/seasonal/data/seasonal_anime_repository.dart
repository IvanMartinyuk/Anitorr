import 'package:jikan_api/jikan_api.dart';

final class SeasonalAnimeRepository {
  SeasonalAnimeRepository({Jikan? jikan}) : _jikan = jikan ?? Jikan();

  final Jikan _jikan;
  final Map<String, _SeasonCache> _seasonCaches = {};

  Future<List<Anime>> getCurrentSeasonAnime({AnimeType? type, int page = 1}) {
    final cache = _cacheFor(type);
    final cachedAnime = cache.pages[page];
    if (cachedAnime != null) {
      return Future.value(cachedAnime);
    }

    return _jikan.getSeason(type: type, page: page).then((anime) {
      cache.pages[page] = anime;
      if (anime.isEmpty) {
        cache.rememberLastPage(page - 1);
      } else if (page > cache.maxContiguousLoadedPage) {
        cache.maxContiguousLoadedPage = _contiguousLoadedPage(cache);
      }
      return anime;
    });
  }

  int? getKnownLastPage({AnimeType? type}) {
    return _cacheFor(type).lastPage;
  }

  int getMaxContiguousLoadedPage({AnimeType? type}) {
    return _cacheFor(type).maxContiguousLoadedPage;
  }

  bool isVisiblePageCacheStarted({AnimeType? type}) {
    return _cacheFor(type).visiblePageCacheStarted;
  }

  void markVisiblePageCacheStarted({AnimeType? type}) {
    _cacheFor(type).visiblePageCacheStarted = true;
  }

  bool isFullCacheStarted({AnimeType? type}) {
    return _cacheFor(type).fullCacheStarted;
  }

  void markFullCacheStarted({AnimeType? type}) {
    _cacheFor(type).fullCacheStarted = true;
  }

  List<Anime> getCachedAnime({AnimeType? type}) {
    final cache = _cacheFor(type);
    final pages = cache.pages.keys.toList()..sort();

    return [
      for (final page in pages)
        if (cache.pages[page]?.isNotEmpty ?? false) ...cache.pages[page]!,
    ];
  }

  _SeasonCache _cacheFor(AnimeType? type) {
    return _seasonCaches.putIfAbsent(type?.name ?? 'all', _SeasonCache.new);
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
  final Map<int, List<Anime>> pages = {};
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
