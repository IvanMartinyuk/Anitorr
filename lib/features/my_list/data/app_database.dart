import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:drift/native.dart';

part 'app_database.g.dart';

class AnimeSnapshots extends Table {
  IntColumn get id => integer()();
  TextColumn get title => text()();
  TextColumn get titleEnglish => text().nullable()();
  TextColumn get imageUrl => text()();
  TextColumn get type => text().nullable()();
  IntColumn get episodes => integer().nullable()();
  RealColumn get score => real().nullable()();
  IntColumn get year => integer().nullable()();
  BoolColumn get airing => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class UserAnimeEntries extends Table {
  IntColumn get animeId =>
      integer().references(AnimeSnapshots, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text()();
  IntColumn get progress => integer().withDefault(const Constant(0))();
  RealColumn get userScore => real().nullable()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get rewatchCount => integer().withDefault(const Constant(0))();
  TextColumn get notes => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {animeId};
}

class CustomLists extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  DateTimeColumn get createdAt => dateTime()();
}

class CustomListItems extends Table {
  IntColumn get listId =>
      integer().references(CustomLists, #id, onDelete: KeyAction.cascade)();
  IntColumn get animeId =>
      integer().references(AnimeSnapshots, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get addedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {listId, animeId};
}

class DownloadIntents extends Table {
  IntColumn get animeId =>
      integer().references(AnimeSnapshots, #id, onDelete: KeyAction.cascade)();
  TextColumn get selectedEpisodesJson =>
      text().withDefault(const Constant('[]'))();
  BoolColumn get allAvailableEpisodes =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get autoDownloadFuture =>
      boolean().withDefault(const Constant(false))();
  TextColumn get state => text()();
  BoolColumn get paused => boolean().withDefault(const Constant(false))();
  TextColumn get destinationOverride => text().nullable()();
  DateTimeColumn get lastCheckedAt => dateTime().nullable()();
  TextColumn get errorMessage => text().nullable()();
  TextColumn get releaseGroup => text().nullable()();
  TextColumn get quality => text().nullable()();
  TextColumn get category => text().withDefault(const Constant('1_2'))();
  IntColumn get season => integer().nullable()();
  TextColumn get seriesTitle => text().nullable()();
  IntColumn get preferredSizeBytes => integer().nullable()();
  DateTimeColumn get alternativeFirstSeenAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {animeId};
}

class DownloadAlerts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get animeId => integer().references(
    DownloadIntents,
    #animeId,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get episode => integer().nullable()();
  TextColumn get message => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get resolvedAt => dateTime().nullable()();
}

class DownloadJobs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get animeId => integer().references(
    DownloadIntents,
    #animeId,
    onDelete: KeyAction.cascade,
  )();
  TextColumn get sourceId => text().unique()();
  TextColumn get sourceUri => text()();
  TextColumn get episodeCoverageJson =>
      text().withDefault(const Constant('[]'))();
  TextColumn get destination => text()();
  TextColumn get torrentHash => text().nullable()();
  TextColumn get state => text()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    AnimeSnapshots,
    UserAnimeEntries,
    CustomLists,
    CustomListItems,
    DownloadIntents,
    DownloadJobs,
    DownloadAlerts,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openDatabase());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(downloadIntents, downloadIntents.releaseGroup);
        await migrator.addColumn(downloadIntents, downloadIntents.quality);
        await migrator.addColumn(downloadIntents, downloadIntents.category);
        await migrator.addColumn(downloadIntents, downloadIntents.season);
        await migrator.addColumn(downloadIntents, downloadIntents.seriesTitle);
        await migrator.addColumn(
          downloadIntents,
          downloadIntents.alternativeFirstSeenAt,
        );
        await migrator.createTable(downloadAlerts);
      }
      if (from < 3) {
        final alreadyAdded = await _columnExists(
          'download_intents',
          'preferred_size_bytes',
        );
        if (!alreadyAdded) {
          await migrator.addColumn(
            downloadIntents,
            downloadIntents.preferredSizeBytes,
          );
        }
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  Future<bool> _columnExists(String table, String column) async {
    final columns = await customSelect('PRAGMA table_info($table)').get();
    return columns.any((row) => row.read<String>('name') == column);
  }
}

QueryExecutor _openDatabase() {
  if (Platform.environment['FLUTTER_TEST'] == 'true') {
    return NativeDatabase.memory();
  }
  return driftDatabase(name: 'anitorr');
}
