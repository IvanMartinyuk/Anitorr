import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

import '../../../shared/widgets/filter_controls.dart';
import '../../../shared/widgets/list_navigation.dart';
import '../domain/seasonal_anime_providers.dart';

const _seasonalItemsPerDisplayPage = 25;
const _seasonalFilterHeaderHeight = 48.0;

class SeasonalPage extends ConsumerWidget {
  const SeasonalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anime = ref.watch(seasonalAnimeProvider);
    final filtersActive = ref.watch(seasonalHasActiveCachedFiltersProvider);
    final page = ref.watch(seasonalPageProvider);
    final lastPage = ref.watch(seasonalLastPageProvider);
    final maxLoadedPage = ref.watch(seasonalMaxLoadedPageProvider);
    final isFullCacheLoading = ref.watch(seasonalFullCacheLoadingProvider);
    final loadedItems = anime.maybeWhen(
      data: (items) => items,
      orElse: () => const <Anime>[],
    );
    final displayLastPage = _displayLastPage(loadedItems.length);
    const listMode = ListNavigationMode.infiniteScroll;
    final isLoadingMore =
        anime.isLoading && maxLoadedPage > 0 ||
        filtersActive && isFullCacheLoading;
    final canLoadMore = !filtersActive && (lastPage == null || page < lastPage);
    final pageConfig = filtersActive
        ? PageNavigationConfig(
            currentPage: page,
            maxLoadedPage: displayLastPage,
            lastPage: displayLastPage,
            hasNextPage: page < displayLastPage,
            onPreviousPage: () {
              ref.read(seasonalPageProvider.notifier).goToPreviousPage();
            },
            onNextPage: () {
              ref
                  .read(seasonalPageProvider.notifier)
                  .goToNextPage(lastPageOverride: displayLastPage);
            },
            onPageSelected: (selectedPage) {
              ref
                  .read(seasonalPageProvider.notifier)
                  .goToPage(selectedPage, lastPageOverride: displayLastPage);
            },
          )
        : PageNavigationConfig(
            currentPage: page,
            maxLoadedPage: maxLoadedPage,
            lastPage: lastPage,
            hasNextPage: true,
            onPreviousPage: () {
              ref.read(seasonalPageProvider.notifier).goToPreviousPage();
            },
            onNextPage: () {
              ref.read(seasonalPageProvider.notifier).goToNextPage();
            },
            onPageSelected: (selectedPage) {
              ref.read(seasonalPageProvider.notifier).goToPage(selectedPage);
            },
          );

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(seasonalAnimeProvider.future),
        child: NavigableSliverList(
          mode: listMode,
          pageConfig: pageConfig,
          infiniteConfig: InfiniteScrollConfig(
            canLoadMore: canLoadMore,
            isLoading: isLoadingMore,
            thresholdPixels: 0,
            onLoadMore: () {
              ref.read(seasonalPageProvider.notifier).loadNextPage();
            },
            endLabel: 'All seasonal anime loaded',
          ),
          slivers: [
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(32, 32, 32, 20),
              sliver: SliverToBoxAdapter(child: _SeasonalControls()),
            ),
            ...anime.when(
              skipLoadingOnReload: true,
              data: (items) => [
                if (items.isEmpty)
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(32, 0, 32, 32),
                    sliver: SliverFillRemaining(
                      hasScrollBody: false,
                      child: _SeasonalEmptyState(),
                    ),
                  )
                else
                  _SeasonalAnimeGrid(
                    items: items,
                    page: filtersActive && listMode == ListNavigationMode.pages
                        ? page
                        : 1,
                    maxItemsPerPage:
                        filtersActive && listMode == ListNavigationMode.pages
                        ? _seasonalItemsPerDisplayPage
                        : null,
                  ),
              ],
              loading: () => const [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _SeasonalLoadingState(),
                ),
              ],
              error: (error, stackTrace) => [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _SeasonalErrorState(error: error),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  int _displayLastPage(int itemCount) {
    if (itemCount <= 0) {
      return 1;
    }

    return (itemCount / _seasonalItemsPerDisplayPage).ceil();
  }
}

class _SeasonalControls extends ConsumerStatefulWidget {
  const _SeasonalControls();

  @override
  ConsumerState<_SeasonalControls> createState() => _SeasonalControlsState();
}

class _SeasonalControlsState extends ConsumerState<_SeasonalControls> {
  bool _showAdvancedFilters = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final type = ref.watch(seasonalTypeFilterProvider);
    final sort = ref.watch(seasonalSortProvider);
    final filters = ref.watch(seasonalFiltersProvider);
    final genres = ref.watch(seasonalAvailableGenresProvider);
    final activeAdvancedFilterCount = _activeAdvancedFilterCount(
      type: type,
      filters: filters,
    );
    final header = _SeasonalFilterHeader(
      expanded: _showAdvancedFilters,
      filters: filters,
      sort: sort,
      activeAdvancedFilterCount: activeAdvancedFilterCount,
      onQueryChanged: (value) {
        ref.read(seasonalFiltersProvider.notifier).setQuery(value);
      },
      onSortSelected: (value) {
        ref.read(seasonalSortProvider.notifier).setSort(value);
      },
      onToggleAdvancedFilters: () {
        setState(() {
          _showAdvancedFilters = !_showAdvancedFilters;
        });
      },
    );

    if (!_showAdvancedFilters) {
      return header;
    }

    return FilterPanel(
      children: [
        header,
        const SizedBox(height: 18),
        FilterRow(
          children: [
            DropdownFilter<AnimeType?>(
              label: 'Type',
              value: type,
              options: const [
                FilterOption(value: null, label: 'All types'),
                FilterOption(value: AnimeType.tv, label: 'TV'),
                FilterOption(value: AnimeType.movie, label: 'Movie'),
                FilterOption(value: AnimeType.ova, label: 'OVA'),
                FilterOption(value: AnimeType.ona, label: 'ONA'),
                FilterOption(value: AnimeType.special, label: 'Special'),
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
        const SizedBox(height: 18),
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
        const SizedBox(height: 12),
        Text('Rating', style: textTheme.labelLarge),
        const SizedBox(height: 8),
        MultiChoiceFilter<AnimeContentRating>(
          options: [
            for (final rating in AnimeContentRating.values)
              FilterOption(value: rating, label: rating.label),
          ],
          selectedValues: filters.ratings,
          onToggle: (rating) {
            ref.read(seasonalFiltersProvider.notifier).toggleRating(rating);
          },
        ),
        if (genres.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('Genres', style: textTheme.labelLarge),
          const SizedBox(height: 8),
          MultiChoiceFilter<String>(
            options: [
              for (final genre in genres)
                FilterOption(value: genre, label: genre),
            ],
            selectedValues: filters.genres,
            onToggle: (genre) {
              ref.read(seasonalFiltersProvider.notifier).toggleGenre(genre);
            },
          ),
        ],
        if (type != null || filters.hasActiveCachedFilters) ...[
          const SizedBox(height: 14),
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
        ],
      ],
    );
  }

  int _activeAdvancedFilterCount({
    required AnimeType? type,
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

    return count + filters.ratings.length + filters.genres.length;
  }
}

class _SeasonalFilterHeader extends StatelessWidget {
  const _SeasonalFilterHeader({
    required this.expanded,
    required this.filters,
    required this.sort,
    required this.activeAdvancedFilterCount,
    required this.onQueryChanged,
    required this.onSortSelected,
    required this.onToggleAdvancedFilters,
  });

  final bool expanded;
  final SeasonalFilters filters;
  final SeasonalSort sort;
  final int activeAdvancedFilterCount;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<SeasonalSort> onSortSelected;
  final VoidCallback onToggleAdvancedFilters;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final search = _SearchFieldSurface(
          expanded: expanded,
          child: TextSearchFilter(
            label: 'Title',
            value: filters.query,
            hintText: 'English, Japanese, synonym',
            borderless: !expanded,
            width: double.infinity,
            onChanged: onQueryChanged,
          ),
        );
        final actions = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SortMenuButton(
              sort: sort,
              showLabel: expanded,
              onSelected: onSortSelected,
            ),
            const SizedBox(width: 8),
            _FilterToggleButton(
              count: activeAdvancedFilterCount,
              onPressed: onToggleAdvancedFilters,
            ),
          ],
        );

        if (constraints.maxWidth < 620) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              search,
              const SizedBox(height: 12),
              Align(alignment: Alignment.centerRight, child: actions),
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: search),
            const SizedBox(width: 12),
            actions,
          ],
        );
      },
    );
  }
}

class _SearchFieldSurface extends StatelessWidget {
  const _SearchFieldSurface({required this.expanded, required this.child});

  final bool expanded;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(expanded ? 8 : 24),
      ),
      child: SizedBox(
        height: _seasonalFilterHeaderHeight,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: expanded ? 0 : 4),
          child: child,
        ),
      ),
    );
  }
}

class _SortMenuButton extends StatelessWidget {
  const _SortMenuButton({
    required this.sort,
    required this.showLabel,
    required this.onSelected,
  });

  final SeasonalSort sort;
  final bool showLabel;
  final ValueChanged<SeasonalSort> onSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PopupMenuButton<SeasonalSort>(
      tooltip: 'Sort',
      initialValue: sort,
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          for (final option in SeasonalSort.values)
            PopupMenuItem(value: option, child: Text(option.label)),
        ];
      },
      child: SizedBox(
        height: _seasonalFilterHeaderHeight,
        width: showLabel ? null : _seasonalFilterHeaderHeight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(showLabel ? 8 : 24),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: showLabel ? 12 : 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.sort_rounded,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                if (showLabel) ...[
                  const SizedBox(width: 8),
                  Text(
                    sort.label,
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterToggleButton extends StatelessWidget {
  const _FilterToggleButton({required this.count, required this.onPressed});

  final int count;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox.square(
      dimension: _seasonalFilterHeaderHeight,
      child: Material(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: IconButton(
          tooltip: 'Filters',
          color: colorScheme.onSurfaceVariant,
          onPressed: onPressed,
          icon: Badge(
            isLabelVisible: count > 0,
            label: Text('$count'),
            backgroundColor: colorScheme.primary,
            textColor: colorScheme.onPrimary,
            child: const Icon(Icons.tune_rounded),
          ),
        ),
      ),
    );
  }
}

class _SeasonalAnimeGrid extends StatelessWidget {
  const _SeasonalAnimeGrid({
    required this.items,
    this.page = 1,
    this.maxItemsPerPage,
  });

  final List<Anime> items;
  final int page;
  final int? maxItemsPerPage;

  @override
  Widget build(BuildContext context) {
    final displayedItems = _itemsForPage();

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.crossAxisExtent;
          final columnCount = (width / 220).floor().clamp(2, 6);

          return SliverGrid.builder(
            itemCount: displayedItems.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.58,
            ),
            itemBuilder: (context, index) {
              return _SeasonalAnimeCard(anime: displayedItems[index]);
            },
          );
        },
      ),
    );
  }

  List<Anime> _itemsForPage() {
    final maxItems = maxItemsPerPage;
    if (maxItems == null) {
      return items;
    }

    final normalizedPage = page < 1 ? 1 : page;
    final start = (normalizedPage - 1) * maxItems;
    if (start >= items.length) {
      return const [];
    }

    final end = (start + maxItems).clamp(start, items.length);
    return items.sublist(start, end);
  }
}

class _SeasonalAnimeCard extends StatelessWidget {
  const _SeasonalAnimeCard({required this.anime});

  final Anime anime;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final title = anime.titleEnglish?.trim().isNotEmpty ?? false
        ? anime.titleEnglish!
        : anime.title;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      anime.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return ColoredBox(
                          color: colorScheme.surfaceContainerHighest,
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: colorScheme.onSurfaceVariant,
                            size: 36,
                          ),
                        );
                      },
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _AnimeRatingBadge(anime: anime),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 38,
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimeRatingBadge extends StatelessWidget {
  const _AnimeRatingBadge({required this.anime});

  final Anime anime;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final score = anime.score;
    final label = score == null ? 'N/A' : score.toStringAsFixed(1);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, size: 16, color: colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeasonalLoadingState extends StatelessWidget {
  const _SeasonalLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _SeasonalEmptyState extends StatelessWidget {
  const _SeasonalEmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No upcoming anime found.'));
  }
}

class _SeasonalErrorState extends StatelessWidget {
  const _SeasonalErrorState({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Could not load upcoming anime',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onErrorContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$error',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
