import 'package:anilist_api/anilist_api.dart';
import 'package:nyaa/nyaa.dart';

import '../../../../shared/models/app_anime.dart';
import '../../../../shared/services/rate_limited_anilist_client.dart';

final class EpisodeAvailabilityService {
  const EpisodeAvailabilityService({
    required RateLimitedAniListClient aniListClient,
    required NyaaClient nyaaClient,
  }) : _aniListClient = aniListClient,
       _nyaaClient = nyaaClient;

  final RateLimitedAniListClient _aniListClient;
  final NyaaClient _nyaaClient;

  Future<int> availableEpisodes(AppAnime anime) async {
    if (!anime.airing && anime.episodes != null) return anime.episodes!;

    try {
      final now = DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;
      final response = await _aniListClient.execute(
        (client) => client.getAiringSchedule(
          mediaId: anime.id,
          airingAtLesser: now + 1,
          sort: const [AiringSort.episodeDesc],
          perPage: 1,
        ),
      );
      if (response.data.isNotEmpty) {
        return _clamp(response.data.first.episode, anime.episodes);
      }
    } catch (_) {
      // Nyaa is the fallback when AniList has no usable airing schedule.
    }

    try {
      final page = await _nyaaClient.search(
        NyaaSearchRequest(
          query: anime.titleEnglish ?? anime.title,
          category: NyaaCategory.animeEnglishTranslated,
        ),
      );
      var latest = 0;
      for (final torrent in page.items) {
        final parsed = TorrentTitleParser.parse(torrent.name);
        for (final episode in parsed.episodes) {
          if (episode > latest) latest = episode;
        }
      }
      return _clamp(latest, anime.episodes);
    } catch (_) {
      return 0;
    }
  }

  int _clamp(int value, int? total) {
    if (value < 0) return 0;
    if (total != null && value > total) return total;
    return value;
  }
}
