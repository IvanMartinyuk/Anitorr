import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

import '../../../../shared/utils/running_task_counter.dart';
import '../../data/seasonal_anime_repository.dart';
import 'seasonal_pagination_providers.dart';

final seasonalCacheControllerProvider = Provider<SeasonalCacheController>((
  ref,
) {
  return SeasonalCacheController(ref);
});

final class SeasonalCacheController {
  SeasonalCacheController(this._ref) {
    _taskCounter = RunningTaskCounter(
      onChanged: (isLoading) {
        runAfterBuildIfNeeded(_ref, () {
          _ref
              .read(seasonalFullCacheLoadingProvider.notifier)
              .setLoading(isLoading);
        });
      },
    );
  }

  final Ref _ref;
  late final RunningTaskCounter _taskCounter;

  void startFullCache({
    required SeasonalAnimeRepository repository,
    required AnimeType? type,
  }) {
    if (repository.isFullCacheStarted(type: type)) {
      return;
    }

    repository.markFullCacheStarted(type: type);
    _taskCounter.start();

    unawaited(
      cachePagesUntilEmpty(
        ref: _ref,
        repository: repository,
        type: type,
        startPage: 2,
      ).whenComplete(_taskCounter.finish),
    );
  }
}

Future<void> cachePagesUntilEmpty({
  required Ref ref,
  required SeasonalAnimeRepository repository,
  required AnimeType? type,
  required int startPage,
  int? endPage,
}) async {
  var page = startPage;
  while (endPage == null || page <= endPage) {
    final anime = await repository.getCurrentSeasonAnime(
      type: type,
      page: page,
    );

    if (!ref.mounted) {
      return;
    }

    runAfterBuildIfNeeded(ref, () {
      syncSeasonalPaginationCacheState(
        ref: ref,
        repository: repository,
        type: type,
      );
    });

    if (anime.isEmpty) {
      runAfterBuildIfNeeded(ref, () {
        ref.read(seasonalLastPageProvider.notifier).rememberLastPage(page - 1);
      });
      return;
    }

    page += 1;
  }
}

void syncSeasonalPaginationCacheState({
  required Ref ref,
  required SeasonalAnimeRepository repository,
  required AnimeType? type,
}) {
  final lastPage = repository.getKnownLastPage(type: type);
  final maxLoadedPage = repository.getMaxContiguousLoadedPage(type: type);
  if (lastPage != null) {
    ref.read(seasonalLastPageProvider.notifier).rememberLastPage(lastPage);
  }

  ref
      .read(seasonalMaxLoadedPageProvider.notifier)
      .rememberMaxLoadedPage(maxLoadedPage);
}

void runAfterBuildIfNeeded(Ref ref, void Function() action) {
  if (!ref.mounted) {
    return;
  }

  SchedulerBinding.instance.addPostFrameCallback((_) {
    if (ref.mounted) {
      action();
    }
  });
}
