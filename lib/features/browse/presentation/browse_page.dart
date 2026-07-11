import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../shared/models/app_anime.dart';
import '../../../shared/widgets/anime/anime_grid.dart';
import '../../../shared/widgets/navigable_list/navigable_list_widgets.dart';
import '../domain/browse_anime_providers.dart';
import 'widgets/browse_filters.dart';
import 'widgets/browse_states.dart';

class BrowsePage extends ConsumerWidget {
  const BrowsePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anime = ref.watch(browseAnimeProvider);
    final page = ref.watch(browsePageProvider);
    final lastPage = ref.watch(browseLastPageProvider);
    final maxLoadedPage = ref.watch(browseMaxLoadedPageProvider);
    final hasNextPage = lastPage == null || page < lastPage;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => ref.refresh(browseAnimeProvider.future),
        child: NavigableSliverList(
          mode: ListNavigationMode.pages,
          pageConfig: PageNavigationConfig(
            currentPage: page,
            maxLoadedPage: maxLoadedPage,
            lastPage: lastPage,
            hasNextPage: hasNextPage,
            visiblePageCount: visibleBrowsePageCount,
            onPreviousPage: () {
              ref.read(browsePageProvider.notifier).goToPreviousPage();
            },
            onNextPage: () {
              ref
                  .read(browsePageProvider.notifier)
                  .goToNextPage(lastPageOverride: lastPage);
            },
            onPageSelected: (page) {
              ref
                  .read(browsePageProvider.notifier)
                  .goToPage(page, lastPageOverride: lastPage);
            },
          ),
          slivers: [
            const SliverPadding(
              padding: EdgeInsets.fromLTRB(32, 32, 32, 20),
              sliver: SliverToBoxAdapter(child: BrowseFilterPanel()),
            ),
            ..._animeSlivers(context: context, anime: anime),
          ],
        ),
      ),
    );
  }

  List<Widget> _animeSlivers({
    required BuildContext context,
    required AsyncValue<List<AppAnime>> anime,
  }) {
    return anime.when(
      skipLoadingOnReload: true,
      data: (items) => [
        if (items.isEmpty)
          const SliverPadding(
            padding: EdgeInsets.fromLTRB(32, 0, 32, 32),
            sliver: SliverFillRemaining(
              hasScrollBody: false,
              child: BrowseEmptyState(),
            ),
          )
        else
          AnimeGrid(
            items: items,
            onAnimeSelected: (anime) {
              context.goNamed(
                AppRoute.animeDetails.name,
                pathParameters: {'animeId': anime.id.toString()},
                extra: anime,
              );
            },
          ),
      ],
      loading: () => const [
        SliverFillRemaining(hasScrollBody: false, child: BrowseLoadingState()),
      ],
      error: (error, stackTrace) => [
        SliverFillRemaining(
          hasScrollBody: false,
          child: BrowseErrorState(error: error),
        ),
      ],
    );
  }
}
