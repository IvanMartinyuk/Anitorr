import '../../../shared/models/app_anime.dart';
import '../../../shared/services/rate_limited_anilist_client.dart';

final class AnimeDetailsRepository {
  AnimeDetailsRepository({RateLimitedAniListClient? anilist})
    : _anilist = anilist ?? RateLimitedAniListClient.instance;

  final RateLimitedAniListClient _anilist;
  final Map<int, AppAnime> _cache = {};

  Future<AppAnime> getAnime(int id) async {
    final cachedAnime = _cache[id];
    if (cachedAnime != null) {
      return cachedAnime;
    }

    final anime = AppAnime.fromAnimeFullData(
      await _anilist.getAnimeFullById(id),
    );
    _cache[id] = anime;
    return anime;
  }
}
