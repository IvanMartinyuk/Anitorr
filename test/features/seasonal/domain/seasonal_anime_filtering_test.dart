import 'package:anitorr/features/seasonal/domain/models/seasonal_filters.dart';
import 'package:anitorr/features/seasonal/domain/services/seasonal_anime_filtering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jikan_api/jikan_api.dart';

void main() {
  group('filterSeasonalAnime', () {
    test('matches title aliases, type, rating, score, airing, and genres', () {
      final actionTv = _anime(
        title: 'Original',
        englishTitle: 'Hero Show',
        synonyms: ['Masked Legend'],
        type: 'TV',
        rating: AnimeContentRating.pg13.label,
        score: 8.2,
        airing: true,
        genres: ['Action', 'Adventure'],
      );
      final romanceMovie = _anime(
        title: 'Quiet Film',
        type: 'Movie',
        rating: AnimeContentRating.pg.label,
        score: 7.1,
        airing: false,
        genres: ['Romance'],
      );

      final result = filterSeasonalAnime(
        [actionTv, romanceMovie],
        typeFilter: AnimeType.tv,
        filters: SeasonalFilters.empty().copyWith(
          query: 'masked',
          ratings: {AnimeContentRating.pg13},
          airing: true,
          minScore: 8,
          genres: {'Action'},
        ),
      );

      expect(result, [actionTv]);
    });

    test('normalizes API type labels before comparing them', () {
      final special = _anime(title: 'Special', type: 'TV Special');

      expect(matchesSeasonalAnimeType(special, AnimeType.tv_special), isTrue);
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
      );

      expect(result, [other, first]);
    });
  });
}

Anime _anime({
  required String title,
  String? englishTitle,
  List<String> synonyms = const [],
  String? type,
  String? rating,
  double? score,
  int? popularity,
  int? members,
  bool airing = true,
  List<String> genres = const [],
}) {
  return Anime(
    (builder) => builder
      ..malId = title.hashCode
      ..url = 'https://example.test/$title'
      ..imageUrl = 'https://example.test/$title.jpg'
      ..title = title
      ..titleEnglish = englishTitle
      ..titleSynonyms.addAll(synonyms)
      ..type = type
      ..rating = rating
      ..score = score
      ..popularity = popularity
      ..members = members
      ..airing = airing
      ..genres.addAll([
        for (final genre in genres)
          Meta(
            (builder) => builder
              ..malId = genre.hashCode
              ..type = 'anime'
              ..name = genre
              ..url = 'https://example.test/genres/$genre',
          ),
      ])
      ..producers
      ..licensors
      ..studios
      ..explicitGenres
      ..themes
      ..demographics,
  );
}
