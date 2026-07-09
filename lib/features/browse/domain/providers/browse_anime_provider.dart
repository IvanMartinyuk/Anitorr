import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/app_anime.dart';
import 'browse_filter_providers.dart';
import 'browse_pagination_providers.dart';
import 'browse_repository_provider.dart';

final browseAnimeProvider = FutureProvider<List<AppAnime>>((ref) async {
  final filters = ref.watch(browseFiltersProvider);
  final sort = ref.watch(browseSortProvider);
  final page = ref.watch(browsePageProvider);
  final repository = ref.watch(browseAnimeRepositoryProvider);
  final animePage = await repository.searchAnime(
    filters: filters,
    sort: sort,
    page: page,
  );
  final anime = animePage.items;

  _runAfterBuildIfNeeded(ref, () {
    ref
        .read(browseLastPageProvider.notifier)
        .rememberLastPage(animePage.lastPage);
    ref
        .read(browseMaxLoadedPageProvider.notifier)
        .rememberMaxLoadedPage(animePage.hasNextPage ? page + 1 : page);

    if (anime.isEmpty && page > animePage.lastPage) {
      ref.read(browsePageProvider.notifier).goToPage(animePage.lastPage);
      return;
    }
  });

  return anime;
});

void _runAfterBuildIfNeeded(Ref ref, void Function() action) {
  if (!ref.mounted) {
    return;
  }

  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (ref.mounted) {
      action();
    }
  });
}
