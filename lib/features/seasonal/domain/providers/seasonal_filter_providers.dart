import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/anime_api_filters.dart';
import '../../../../shared/models/sort_direction.dart';
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

final seasonalSortDirectionProvider =
    NotifierProvider<SeasonalSortDirectionNotifier, SortDirection>(
      SeasonalSortDirectionNotifier.new,
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

class SeasonalSortDirectionNotifier extends Notifier<SortDirection> {
  @override
  SortDirection build() {
    return SortDirection.descending;
  }

  void toggle() {
    state = state.toggled;
    ref.read(seasonalPageProvider.notifier).reset();
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

  void toggleTag(String tag) {
    final tags = Set<String>.of(state.tags);
    if (!tags.add(tag)) {
      tags.remove(tag);
    }

    state = state.copyWith(tags: tags);
    ref.read(seasonalPageProvider.notifier).reset();
  }

  void toggleReleaseWeekday(ReleaseWeekday weekday) {
    final releaseWeekdays = Set<ReleaseWeekday>.of(state.releaseWeekdays);
    if (!releaseWeekdays.add(weekday)) {
      releaseWeekdays.remove(weekday);
    }

    state = state.copyWith(releaseWeekdays: releaseWeekdays);
    ref.read(seasonalPageProvider.notifier).reset();
  }

  void clear() {
    state = SeasonalFilters.empty();
    ref.read(seasonalPageProvider.notifier).reset();
  }
}
