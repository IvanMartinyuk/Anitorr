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
    required this.tags,
    required this.excludedTags,
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
      tags: {},
      excludedTags: {},
      startDate: null,
      endDate: null,
    );
  }

  final String query;
  final AppAnimeType? type;
  final AnimeSearchStatus? status;
  final AnimeSearchRating? rating;
  final bool sfw;
  final double minScore;
  final double maxScore;
  final Set<String> genres;
  final Set<String> excludedGenres;
  final Set<String> tags;
  final Set<String> excludedTags;
  final DateTime? startDate;
  final DateTime? endDate;

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
        tags.isNotEmpty ||
        excludedTags.isNotEmpty ||
        startDate != null ||
        endDate != null;
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
    Set<String>? genres,
    Set<String>? excludedGenres,
    Set<String>? tags,
    Set<String>? excludedTags,
    DateTime? startDate,
    bool clearStartDate = false,
    DateTime? endDate,
    bool clearEndDate = false,
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
      tags: tags ?? this.tags,
      excludedTags: excludedTags ?? this.excludedTags,
      startDate: clearStartDate ? null : startDate ?? this.startDate,
      endDate: clearEndDate ? null : endDate ?? this.endDate,
    );
  }
}
