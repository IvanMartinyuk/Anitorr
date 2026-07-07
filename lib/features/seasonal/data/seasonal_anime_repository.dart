import 'package:jikan_api/jikan_api.dart';

final class SeasonalAnimeRepository {
  SeasonalAnimeRepository({Jikan? jikan}) : _jikan = jikan ?? Jikan();

  final Jikan _jikan;
  final Map<String, List<Anime>> _seasonCache = {};

  Future<List<Anime>> getCurrentSeasonAnime({AnimeType? type, int page = 1}) {
    final cacheKey = '${type?.name ?? 'all'}:$page';
    final cachedAnime = _seasonCache[cacheKey];
    if (cachedAnime != null) {
      return Future.value(cachedAnime);
    }

    return _jikan.getSeason(type: type, page: page).then((anime) {
      _seasonCache[cacheKey] = anime;
      return anime;
    });
  }
}
