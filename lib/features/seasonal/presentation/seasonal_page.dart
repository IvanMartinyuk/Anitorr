import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

import '../domain/seasonal_anime_providers.dart';

class SeasonalPage extends ConsumerWidget {
  const SeasonalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final anime = ref.watch(seasonalAnimeProvider);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(seasonalAnimeProvider.future),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 20),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Seasonal', style: textTheme.headlineMedium),
                    const SizedBox(height: 24),
                    const _SeasonalControls(),
                  ],
                ),
              ),
            ),
            anime.when(
              data: (items) {
                if (items.isEmpty) {
                  return const SliverPadding(
                    padding: EdgeInsets.fromLTRB(32, 0, 32, 32),
                    sliver: SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SeasonalEmptyState(),
                          SizedBox(height: 24),
                          _SeasonalPagination(hasNextPage: false),
                        ],
                      ),
                    ),
                  );
                }

                return SliverMainAxisGroup(
                  slivers: [
                    _SeasonalAnimeGrid(items: items),
                    const SliverPadding(
                      padding: EdgeInsets.fromLTRB(32, 0, 32, 32),
                      sliver: SliverToBoxAdapter(
                        child: _SeasonalPagination(hasNextPage: true),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const SliverFillRemaining(
                hasScrollBody: false,
                child: _SeasonalLoadingState(),
              ),
              error: (error, stackTrace) => SliverFillRemaining(
                hasScrollBody: false,
                child: _SeasonalErrorState(error: error),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeasonalControls extends ConsumerWidget {
  const _SeasonalControls();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final type = ref.watch(seasonalTypeFilterProvider);
    final sort = ref.watch(seasonalSortProvider);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 220,
              child: DropdownButtonFormField<AnimeType?>(
                initialValue: type,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Filter',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                items: const [
                  DropdownMenuItem(value: null, child: Text('All types')),
                  DropdownMenuItem(value: AnimeType.tv, child: Text('TV')),
                  DropdownMenuItem(
                    value: AnimeType.movie,
                    child: Text('Movie'),
                  ),
                  DropdownMenuItem(value: AnimeType.ova, child: Text('OVA')),
                  DropdownMenuItem(value: AnimeType.ona, child: Text('ONA')),
                  DropdownMenuItem(
                    value: AnimeType.special,
                    child: Text('Special'),
                  ),
                ],
                onChanged: (value) {
                  ref.read(seasonalTypeFilterProvider.notifier).setType(value);
                  ref.read(seasonalLastPageProvider.notifier).reset();
                  ref.read(seasonalMaxLoadedPageProvider.notifier).reset();
                  ref.read(seasonalPageProvider.notifier).reset();
                },
              ),
            ),
            SizedBox(
              width: 220,
              child: DropdownButtonFormField<SeasonalSort>(
                initialValue: sort,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Sort',
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
                items: [
                  for (final option in SeasonalSort.values)
                    DropdownMenuItem(value: option, child: Text(option.label)),
                ],
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }

                  ref.read(seasonalSortProvider.notifier).setSort(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SeasonalPagination extends ConsumerWidget {
  const _SeasonalPagination({required this.hasNextPage});

  final bool hasNextPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final page = ref.watch(seasonalPageProvider);
    final lastPage = ref.watch(seasonalLastPageProvider);
    final maxLoadedPage = ref.watch(seasonalMaxLoadedPageProvider);
    final pages = _visiblePages(page, lastPage, maxLoadedPage);
    final canGoNext =
        hasNextPage &&
        page < maxLoadedPage &&
        (lastPage == null || page < lastPage);

    return Center(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _PaginationButton(
            tooltip: 'Previous page',
            onPressed: page <= 1
                ? null
                : () {
                    ref.read(seasonalPageProvider.notifier).goToPreviousPage();
                  },
            child: const Icon(Icons.chevron_left_rounded),
          ),
          for (final visiblePage in pages)
            _PageNumberButton(
              page: visiblePage,
              selected: visiblePage == page,
              onPressed: () {
                ref.read(seasonalPageProvider.notifier).goToPage(visiblePage);
              },
            ),
          _PaginationButton(
            tooltip: 'Next page',
            onPressed: canGoNext
                ? () {
                    ref.read(seasonalPageProvider.notifier).goToNextPage();
                  }
                : null,
            child: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }

  List<int> _visiblePages(int currentPage, int? lastPage, int maxLoadedPage) {
    final availableEnd = lastPage ?? maxLoadedPage;
    final preferredEnd = currentPage <= 3 ? 5 : currentPage + 2;
    final end = preferredEnd.clamp(1, availableEnd);
    final start = (end - 4).clamp(1, end);

    return [for (var page = start; page <= end; page++) page];
  }
}

class _PageNumberButton extends StatelessWidget {
  const _PageNumberButton({
    required this.page,
    required this.selected,
    required this.onPressed,
  });

  final int page;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return _PaginationButton(
      selected: selected,
      onPressed: selected ? null : onPressed,
      child: Text(
        '$page',
        style: textTheme.labelLarge?.copyWith(
          color: selected
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PaginationButton extends StatelessWidget {
  const _PaginationButton({
    required this.child,
    this.onPressed,
    this.selected = false,
    this.tooltip,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool selected;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null;
    final foregroundColor = selected
        ? colorScheme.onPrimaryContainer
        : enabled
        ? colorScheme.onSurface
        : colorScheme.onSurface.withValues(alpha: 0.38);

    final button = SizedBox.square(
      dimension: 40,
      child: Material(
        color: selected
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: IconTheme(
              data: IconThemeData(color: foregroundColor),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: foregroundColor),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );

    if (tooltip == null) {
      return button;
    }

    return Tooltip(message: tooltip!, child: button);
  }
}

class _SeasonalAnimeGrid extends StatelessWidget {
  const _SeasonalAnimeGrid({required this.items});

  final List<Anime> items;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.crossAxisExtent;
          final columnCount = (width / 220).floor().clamp(2, 6);

          return SliverGrid.builder(
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.58,
            ),
            itemBuilder: (context, index) {
              return _SeasonalAnimeCard(anime: items[index]);
            },
          );
        },
      ),
    );
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
