import 'package:anilist_api/anilist_api.dart';
import 'package:anitorr/features/seasonal/domain/models/seasonal_filters.dart';
import 'package:anitorr/features/seasonal/domain/services/seasonal_anime_filtering.dart';
import 'package:anitorr/shared/models/anime_api_filters.dart';
import 'package:anitorr/shared/models/app_anime.dart';
import 'package:anitorr/shared/models/sort_direction.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps an externally loaded airing schedule onto an anime', () {
    final airingAt = DateTime(2026, 8, 4, 18).millisecondsSinceEpoch ~/ 1000;
    final anime = AppAnime.fromAnimeData(
      const AnimeData(id: 42),
      nextAiringEpisode: AiringScheduleData(
        id: 1,
        airingAt: airingAt,
        timeUntilAiring: 3600,
        episode: 6,
        mediaId: 42,
      ),
    );

    expect(anime.nextAiringAt, DateTime(2026, 8, 4, 18));
    expect(anime.nextAiringEpisodeNumber, 6);
    expect(anime.nextAiringEpisode, 'Episode 6 in 1h');
  });

  group('filterSeasonalAnime', () {
    test('matches title aliases, type, score, airing, genres, and tags', () {
      final actionTv = _anime(
        title: 'Original',
        englishTitle: 'Hero Show',
        synonyms: ['Masked Legend'],
        type: 'TV',
        score: 8.2,
        airing: true,
        genres: ['Action', 'Adventure'],
        tags: ['Time Manipulation'],
        nextAiringAt: DateTime(2026, 8, 3, 18),
      );
      final romanceMovie = _anime(
        title: 'Quiet Film',
        type: 'Movie',
        score: 7.1,
        airing: false,
        genres: ['Romance'],
      );

      final result = filterSeasonalAnime(
        [actionTv, romanceMovie],
        typeFilter: AppAnimeType.tv,
        filters: SeasonalFilters.empty().copyWith(
          query: 'masked',
          airing: true,
          minScore: 8,
          genres: {'Action'},
          tags: {'Time Manipulation'},
          releaseWeekdays: {ReleaseWeekday.monday},
        ),
      );

      expect(result, [actionTv]);
    });

    test('matches selected release weekdays using the next airing date', () {
      final monday = _anime(
        title: 'Monday Show',
        nextAiringAt: DateTime(2026, 8, 3, 18),
      );
      final tuesday = _anime(
        title: 'Tuesday Show',
        nextAiringAt: DateTime(2026, 8, 4, 18),
      );
      final unscheduled = _anime(title: 'Unscheduled Show');

      final result = filterSeasonalAnime(
        [monday, tuesday, unscheduled],
        filters: SeasonalFilters.empty().copyWith(
          releaseWeekdays: {ReleaseWeekday.monday},
        ),
      );

      expect(result, [monday]);
    });

    test('normalizes API type labels before comparing them', () {
      final special = _anime(title: 'Special', type: 'TV Special');

      expect(matchesSeasonalAnimeType(special, AppAnimeType.tvSpecial), isTrue);
    });
  });

  group('prepareSeasonalAnime', () {
    test('deduplicates by preferred title before sorting', () {
      final first = _anime(
        title: 'Japanese A',
        englishTitle: 'Shared Title',
        score: 7,
      );
      final duplicate = _anime(
        title: 'Japanese B',
        englishTitle: 'Shared Title',
        score: 9,
      );
      final other = _anime(title: 'Another Title', score: 8);

      final result = prepareSeasonalAnime(
        anime: [first, duplicate, other],
        filters: SeasonalFilters.empty(),
        sort: SeasonalSort.scoreDesc,
        sortDirection: SortDirection.descending,
      );

      expect(result, [other, first]);
    });
  });
}

AppAnime _anime({
  required String title,
  String? englishTitle,
  List<String> synonyms = const [],
  String? type,
  double? score,
  int? popularity,
  int? members,
  bool airing = true,
  List<String> genres = const [],
  List<String> tags = const [],
  DateTime? nextAiringAt,
}) {
  return AppAnime(
    id: title.hashCode,
    url: 'https://example.test/$title',
    imageUrl: 'https://example.test/$title.jpg',
    title: title,
    titleEnglish: englishTitle,
    titleSynonyms: synonyms,
    type: type,
    score: score,
    popularity: popularity,
    members: members,
    airing: airing,
    nextAiringAt: nextAiringAt,
    genres: [
      for (final genre in genres)
        AppAnimeMeta(
          id: genre.hashCode,
          type: 'anime',
          name: genre,
          url: 'https://example.test/genres/$genre',
        ),
    ],
    tags: [
      for (final tag in tags)
        AppAnimeTag(id: tag.hashCode, name: tag, category: 'Theme', rank: 80),
    ],
    rankings: const [],
    externalLinks: const [],
    streamingEpisodes: const [],
    relations: const [],
  );
}
