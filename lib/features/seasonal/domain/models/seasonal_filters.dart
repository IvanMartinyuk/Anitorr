enum SeasonalSort {
  apiOrder('API order'),
  titleAsc('Title'),
  scoreDesc('Score'),
  popularityAsc('Popularity'),
  membersDesc('Members');

  const SeasonalSort(this.label);

  final String label;
}

final class SeasonalFilters {
  const SeasonalFilters({
    required this.query,
    required this.airing,
    required this.minScore,
    required this.maxScore,
    required this.genres,
    required this.tags,
  });

  factory SeasonalFilters.empty() {
    return const SeasonalFilters(
      query: '',
      airing: null,
      minScore: 0,
      maxScore: 10,
      genres: {},
      tags: {},
    );
  }

  final String query;
  final bool? airing;
  final double minScore;
  final double maxScore;
  final Set<String> genres;
  final Set<String> tags;

  bool get hasActiveCachedFilters {
    return query.trim().isNotEmpty ||
        airing != null ||
        minScore > 0 ||
        maxScore < 10 ||
        genres.isNotEmpty ||
        tags.isNotEmpty;
  }

  SeasonalFilters copyWith({
    String? query,
    bool? airing,
    bool clearAiring = false,
    double? minScore,
    double? maxScore,
    Set<String>? genres,
    Set<String>? tags,
  }) {
    return SeasonalFilters(
      query: query ?? this.query,
      airing: clearAiring ? null : airing ?? this.airing,
      minScore: minScore ?? this.minScore,
      maxScore: maxScore ?? this.maxScore,
      genres: genres ?? this.genres,
      tags: tags ?? this.tags,
    );
  }
}
