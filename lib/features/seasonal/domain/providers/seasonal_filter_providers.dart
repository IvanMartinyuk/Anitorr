import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/anime_api_filters.dart';
import '../models/seasonal_filters.dart';
import 'seasonal_pagination_providers.dart';

final seasonalTypeFilterProvider =
    NotifierProvider<SeasonalTypeFilterNotifier, AppAnimeType?>(
      SeasonalTypeFilterNotifier.new,
    );

final seasonalSortProvider =
    NotifierProvider<SeasonalSortNotifier, SeasonalSort>(
      SeasonalSortNotifier.new,
    );

final seasonalFiltersProvider =
    NotifierProvider<SeasonalFiltersNotifier, SeasonalFilters>(
      SeasonalFiltersNotifier.new,
    );

class SeasonalTypeFilterNotifier extends Notifier<AppAnimeType?> {
  @override
  AppAnimeType? build() {
    return null;
  }

  void setType(AppAnimeType? type) {
    state = type;
  }
}

class SeasonalSortNotifier extends Notifier<SeasonalSort> {
  @override
  SeasonalSort build() {
    return SeasonalSort.apiOrder;
  }

  void setSort(SeasonalSort sort) {
    state = sort;
  }
}

class SeasonalFiltersNotifier extends Notifier<SeasonalFilters> {
  @override
  SeasonalFilters build() {
    return SeasonalFilters.empty();
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
    ref.read(seasonalPageProvider.notifier).reset();
  }

  void setAiring(bool? airing) {
    state = state.copyWith(airing: airing, clearAiring: airing == null);
    ref.read(seasonalPageProvider.notifier).reset();
  }

  void toggleRating(AnimeContentRating rating) {
    final ratings = Set<AnimeContentRating>.of(state.ratings);
    if (!ratings.add(rating)) {
      ratings.remove(rating);
    }

    state = state.copyWith(ratings: ratings);
    ref.read(seasonalPageProvider.notifier).reset();
  }

  void setScoreRange(double minScore, double maxScore) {
    state = state.copyWith(minScore: minScore, maxScore: maxScore);
    ref.read(seasonalPageProvider.notifier).reset();
  }

  void toggleGenre(String genre) {
    final genres = Set<String>.of(state.genres);
    if (!genres.add(genre)) {
      genres.remove(genre);
    }

    state = state.copyWith(genres: genres);
    ref.read(seasonalPageProvider.notifier).reset();
  }

  void clear() {
    state = SeasonalFilters.empty();
    ref.read(seasonalPageProvider.notifier).reset();
  }
}
