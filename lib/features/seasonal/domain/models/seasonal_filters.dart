enum SeasonalSort {
  apiOrder('Jikan order'),
  titleAsc('Title'),
  scoreDesc('Rating'),
  popularityAsc('Popularity'),
  membersDesc('Members');

  const SeasonalSort(this.label);

  final String label;
}

enum AnimeContentRating {
  g('G - All Ages'),
  pg('PG - Children'),
  pg13('PG-13 - Teens 13 or older'),
  r17('R - 17+ (violence & profanity)'),
  rPlus('R+ - Mild Nudity'),
  rx('Rx - Hentai');

  const AnimeContentRating(this.label);

  final String label;
}

final class SeasonalFilters {
  const SeasonalFilters({
    required this.query,
    required this.ratings,
    required this.airing,
    required this.minScore,
    required this.maxScore,
    required this.genres,
  });

  factory SeasonalFilters.empty() {
    return const SeasonalFilters(
      query: '',
      ratings: {},
      airing: null,
      minScore: 0,
      maxScore: 10,
      genres: {},
    );
  }

  final String query;
  final Set<AnimeContentRating> ratings;
  final bool? airing;
  final double minScore;
  final double maxScore;
  final Set<String> genres;

  bool get hasActiveCachedFilters {
    return query.trim().isNotEmpty ||
        ratings.isNotEmpty ||
        airing != null ||
        minScore > 0 ||
        maxScore < 10 ||
        genres.isNotEmpty;
  }

  SeasonalFilters copyWith({
    String? query,
    Set<AnimeContentRating>? ratings,
    bool? airing,
    bool clearAiring = false,
    double? minScore,
    double? maxScore,
    Set<String>? genres,
  }) {
    return SeasonalFilters(
      query: query ?? this.query,
      ratings: ratings ?? this.ratings,
      airing: clearAiring ? null : airing ?? this.airing,
      minScore: minScore ?? this.minScore,
      maxScore: maxScore ?? this.maxScore,
      genres: genres ?? this.genres,
    );
  }
}
