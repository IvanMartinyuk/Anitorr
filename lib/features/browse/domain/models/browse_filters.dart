import '../../../../shared/models/anime_api_filters.dart';

enum BrowseSort {
  scoreDesc('Top rated', 'score', 'desc'),
  popularityAsc('Most popular', 'popularity', 'asc'),
  membersDesc('Most members', 'members', 'desc'),
  favoritesDesc('Most favorites', 'favorites', 'desc'),
  titleAsc('Title', 'title', 'asc');

  const BrowseSort(this.label, this.orderBy, this.sort);

  final String label;
  final String orderBy;
  final String sort;
}

final class BrowseFilters {
  const BrowseFilters({
    required this.query,
    required this.type,
    required this.status,
    required this.rating,
    required this.sfw,
    required this.minScore,
    required this.maxScore,
    required this.genres,
    required this.excludedGenres,
    required this.startDate,
    required this.endDate,
  });

  factory BrowseFilters.empty() {
    return const BrowseFilters(
      query: '',
      type: null,
      status: null,
      rating: null,
      sfw: true,
      minScore: 0,
      maxScore: 10,
      genres: {},
      excludedGenres: {},
      startDate: '',
      endDate: '',
    );
  }

  final String query;
  final AppAnimeType? type;
  final AnimeSearchStatus? status;
  final AnimeSearchRating? rating;
  final bool sfw;
  final double minScore;
  final double maxScore;
  final Set<int> genres;
  final Set<int> excludedGenres;
  final String startDate;
  final String endDate;

  String? get normalizedQuery {
    final value = query.trim();
    return value.isEmpty ? null : value;
  }

  bool get hasActiveFilters {
    return normalizedQuery != null ||
        type != null ||
        status != null ||
        rating != null ||
        !sfw ||
        minScore > 0 ||
        maxScore < 10 ||
        genres.isNotEmpty ||
        excludedGenres.isNotEmpty ||
        startDate.trim().isNotEmpty ||
        endDate.trim().isNotEmpty;
  }

  BrowseFilters copyWith({
    String? query,
    AppAnimeType? type,
    bool clearType = false,
    AnimeSearchStatus? status,
    bool clearStatus = false,
    AnimeSearchRating? rating,
    bool clearRating = false,
    bool? sfw,
    double? minScore,
    double? maxScore,
    Set<int>? genres,
    Set<int>? excludedGenres,
    String? startDate,
    String? endDate,
  }) {
    return BrowseFilters(
      query: query ?? this.query,
      type: clearType ? null : type ?? this.type,
      status: clearStatus ? null : status ?? this.status,
      rating: clearRating ? null : rating ?? this.rating,
      sfw: sfw ?? this.sfw,
      minScore: minScore ?? this.minScore,
      maxScore: maxScore ?? this.maxScore,
      genres: genres ?? this.genres,
      excludedGenres: excludedGenres ?? this.excludedGenres,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }
}
