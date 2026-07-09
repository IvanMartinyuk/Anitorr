import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_moe/jikan_moe.dart';

import '../../../../shared/models/anime_api_filters.dart';
import '../../../../shared/widgets/filters/filters.dart';
import '../../domain/browse_anime_providers.dart';
import '../../domain/models/browse_filters.dart';

class BrowseFilterPanel extends ConsumerStatefulWidget {
  const BrowseFilterPanel({super.key});

  @override
  ConsumerState<BrowseFilterPanel> createState() => _BrowseFilterPanelState();
}

class _BrowseFilterPanelState extends ConsumerState<BrowseFilterPanel> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(browseFiltersProvider);
    final sort = ref.watch(browseSortProvider);
    final genres = ref
        .watch(browseGenresProvider)
        .maybeWhen(
          data: (items) => items,
          orElse: () => const <AnimeGenreData>[],
        );
    final header = FilterBar<BrowseSort>(
      expanded: _expanded,
      searchLabel: 'Title',
      searchValue: filters.query,
      searchHintText: 'English, Japanese, synonym',
      sortValue: sort,
      sortOptions: [
        for (final option in BrowseSort.values)
          FilterSortOption(value: option, label: option.label),
      ],
      activeFilterCount: _activeFilterCount(filters),
      onSearchChanged: (value) {
        ref.read(browseFiltersProvider.notifier).setQuery(value);
      },
      onSortSelected: (value) {
        ref.read(browseSortProvider.notifier).setSort(value);
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
              value: filters.type,
              options: const [
                FilterOption(value: null, label: 'All types'),
                FilterOption(value: AppAnimeType.tv, label: 'TV'),
                FilterOption(value: AppAnimeType.movie, label: 'Movie'),
                FilterOption(value: AppAnimeType.ova, label: 'OVA'),
                FilterOption(value: AppAnimeType.ona, label: 'ONA'),
                FilterOption(value: AppAnimeType.special, label: 'Special'),
                FilterOption(value: AppAnimeType.music, label: 'Music'),
              ],
              onChanged: (value) {
                ref.read(browseFiltersProvider.notifier).setType(value);
              },
            ),
            DropdownFilter<AnimeSearchStatus?>(
              label: 'Status',
              value: filters.status,
              options: [
                const FilterOption(value: null, label: 'Any status'),
                for (final status in AnimeSearchStatus.values)
                  FilterOption(value: status, label: status.label),
              ],
              onChanged: (value) {
                ref.read(browseFiltersProvider.notifier).setStatus(value);
              },
            ),
            DropdownFilter<AnimeSearchRating?>(
              label: 'Rating',
              value: filters.rating,
              options: [
                const FilterOption(value: null, label: 'Any rating'),
                for (final rating in AnimeSearchRating.values)
                  FilterOption(value: rating, label: rating.label),
              ],
              onChanged: (value) {
                ref.read(browseFiltersProvider.notifier).setRating(value);
              },
            ),
            DropdownFilter<bool>(
              label: 'SFW',
              value: filters.sfw,
              options: const [
                FilterOption(value: true, label: 'Safe results'),
                FilterOption(value: false, label: 'Include adult'),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(browseFiltersProvider.notifier).setSfw(value);
                }
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
                  .read(browseFiltersProvider.notifier)
                  .setScoreRange(values.start, values.end);
            },
          ),
        ),
        FilterRowModule(
          children: [
            TextSearchFilter(
              label: 'Start date',
              value: filters.startDate,
              hintText: 'YYYY-MM-DD',
              onChanged: (value) {
                ref.read(browseFiltersProvider.notifier).setStartDate(value);
              },
            ),
            TextSearchFilter(
              label: 'End date',
              value: filters.endDate,
              hintText: 'YYYY-MM-DD',
              onChanged: (value) {
                ref.read(browseFiltersProvider.notifier).setEndDate(value);
              },
            ),
          ],
        ),
        if (genres.isNotEmpty)
          FilterWidgetModule(
            LabeledMultiChoiceFilter<int>(
              label: 'Genres',
              options: [
                for (final genre in genres)
                  FilterOption(value: genre.malId, label: genre.name),
              ],
              selectedValues: filters.genres,
              onToggle: (genreId) {
                ref.read(browseFiltersProvider.notifier).toggleGenre(genreId);
              },
            ),
          ),
        if (genres.isNotEmpty)
          FilterWidgetModule(
            LabeledMultiChoiceFilter<int>(
              label: 'Exclude genres',
              options: [
                for (final genre in genres)
                  FilterOption(value: genre.malId, label: genre.name),
              ],
              selectedValues: filters.excludedGenres,
              onToggle: (genreId) {
                ref
                    .read(browseFiltersProvider.notifier)
                    .toggleExcludedGenre(genreId);
              },
            ),
          ),
        if (filters.hasActiveFilters)
          FilterWidgetModule(
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  ref.read(browseFiltersProvider.notifier).clear();
                },
                icon: const Icon(Icons.filter_alt_off_outlined),
                label: const Text('Clear filters'),
              ),
            ),
          ),
      ],
    );
  }

  int _activeFilterCount(BrowseFilters filters) {
    var count = filters.genres.length + filters.excludedGenres.length;
    if (filters.normalizedQuery != null) {
      count += 1;
    }
    if (filters.type != null) {
      count += 1;
    }
    if (filters.status != null) {
      count += 1;
    }
    if (filters.rating != null) {
      count += 1;
    }
    if (!filters.sfw) {
      count += 1;
    }
    if (filters.minScore > 0 || filters.maxScore < 10) {
      count += 1;
    }
    if (filters.startDate.trim().isNotEmpty) {
      count += 1;
    }
    if (filters.endDate.trim().isNotEmpty) {
      count += 1;
    }

    return count;
  }
}
