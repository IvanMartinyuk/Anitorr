import 'dart:ffi';

import 'package:anitorr/features/my_list/data/app_database.dart';
import 'package:anitorr/features/my_list/data/my_list_repository.dart';
import 'package:anitorr/features/my_list/domain/models/user_anime.dart';
import 'package:anitorr/shared/models/app_anime.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/open.dart';

void main() {
  late AppDatabase database;
  late MyListRepository repository;

  setUpAll(() {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('libsqlite3.so.0'),
    );
  });

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());
    repository = MyListRepository(database);
  });

  tearDown(() => database.close());

  test('status, custom lists, and downloads are independent', () async {
    await repository.setStatus(_anime, AnimeListStatus.watching);
    final customListId = await repository.createCustomList('Favorites');
    await repository.setCustomListMembership(
      anime: _anime,
      listId: customListId,
      selected: true,
    );
    await repository.saveDownloadIntent(
      anime: _anime,
      selectedEpisodes: {3, 1, 2},
      allAvailableEpisodes: false,
      autoDownloadFuture: true,
    );

    var item = (await repository.watchLibrary().first).single;
    expect(item.entry?.status, AnimeListStatus.watching);
    expect(item.customListIds, {customListId});
    expect(item.download?.selectedEpisodes, {1, 2, 3});
    expect(item.download?.autoDownloadFuture, isTrue);

    await repository.removeStatus(_anime.id);
    item = (await repository.watchLibrary().first).single;
    expect(item.entry, isNull);
    expect(item.customListIds, {customListId});
    expect(item.download, isNotNull);

    await repository.removeDownloadIntent(_anime.id);
    item = (await repository.watchLibrary().first).single;
    expect(item.download, isNull);
    expect(item.customListIds, {customListId});
  });

  test('tracking values are persisted and normalized', () async {
    await repository.setStatus(_anime, AnimeListStatus.planning);
    final started = DateTime(2026, 1, 2);

    await repository.updateTracking(
      animeId: _anime.id,
      progress: 5,
      userScore: 8.5,
      startedAt: started,
      completedAt: null,
      rewatchCount: -2,
      notes: '  weekly watch  ',
    );

    final entry = (await repository.watchLibrary().first).single.entry!;
    expect(entry.progress, 5);
    expect(entry.userScore, 8.5);
    expect(entry.startedAt, started);
    expect(entry.rewatchCount, 0);
    expect(entry.notes, 'weekly watch');
  });
}

const _anime = AppAnime(
  id: 1,
  url: 'https://example.test/anime/1',
  imageUrl: 'https://example.test/cover.jpg',
  title: 'Test: Anime?',
  titleEnglish: 'Test Anime',
  titleSynonyms: [],
  type: 'TV',
  episodes: 12,
  year: 2026,
  airing: true,
  genres: [],
  tags: [],
  rankings: [],
  externalLinks: [],
  streamingEpisodes: [],
  relations: [],
);
