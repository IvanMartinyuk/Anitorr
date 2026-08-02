import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../shared/models/app_anime.dart';
import '../domain/models/user_anime.dart' as models;
import 'app_database.dart' as db;

final class MyListRepository {
  MyListRepository(this._database);

  final db.AppDatabase _database;

  Stream<List<models.LibraryAnime>> watchLibrary() {
    final query =
        _database.select(_database.animeSnapshots).join([
          leftOuterJoin(
            _database.userAnimeEntries,
            _database.userAnimeEntries.animeId.equalsExp(
              _database.animeSnapshots.id,
            ),
          ),
          leftOuterJoin(
            _database.downloadIntents,
            _database.downloadIntents.animeId.equalsExp(
              _database.animeSnapshots.id,
            ),
          ),
          leftOuterJoin(
            _database.customListItems,
            _database.customListItems.animeId.equalsExp(
              _database.animeSnapshots.id,
            ),
          ),
        ])..where(
          _database.userAnimeEntries.animeId.isNotNull() |
              _database.downloadIntents.animeId.isNotNull() |
              _database.customListItems.animeId.isNotNull(),
        );

    return query.watch().map((rows) {
      final items = <int, models.LibraryAnime>{};
      for (final row in rows) {
        final snapshot = row.readTable(_database.animeSnapshots);
        final entry = row.readTableOrNull(_database.userAnimeEntries);
        final download = row.readTableOrNull(_database.downloadIntents);
        final customItem = row.readTableOrNull(_database.customListItems);
        final current = items[snapshot.id];
        final customIds = {...?current?.customListIds};
        if (customItem != null) {
          customIds.add(customItem.listId);
        }

        items[snapshot.id] = models.LibraryAnime(
          anime: _savedAnime(snapshot),
          entry: entry == null ? null : _userEntry(entry),
          customListIds: customIds,
          download: download == null ? null : _downloadIntent(download),
        );
      }

      final values = items.values.toList()
        ..sort(
          (a, b) =>
              b.entry?.updatedAt.compareTo(
                a.entry?.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0),
              ) ??
              0,
        );
      return values;
    });
  }

  Stream<List<models.CustomAnimeList>> watchCustomLists() {
    return (_database.select(
      _database.customLists,
    )..orderBy([(table) => OrderingTerm.asc(table.name)])).watch().map(
      (items) => [
        for (final item in items)
          models.CustomAnimeList(
            id: item.id,
            name: item.name,
            createdAt: item.createdAt,
          ),
      ],
    );
  }

  Stream<models.LibraryAnime?> watchAnime(int animeId) {
    return watchLibrary().map((items) {
      for (final item in items) {
        if (item.anime.id == animeId) {
          return item;
        }
      }
      return null;
    });
  }

  Future<void> setStatus(AppAnime anime, models.AnimeListStatus status) async {
    await _database.transaction(() async {
      await _upsertAnime(anime);
      final now = DateTime.now();
      final existing = await (_database.select(
        _database.userAnimeEntries,
      )..where((table) => table.animeId.equals(anime.id))).getSingleOrNull();
      await _database
          .into(_database.userAnimeEntries)
          .insertOnConflictUpdate(
            db.UserAnimeEntriesCompanion.insert(
              animeId: Value(anime.id),
              status: status.name,
              progress: Value(existing?.progress ?? 0),
              userScore: Value(existing?.userScore),
              startedAt: Value(existing?.startedAt),
              completedAt: Value(existing?.completedAt),
              rewatchCount: Value(existing?.rewatchCount ?? 0),
              notes: Value(existing?.notes ?? ''),
              createdAt: existing?.createdAt ?? now,
              updatedAt: now,
            ),
          );
    });
  }

  Future<void> removeStatus(int animeId) async {
    await (_database.delete(
      _database.userAnimeEntries,
    )..where((table) => table.animeId.equals(animeId))).go();
  }

  Future<void> updateProgress({
    required int animeId,
    required int progress,
  }) async {
    final normalized = progress < 0 ? 0 : progress;
    await (_database.update(
      _database.userAnimeEntries,
    )..where((table) => table.animeId.equals(animeId))).write(
      db.UserAnimeEntriesCompanion(
        progress: Value(normalized),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateTracking({
    required int animeId,
    required int progress,
    required double? userScore,
    required DateTime? startedAt,
    required DateTime? completedAt,
    required int rewatchCount,
    required String notes,
  }) async {
    await (_database.update(
      _database.userAnimeEntries,
    )..where((table) => table.animeId.equals(animeId))).write(
      db.UserAnimeEntriesCompanion(
        progress: Value(progress < 0 ? 0 : progress),
        userScore: Value(userScore),
        startedAt: Value(startedAt),
        completedAt: Value(completedAt),
        rewatchCount: Value(rewatchCount < 0 ? 0 : rewatchCount),
        notes: Value(notes.trim()),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> createCustomList(String name) {
    return _database
        .into(_database.customLists)
        .insert(
          db.CustomListsCompanion.insert(
            name: name.trim(),
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<void> renameCustomList(int listId, String name) async {
    await (_database.update(_database.customLists)
          ..where((table) => table.id.equals(listId)))
        .write(db.CustomListsCompanion(name: Value(name.trim())));
  }

  Future<void> deleteCustomList(int listId) async {
    await (_database.delete(
      _database.customLists,
    )..where((table) => table.id.equals(listId))).go();
  }

  Future<void> setCustomListMembership({
    required AppAnime anime,
    required int listId,
    required bool selected,
  }) async {
    await _database.transaction(() async {
      await _upsertAnime(anime);
      if (selected) {
        await _database
            .into(_database.customListItems)
            .insertOnConflictUpdate(
              db.CustomListItemsCompanion.insert(
                listId: listId,
                animeId: anime.id,
                addedAt: DateTime.now(),
              ),
            );
      } else {
        await (_database.delete(_database.customListItems)..where(
              (table) =>
                  table.listId.equals(listId) & table.animeId.equals(anime.id),
            ))
            .go();
      }
    });
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
  }) async {
    await _database.transaction(() async {
      await _upsertAnime(anime);
      final now = DateTime.now();
      final existing = await (_database.select(
        _database.downloadIntents,
      )..where((table) => table.animeId.equals(anime.id))).getSingleOrNull();
      final sortedEpisodes = selectedEpisodes.toList()..sort();
      await _database
          .into(_database.downloadIntents)
          .insertOnConflictUpdate(
            db.DownloadIntentsCompanion.insert(
              animeId: Value(anime.id),
              selectedEpisodesJson: Value(jsonEncode(sortedEpisodes)),
              allAvailableEpisodes: Value(allAvailableEpisodes),
              autoDownloadFuture: Value(autoDownloadFuture),
              state: models.DownloadState.awaitingSearch.name,
              paused: Value(existing?.paused ?? false),
              destinationOverride: Value(existing?.destinationOverride),
              lastCheckedAt: Value(existing?.lastCheckedAt),
              errorMessage: const Value(null),
              releaseGroup: Value(releaseGroup ?? existing?.releaseGroup),
              quality: Value(quality ?? existing?.quality),
              category: Value(category),
              season: Value(season ?? existing?.season),
              seriesTitle: Value(seriesTitle ?? existing?.seriesTitle),
              preferredSizeBytes: Value(
                preferredSizeBytes ?? existing?.preferredSizeBytes,
              ),
              alternativeFirstSeenAt: Value(existing?.alternativeFirstSeenAt),
              createdAt: existing?.createdAt ?? now,
              updatedAt: now,
            ),
          );
    });
  }

  Future<void> setDownloadPaused(int animeId, bool paused) async {
    await (_database.update(
      _database.downloadIntents,
    )..where((table) => table.animeId.equals(animeId))).write(
      db.DownloadIntentsCompanion(
        paused: Value(paused),
        state: Value(
          paused
              ? models.DownloadState.paused.name
              : models.DownloadState.awaitingSearch.name,
        ),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> updateDownloadState(
    int animeId,
    models.DownloadState state, {
    String? errorMessage,
    bool checked = false,
  }) async {
    await (_database.update(
      _database.downloadIntents,
    )..where((table) => table.animeId.equals(animeId))).write(
      db.DownloadIntentsCompanion(
        state: Value(state.name),
        errorMessage: Value(errorMessage),
        lastCheckedAt: checked ? Value(DateTime.now()) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> removeDownloadIntent(int animeId) async {
    await (_database.delete(
      _database.downloadIntents,
    )..where((table) => table.animeId.equals(animeId))).go();
  }

  Stream<List<models.DownloadAlert>> watchDownloadAlerts() {
    return (_database.select(_database.downloadAlerts)
          ..where((table) => table.resolvedAt.isNull())
          ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]))
        .watch()
        .map(
          (rows) => [
            for (final row in rows)
              models.DownloadAlert(
                id: row.id,
                animeId: row.animeId,
                episode: row.episode,
                message: row.message,
                createdAt: row.createdAt,
              ),
          ],
        );
  }

  Future<void> resolveDownloadAlert(int id) async {
    await (_database.update(_database.downloadAlerts)
          ..where((table) => table.id.equals(id)))
        .write(db.DownloadAlertsCompanion(resolvedAt: Value(DateTime.now())));
  }

  Future<void> createDownloadAlert({
    required int animeId,
    required int? episode,
    required String message,
  }) async {
    final existing =
        await (_database.select(_database.downloadAlerts)..where(
              (table) =>
                  table.animeId.equals(animeId) &
                  (episode == null
                      ? table.episode.isNull()
                      : table.episode.equals(episode)) &
                  table.resolvedAt.isNull(),
            ))
            .getSingleOrNull();
    if (existing != null) return;
    await _database
        .into(_database.downloadAlerts)
        .insert(
          db.DownloadAlertsCompanion.insert(
            animeId: animeId,
            episode: Value(episode),
            message: message,
            createdAt: DateTime.now(),
          ),
        );
  }

  Future<bool> hasDownloadJob(String sourceId) async {
    return await (_database.select(_database.downloadJobs)
              ..where((table) => table.sourceId.equals(sourceId)))
            .getSingleOrNull() !=
        null;
  }

  Future<Set<int>> downloadJobEpisodeCoverage(int animeId) async {
    final jobs = await (_database.select(
      _database.downloadJobs,
    )..where((table) => table.animeId.equals(animeId))).get();
    return {
      for (final job in jobs)
        for (final episode
            in (jsonDecode(job.episodeCoverageJson) as List<dynamic>))
          if (episode is int) episode,
    };
  }

  Future<List<models.DownloadJobRecord>> loadDownloadJobs(int animeId) async {
    final jobs = await (_database.select(
      _database.downloadJobs,
    )..where((table) => table.animeId.equals(animeId))).get();
    return [
      for (final job in jobs)
        models.DownloadJobRecord(
          id: job.id,
          animeId: job.animeId,
          sourceId: job.sourceId,
          source: Uri.parse(job.sourceUri),
          episodes: (jsonDecode(job.episodeCoverageJson) as List<dynamic>)
              .whereType<num>()
              .map((value) => value.toInt())
              .toSet(),
          destination: job.destination,
          torrentHash: job.torrentHash,
        ),
    ];
  }

  Future<void> deleteDownloadJob(int id) async {
    await (_database.delete(
      _database.downloadJobs,
    )..where((table) => table.id.equals(id))).go();
  }

  Future<void> saveDownloadJob({
    required int animeId,
    required String sourceId,
    required Uri source,
    required Set<int> episodes,
    required String destination,
    String? torrentHash,
  }) async {
    final sorted = episodes.toList()..sort();
    await _database
        .into(_database.downloadJobs)
        .insertOnConflictUpdate(
          db.DownloadJobsCompanion.insert(
            animeId: animeId,
            sourceId: sourceId,
            sourceUri: source.toString(),
            episodeCoverageJson: Value(jsonEncode(sorted)),
            destination: destination,
            torrentHash: Value(torrentHash),
            state: models.DownloadState.queued.name,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );
  }

  Future<void> rememberAlternativeSeen(int animeId, DateTime value) async {
    await (_database.update(
      _database.downloadIntents,
    )..where((table) => table.animeId.equals(animeId))).write(
      db.DownloadIntentsCompanion(
        alternativeFirstSeenAt: Value(value),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> _upsertAnime(AppAnime anime) async {
    await _database
        .into(_database.animeSnapshots)
        .insertOnConflictUpdate(
          db.AnimeSnapshotsCompanion.insert(
            id: Value(anime.id),
            title: anime.title,
            titleEnglish: Value(anime.titleEnglish),
            imageUrl: anime.imageUrl,
            type: Value(anime.type),
            episodes: Value(anime.episodes),
            score: Value(anime.score),
            year: Value(anime.year),
            airing: Value(anime.airing),
            updatedAt: DateTime.now(),
          ),
        );
  }

  models.SavedAnime _savedAnime(db.AnimeSnapshot item) {
    return models.SavedAnime(
      id: item.id,
      title: item.title,
      titleEnglish: item.titleEnglish,
      imageUrl: item.imageUrl,
      type: item.type,
      episodes: item.episodes,
      score: item.score,
      year: item.year,
      airing: item.airing,
    );
  }

  models.UserAnimeEntry _userEntry(db.UserAnimeEntry item) {
    return models.UserAnimeEntry(
      animeId: item.animeId,
      status: models.AnimeListStatus.values.byName(item.status),
      progress: item.progress,
      userScore: item.userScore,
      startedAt: item.startedAt,
      completedAt: item.completedAt,
      rewatchCount: item.rewatchCount,
      notes: item.notes,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }

  models.DownloadIntent _downloadIntent(db.DownloadIntent item) {
    final episodes = (jsonDecode(item.selectedEpisodesJson) as List<dynamic>)
        .whereType<num>()
        .map((value) => value.toInt())
        .toSet();
    return models.DownloadIntent(
      animeId: item.animeId,
      selectedEpisodes: episodes,
      allAvailableEpisodes: item.allAvailableEpisodes,
      autoDownloadFuture: item.autoDownloadFuture,
      state: models.DownloadState.values.byName(item.state),
      paused: item.paused,
      destinationOverride: item.destinationOverride,
      lastCheckedAt: item.lastCheckedAt,
      errorMessage: item.errorMessage,
      releaseGroup: item.releaseGroup,
      quality: item.quality,
      category: item.category,
      season: item.season,
      seriesTitle: item.seriesTitle,
      preferredSizeBytes: item.preferredSizeBytes,
      alternativeFirstSeenAt: item.alternativeFirstSeenAt,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
    );
  }
}
