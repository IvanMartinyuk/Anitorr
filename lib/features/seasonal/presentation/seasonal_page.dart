import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

import '../../../shared/widgets/anime/anime_grid.dart';
import '../../../shared/widgets/navigable_list/navigable_list_widgets.dart';
import '../domain/seasonal_anime_providers.dart';
import 'widgets/seasonal_filters.dart';
import 'widgets/seasonal_states.dart';

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
    const listMode = ListNavigationMode.infiniteScroll;
    final isLoadingMore =
        anime.isLoading && maxLoadedPage > 0 ||
        filtersActive && isFullCacheLoading;
    final canLoadMore = !filtersActive && (lastPage == null || page < lastPage);

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(seasonalAnimeProvider.future),
        child: NavigableSliverList(
          mode: listMode,
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
              sliver: SliverToBoxAdapter(child: SeasonalFilterPanel()),
            ),
            ..._animeSlivers(anime: anime),
          ],
        ),
      ),
    );
  }

  List<Widget> _animeSlivers({required AsyncValue<List<Anime>> anime}) {
    return anime.when(
      skipLoadingOnReload: true,
      data: (items) => [
        if (items.isEmpty)
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(32, 0, 32, 32),
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              child: SeasonalEmptyState(),
            ),
          )
        else
          AnimeGrid(items: items),
      ],
      loading: () => const [
        SliverFillRemaining(
          hasScrollBody: false,
          child: SeasonalLoadingState(),
        ),
      ],
      error: (error, stackTrace) => [
        SliverFillRemaining(
          hasScrollBody: false,
          child: SeasonalErrorState(error: error),
        ),
      ],
    );
  }
}
