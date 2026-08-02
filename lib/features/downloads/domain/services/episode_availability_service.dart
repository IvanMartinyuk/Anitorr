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
    int? aniListLatest;
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
        aniListLatest = _clamp(response.data.first.episode, anime.episodes);
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
      final latest = latestNyaaEpisode(
        anime,
        page.items.map((torrent) => torrent.name),
      );
      final nyaaLatest = _clamp(latest, anime.episodes);
      if (nyaaLatest > 0 && aniListLatest != null && aniListLatest > 0) {
        return nyaaLatest < aniListLatest ? nyaaLatest : aniListLatest;
      }
      if (nyaaLatest > 0) return nyaaLatest;
    } catch (_) {
      // Fall through to AniList or the known completed episode count.
    }
    if (aniListLatest != null) return aniListLatest;
    if (!anime.airing && anime.episodes != null) return anime.episodes!;
    return 0;
  }

  int _clamp(int value, int? total) {
    if (value < 0) return 0;
    if (total != null && value > total) return total;
    return value;
  }

  static int latestNyaaEpisode(AppAnime anime, Iterable<String> names) {
    final targetSeason = _seasonFromText(anime.titleEnglish ?? anime.title);
    var latest = 0;
    for (final name in names) {
      final parsed = TorrentTitleParser.parse(name);
      final releaseSeason = parsed.season ?? _seasonFromText(parsed.animeName);
      if (releaseSeason != targetSeason) continue;
      for (final episode in parsed.episodes) {
        if (episode > latest) latest = episode;
      }
    }
    return latest;
  }

  static int _seasonFromText(String value) {
    final numeric = RegExp(
      r'\b(?:season\s*|s)(\d{1,2})\b',
      caseSensitive: false,
    ).firstMatch(value);
    if (numeric != null) return int.parse(numeric.group(1)!);
    final ordinal = RegExp(
      r'\b(\d{1,2})(?:st|nd|rd|th)\s+season\b',
      caseSensitive: false,
    ).firstMatch(value);
    if (ordinal != null) return int.parse(ordinal.group(1)!);
    final roman = RegExp(
      r'\b(V|IV|III|II)\b',
      caseSensitive: false,
    ).allMatches(value).toList();
    if (roman.isEmpty) return 1;
    return switch (roman.last.group(1)!.toUpperCase()) {
      'II' => 2,
      'III' => 3,
      'IV' => 4,
      'V' => 5,
      _ => 1,
    };
  }
}
