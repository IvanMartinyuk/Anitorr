import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/app_anime.dart';
import '../../data/app_database.dart' hide DownloadAlert;
import '../../data/my_list_repository.dart';
import '../models/user_anime.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final myListRepositoryProvider = Provider<MyListRepository>((ref) {
  return MyListRepository(ref.watch(appDatabaseProvider));
});

final libraryProvider = StreamProvider<List<LibraryAnime>>((ref) {
  return ref.watch(myListRepositoryProvider).watchLibrary();
});

final customListsProvider = StreamProvider<List<CustomAnimeList>>((ref) {
  return ref.watch(myListRepositoryProvider).watchCustomLists();
});

final downloadAlertsProvider = StreamProvider<List<DownloadAlert>>((ref) {
  return ref.watch(myListRepositoryProvider).watchDownloadAlerts();
});

final libraryAnimeProvider = StreamProvider.family<LibraryAnime?, int>((
  ref,
  animeId,
) {
  return ref.watch(myListRepositoryProvider).watchAnime(animeId);
});

final myListControllerProvider = Provider<MyListController>((ref) {
  return MyListController(ref.watch(myListRepositoryProvider));
});

final myListFilterProvider =
    NotifierProvider<MyListFilterNotifier, MyListFilter>(
      MyListFilterNotifier.new,
    );

final filteredLibraryProvider = Provider<AsyncValue<List<LibraryAnime>>>((ref) {
  final filter = ref.watch(myListFilterProvider);
  return ref.watch(libraryProvider).whenData((items) {
    final query = filter.query.trim().toLowerCase();
    return [
      for (final item in items)
        if (_matchesView(item, filter) &&
            (query.isEmpty ||
                item.anime.title.toLowerCase().contains(query) ||
                (item.anime.titleEnglish?.toLowerCase().contains(query) ??
                    false)))
          item,
    ];
  });
});

enum MyListViewType { all, status, download, custom }

final class MyListFilter {
  const MyListFilter({
    this.type = MyListViewType.all,
    this.status,
    this.customListId,
    this.query = '',
  });

  final MyListViewType type;
  final AnimeListStatus? status;
  final int? customListId;
  final String query;

  MyListFilter copyWith({String? query}) {
    return MyListFilter(
      type: type,
      status: status,
      customListId: customListId,
      query: query ?? this.query,
    );
  }
}

class MyListFilterNotifier extends Notifier<MyListFilter> {
  @override
  MyListFilter build() => const MyListFilter();

  void showAll() {
    state = MyListFilter(query: state.query);
  }

  void showStatus(AnimeListStatus status) {
    state = MyListFilter(
      type: MyListViewType.status,
      status: status,
      query: state.query,
    );
  }

  void showDownloads() {
    state = MyListFilter(type: MyListViewType.download, query: state.query);
  }

  void showCustomList(int listId) {
    state = MyListFilter(
      type: MyListViewType.custom,
      customListId: listId,
      query: state.query,
    );
  }

  void setQuery(String query) {
    state = state.copyWith(query: query);
  }
}

bool _matchesView(LibraryAnime anime, MyListFilter filter) {
  return switch (filter.type) {
    MyListViewType.all =>
      anime.entry != null ||
          anime.customListIds.isNotEmpty ||
          anime.download != null,
    MyListViewType.status => anime.entry?.status == filter.status,
    MyListViewType.download => anime.download != null,
    MyListViewType.custom => anime.customListIds.contains(filter.customListId),
  };
}

final class MyListController {
  const MyListController(this._repository);

  final MyListRepository _repository;

  Future<void> setStatus(AppAnime anime, AnimeListStatus status) {
    return _repository.setStatus(anime, status);
  }

  Future<void> removeStatus(int animeId) {
    return _repository.removeStatus(animeId);
  }

  Future<void> updateProgress(int animeId, int progress) {
    return _repository.updateProgress(animeId: animeId, progress: progress);
  }

  Future<void> updateTracking({
    required int animeId,
    required int progress,
    required double? userScore,
    required DateTime? startedAt,
    required DateTime? completedAt,
    required int rewatchCount,
    required String notes,
  }) {
    return _repository.updateTracking(
      animeId: animeId,
      progress: progress,
      userScore: userScore,
      startedAt: startedAt,
      completedAt: completedAt,
      rewatchCount: rewatchCount,
      notes: notes,
    );
  }

  Future<int> createCustomList(String name) {
    return _repository.createCustomList(name);
  }

  Future<void> renameCustomList(int listId, String name) {
    return _repository.renameCustomList(listId, name);
  }

  Future<void> deleteCustomList(int listId) {
    return _repository.deleteCustomList(listId);
  }

  Future<void> setCustomListMembership({
    required AppAnime anime,
    required int listId,
    required bool selected,
  }) {
    return _repository.setCustomListMembership(
      anime: anime,
      listId: listId,
      selected: selected,
    );
  }

  Future<void> saveDownloadIntent({
    required AppAnime anime,
    required Set<int> selectedEpisodes,
    required bool allAvailableEpisodes,
    required bool autoDownloadFuture,
    String? releaseGroup,
    String? quality,
    String category = '1_2',
    int? season,
    String? seriesTitle,
    int? preferredSizeBytes,
  }) {
    return _repository.saveDownloadIntent(
      anime: anime,
      selectedEpisodes: selectedEpisodes,
      allAvailableEpisodes: allAvailableEpisodes,
      autoDownloadFuture: autoDownloadFuture,
      releaseGroup: releaseGroup,
      quality: quality,
      category: category,
      season: season,
      seriesTitle: seriesTitle,
      preferredSizeBytes: preferredSizeBytes,
    );
  }

  Future<void> setDownloadPaused(int animeId, bool paused) {
    return _repository.setDownloadPaused(animeId, paused);
  }

  Future<void> updateDownloadState(
    int animeId,
    DownloadState state, {
    String? errorMessage,
    bool checked = false,
  }) {
    return _repository.updateDownloadState(
      animeId,
      state,
      errorMessage: errorMessage,
      checked: checked,
    );
  }

  Future<void> removeDownloadIntent(int animeId) {
    return _repository.removeDownloadIntent(animeId);
  }

  Future<void> resolveDownloadAlert(int id) {
    return _repository.resolveDownloadAlert(id);
  }
}
