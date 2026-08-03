import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/anime_api_filters.dart';
import '../../../../shared/widgets/filters/filters.dart';
import '../../domain/models/seasonal_filters.dart';
import '../../domain/seasonal_anime_providers.dart';

class SeasonalFilterPanel extends ConsumerStatefulWidget {
  const SeasonalFilterPanel({super.key});

  @override
  ConsumerState<SeasonalFilterPanel> createState() =>
      _SeasonalFilterPanelState();
}

class _SeasonalFilterPanelState extends ConsumerState<SeasonalFilterPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final type = ref.watch(seasonalTypeFilterProvider);
    final sort = ref.watch(seasonalSortProvider);
    final sortDirection = ref.watch(seasonalSortDirectionProvider);
    final filters = ref.watch(seasonalFiltersProvider);
    final genres = ref
        .watch(seasonalAvailableGenresProvider)
        .maybeWhen(data: (items) => items, orElse: () => const <String>[]);
    final tags = ref
        .watch(seasonalAvailableTagsProvider)
        .maybeWhen(data: (items) => items, orElse: () => const <String>[]);
    final header = FilterBar<SeasonalSort>(
      expanded: _expanded,
      searchLabel: 'Title',
      searchValue: filters.query,
      searchHintText: 'English, Japanese, synonym',
      sortValue: sort,
      sortDirection: sortDirection,
      sortOptions: [
        for (final option in SeasonalSort.values)
          FilterSortOption(value: option, label: option.label),
      ],
      activeFilterCount: _activeAdvancedFilterCount(
        type: type,
        filters: filters,
      ),
      onSearchChanged: (value) {
        ref.read(seasonalFiltersProvider.notifier).setQuery(value);
      },
      onSortSelected: (value) {
        ref.read(seasonalSortProvider.notifier).setSort(value);
      },
      onSortDirectionToggle: () {
        ref.read(seasonalSortDirectionProvider.notifier).toggle();
      },
      onToggleFilters: () {
        setState(() {
          _expanded = !_expanded;
        });
      },
    );

    if (!_expanded) {
      return header;
    }

    return FilterLayout(
      modules: [
        FilterWidgetModule(header),
        FilterRowModule(
          children: [
            DropdownFilter<AppAnimeType?>(
              label: 'Type',
              value: type,
              options: const [
                FilterOption(value: null, label: 'All types'),
                FilterOption(value: AppAnimeType.tv, label: 'TV'),
                FilterOption(value: AppAnimeType.movie, label: 'Movie'),
                FilterOption(value: AppAnimeType.ova, label: 'OVA'),
                FilterOption(value: AppAnimeType.ona, label: 'ONA'),
                FilterOption(value: AppAnimeType.special, label: 'Special'),
              ],
              onChanged: (value) {
                ref.read(seasonalTypeFilterProvider.notifier).setType(value);
                ref.read(seasonalPageProvider.notifier).reset();
              },
            ),
            DropdownFilter<bool?>(
              label: 'Airing',
              value: filters.airing,
              options: const [
                FilterOption(value: null, label: 'Any airing'),
                FilterOption(value: true, label: 'Airing now'),
                FilterOption(value: false, label: 'Not airing'),
              ],
              onChanged: (value) {
                ref.read(seasonalFiltersProvider.notifier).setAiring(value);
              },
            ),
          ],
        ),
        FilterWidgetModule(
          RangeFilter(
            label: 'Score',
            values: RangeValues(filters.minScore, filters.maxScore),
            min: 0,
            max: 10,
            divisions: 20,
            onChanged: (values) {
              ref
                  .read(seasonalFiltersProvider.notifier)
                  .setScoreRange(values.start, values.end);
            },
          ),
        ),
        FilterWidgetModule(
          LabeledMultiChoiceFilter<ReleaseWeekday>(
            label: 'Release day',
            options: [
              for (final weekday in ReleaseWeekday.values)
                FilterOption(value: weekday, label: weekday.label),
            ],
            selectedValues: filters.releaseWeekdays,
            onToggle: (weekday) {
              ref
                  .read(seasonalFiltersProvider.notifier)
                  .toggleReleaseWeekday(weekday);
            },
          ),
        ),
        if (genres.isNotEmpty) ...[
          FilterWidgetModule(
            LabeledMultiChoiceFilter<String>(
              label: 'Genres',
              options: [
                for (final genre in genres)
                  FilterOption(value: genre, label: genre),
              ],
              selectedValues: filters.genres,
              onToggle: (genre) {
                ref.read(seasonalFiltersProvider.notifier).toggleGenre(genre);
              },
            ),
          ),
        ],
        if (tags.isNotEmpty) ...[
          FilterWidgetModule(
            LabeledMultiChoiceFilter<String>(
              label: 'Tags',
              options: [
                for (final tag in tags) FilterOption(value: tag, label: tag),
              ],
              selectedValues: filters.tags,
              onToggle: (tag) {
                ref.read(seasonalFiltersProvider.notifier).toggleTag(tag);
              },
            ),
          ),
        ],
        if (type != null || filters.hasActiveCachedFilters) ...[
          FilterWidgetModule(
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  ref.read(seasonalTypeFilterProvider.notifier).setType(null);
                  ref.read(seasonalFiltersProvider.notifier).clear();
                },
                icon: const Icon(Icons.filter_alt_off_outlined),
                label: const Text('Clear filters'),
              ),
            ),
          ),
        ],
      ],
    );
  }

  int _activeAdvancedFilterCount({
    required AppAnimeType? type,
    required SeasonalFilters filters,
  }) {
    var count = 0;
    if (type != null) {
      count += 1;
    }
    if (filters.airing != null) {
      count += 1;
    }
    if (filters.minScore > 0 || filters.maxScore < 10) {
      count += 1;
    }

    return count +
        filters.genres.length +
        filters.tags.length +
        filters.releaseWeekdays.length;
  }
}
