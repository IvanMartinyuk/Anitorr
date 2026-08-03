enum SeasonalSort {
  apiOrder('API order'),
  titleAsc('Title'),
  scoreDesc('Score'),
  popularityAsc('Popularity'),
  membersDesc('Members');

  const SeasonalSort(this.label);

  final String label;
}

enum ReleaseWeekday {
  monday(DateTime.monday, 'Monday'),
  tuesday(DateTime.tuesday, 'Tuesday'),
  wednesday(DateTime.wednesday, 'Wednesday'),
  thursday(DateTime.thursday, 'Thursday'),
  friday(DateTime.friday, 'Friday'),
  saturday(DateTime.saturday, 'Saturday'),
  sunday(DateTime.sunday, 'Sunday');

  const ReleaseWeekday(this.dateTimeValue, this.label);

  final int dateTimeValue;
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
    required this.releaseWeekdays,
  });

  factory SeasonalFilters.empty() {
    return const SeasonalFilters(
      query: '',
      airing: null,
      minScore: 0,
      maxScore: 10,
      genres: {},
      tags: {},
      releaseWeekdays: {},
    );
  }

  final String query;
  final bool? airing;
  final double minScore;
  final double maxScore;
  final Set<String> genres;
  final Set<String> tags;
  final Set<ReleaseWeekday> releaseWeekdays;

  bool get hasActiveCachedFilters {
    return query.trim().isNotEmpty ||
        airing != null ||
        minScore > 0 ||
        maxScore < 10 ||
        genres.isNotEmpty ||
        tags.isNotEmpty ||
        releaseWeekdays.isNotEmpty;
  }

  SeasonalFilters copyWith({
    String? query,
    bool? airing,
    bool clearAiring = false,
    double? minScore,
    double? maxScore,
    Set<String>? genres,
    Set<String>? tags,
    Set<ReleaseWeekday>? releaseWeekdays,
  }) {
    return SeasonalFilters(
      query: query ?? this.query,
      airing: clearAiring ? null : airing ?? this.airing,
      minScore: minScore ?? this.minScore,
      maxScore: maxScore ?? this.maxScore,
      genres: genres ?? this.genres,
      tags: tags ?? this.tags,
      releaseWeekdays: releaseWeekdays ?? this.releaseWeekdays,
    );
  }
}
