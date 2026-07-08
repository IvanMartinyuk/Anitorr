import 'package:jikan_api/jikan_api.dart';

final class AnimeDetailsRepository {
  AnimeDetailsRepository({Jikan? jikan}) : _jikan = jikan ?? Jikan();

  final Jikan _jikan;
  final Map<int, Anime> _cache = {};

  Future<Anime> getAnime(int id) async {
    final cachedAnime = _cache[id];
    if (cachedAnime != null) {
      return cachedAnime;
    }

    final anime = await _jikan.getAnime(id);
    _cache[id] = anime;
    return anime;
  }
}
