import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/anime_api_filters.dart';
import '../models/browse_filters.dart';
import 'browse_pagination_providers.dart';

final browseFiltersProvider =
    NotifierProvider<BrowseFiltersNotifier, BrowseFilters>(
      BrowseFiltersNotifier.new,
    );

final browseSortProvider = NotifierProvider<BrowseSortNotifier, BrowseSort>(
  BrowseSortNotifier.new,
);

class BrowseFiltersNotifier extends Notifier<BrowseFilters> {
  @override
  BrowseFilters build() {
    return BrowseFilters.empty();
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
    _resetPagination();
  }

  void setType(AppAnimeType? type) {
    state = state.copyWith(type: type, clearType: type == null);
    _resetPagination();
  }

  void setStatus(AnimeSearchStatus? status) {
    state = state.copyWith(status: status, clearStatus: status == null);
    _resetPagination();
  }

  void setRating(AnimeSearchRating? rating) {
    state = state.copyWith(rating: rating, clearRating: rating == null);
    _resetPagination();
  }

  void setSfw(bool sfw) {
    state = state.copyWith(sfw: sfw);
    _resetPagination();
  }

  void setScoreRange(double minScore, double maxScore) {
    state = state.copyWith(minScore: minScore, maxScore: maxScore);
    _resetPagination();
  }

  void toggleGenre(int genreId) {
    final genres = Set<int>.of(state.genres);
    if (!genres.add(genreId)) {
      genres.remove(genreId);
    }

    final excludedGenres = Set<int>.of(state.excludedGenres)..remove(genreId);
    state = state.copyWith(genres: genres, excludedGenres: excludedGenres);
    _resetPagination();
  }

  void toggleExcludedGenre(int genreId) {
    final excludedGenres = Set<int>.of(state.excludedGenres);
    if (!excludedGenres.add(genreId)) {
      excludedGenres.remove(genreId);
    }

    final genres = Set<int>.of(state.genres)..remove(genreId);
    state = state.copyWith(genres: genres, excludedGenres: excludedGenres);
    _resetPagination();
  }

  void setStartDate(String startDate) {
    state = state.copyWith(startDate: startDate);
    _resetPagination();
  }

  void setEndDate(String endDate) {
    state = state.copyWith(endDate: endDate);
    _resetPagination();
  }

  void clear() {
    state = BrowseFilters.empty();
    _resetPagination();
  }

  void _resetPagination() {
    ref.read(browseLastPageProvider.notifier).reset();
    ref.read(browseMaxLoadedPageProvider.notifier).reset();
    ref.read(browsePageProvider.notifier).reset();
  }
}

class BrowseSortNotifier extends Notifier<BrowseSort> {
  @override
  BrowseSort build() {
    return BrowseSort.scoreDesc;
  }

  void setSort(BrowseSort sort) {
    state = sort;
    ref.read(browseLastPageProvider.notifier).reset();
    ref.read(browseMaxLoadedPageProvider.notifier).reset();
    ref.read(browsePageProvider.notifier).reset();
  }
}
