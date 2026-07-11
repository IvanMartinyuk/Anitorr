import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/anime_api_filters.dart';
import '../../../../shared/models/sort_direction.dart';
import '../models/browse_filters.dart';
import 'browse_pagination_providers.dart';

final browseFiltersProvider =
    NotifierProvider<BrowseFiltersNotifier, BrowseFilters>(
      BrowseFiltersNotifier.new,
    );

final browseSortProvider = NotifierProvider<BrowseSortNotifier, BrowseSort>(
  BrowseSortNotifier.new,
);

final browseSortDirectionProvider =
    NotifierProvider<BrowseSortDirectionNotifier, SortDirection>(
      BrowseSortDirectionNotifier.new,
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

  void toggleGenre(String genre) {
    final genres = Set<String>.of(state.genres);
    if (!genres.add(genre)) {
      genres.remove(genre);
    }

    final excludedGenres = Set<String>.of(state.excludedGenres)..remove(genre);
    state = state.copyWith(genres: genres, excludedGenres: excludedGenres);
    _resetPagination();
  }

  void toggleExcludedGenre(String genre) {
    final excludedGenres = Set<String>.of(state.excludedGenres);
    if (!excludedGenres.add(genre)) {
      excludedGenres.remove(genre);
    }

    final genres = Set<String>.of(state.genres)..remove(genre);
    state = state.copyWith(genres: genres, excludedGenres: excludedGenres);
    _resetPagination();
  }

  void toggleTag(String tag) {
    final tags = Set<String>.of(state.tags);
    if (!tags.add(tag)) {
      tags.remove(tag);
    }

    final excludedTags = Set<String>.of(state.excludedTags)..remove(tag);
    state = state.copyWith(tags: tags, excludedTags: excludedTags);
    _resetPagination();
  }

  void toggleExcludedTag(String tag) {
    final excludedTags = Set<String>.of(state.excludedTags);
    if (!excludedTags.add(tag)) {
      excludedTags.remove(tag);
    }

    final tags = Set<String>.of(state.tags)..remove(tag);
    state = state.copyWith(tags: tags, excludedTags: excludedTags);
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

class BrowseSortDirectionNotifier extends Notifier<SortDirection> {
  @override
  SortDirection build() {
    return SortDirection.descending;
  }

  void toggle() {
    state = state.toggled;
    ref.read(browseLastPageProvider.notifier).reset();
    ref.read(browseMaxLoadedPageProvider.notifier).reset();
    ref.read(browsePageProvider.notifier).reset();
  }
}
