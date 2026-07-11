import 'package:anilist_api/anilist_api.dart';

import '../../../shared/models/anime_api_filters.dart';
import '../../../shared/models/app_anime.dart';
import '../../../shared/services/rate_limited_anilist_client.dart';

final class SeasonalAnimeRepository {
  SeasonalAnimeRepository({RateLimitedAniListClient? anilist})
    : _anilist = anilist ?? RateLimitedAniListClient.instance;

  final RateLimitedAniListClient _anilist;
  final Map<String, _SeasonCache> _seasonCaches = {};
  List<String>? _animeGenres;
  List<String>? _animeTags;

  Future<List<AppAnime>> getCurrentSeasonAnime({
    AppAnimeType? type,
    int page = 1,
  }) {
    final cache = _cacheFor(type);
    final cachedAnime = cache.pages[page];
    if (cachedAnime != null) {
      return Future.value(cachedAnime);
    }

    return _anilist
        .getSeasonNow(format: _format(type), page: page)
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
