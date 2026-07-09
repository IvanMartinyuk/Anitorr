import '../../../shared/models/app_anime.dart';
import '../../../shared/services/rate_limited_jikan_client.dart';

final class AnimeDetailsRepository {
  AnimeDetailsRepository({RateLimitedJikanClient? jikan})
    : _jikan = jikan ?? RateLimitedJikanClient.instance;

  final RateLimitedJikanClient _jikan;
  final Map<int, AppAnime> _cache = {};

  Future<AppAnime> getAnime(int id) async {
    final cachedAnime = _cache[id];
    if (cachedAnime != null) {
      return cachedAnime;
    }

    final anime = AppAnime.fromAnimeFullData(await _jikan.getAnimeFullById(id));
    _cache[id] = anime;
    return anime;
  }
}
