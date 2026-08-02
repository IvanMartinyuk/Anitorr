import 'dart:ffi';
import 'dart:io';

import 'package:anitorr/features/downloads/data/download_settings_repository.dart';
import 'package:anitorr/features/downloads/domain/models/download_models.dart';
import 'package:anitorr/features/downloads/domain/services/download_coordinator.dart';
import 'package:anitorr/features/my_list/data/app_database.dart';
import 'package:anitorr/features/my_list/data/my_list_repository.dart';
import 'package:anitorr/features/my_list/domain/models/user_anime.dart';
import 'package:anitorr/shared/models/app_anime.dart';
import 'package:drift/native.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/open.dart';

void main() {
  late AppDatabase database;
  late MyListRepository myListRepository;
  late DownloadSettingsRepository settingsRepository;

  setUpAll(() {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('libsqlite3.so.0'),
    );
  });

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
    database = AppDatabase.forTesting(NativeDatabase.memory());
    myListRepository = MyListRepository(database);
    settingsRepository = DownloadSettingsRepository(database);
    await settingsRepository.save(
      const DownloadSettings(
        endpoint: 'http://localhost:8080',
        apiKey: 'secret',
        seriesRoot: '/downloads/series',
        moviesRoot: '/downloads/movies',
      ),
    );
  });

  tearDown(() => database.close());

  test(
    'queues every selected episode with the saved release profile',
    () async {
      await myListRepository.saveDownloadIntent(
        anime: _anime,
        selectedEpisodes: const {4, 5, 6},
        allAvailableEpisodes: false,
        autoDownloadFuture: true,
        releaseGroup: 'Erai-raws',
        quality: '1080p',
        season: 3,
        seriesTitle: 'Test Anime',
      );
      final search = _EpisodeSearchProvider();
      final client = _RecordingDownloadClient();
      final coordinator = DownloadCoordinator(
        myListRepository: myListRepository,
        settingsRepository: settingsRepository,
        searchProvider: search,
        downloadClientFactory: (_) => client,
      );

      await coordinator.queuePendingForAnime(_anime.id);

      expect(search.episodes, [4, 5, 6]);
      expect(client.requests, hasLength(3));
      expect(
        client.requests.map(
          (request) => (request.source as TorrentUriSource).uri,
        ),
        [
          Uri.parse('magnet:?xt=urn:btih:episode4'),
          Uri.parse('magnet:?xt=urn:btih:episode5'),
          Uri.parse('magnet:?xt=urn:btih:episode6'),
        ],
      );
      final item = (await myListRepository.watchLibrary().first).single;
      expect(item.download?.state, DownloadState.queued);
    },
  );

  test('does not send an episode already covered by another torrent', () async {
    await myListRepository.saveDownloadIntent(
      anime: _anime,
      selectedEpisodes: const {4, 5, 6},
      allAvailableEpisodes: false,
      autoDownloadFuture: true,
      releaseGroup: 'Erai-raws',
      quality: '1080p',
      season: 3,
      seriesTitle: 'Test Anime',
    );
    await myListRepository.saveDownloadJob(
      animeId: _anime.id,
      sourceId: 'different-torrent-for-episode-5',
      source: Uri.parse('magnet:?xt=urn:btih:existing'),
      episodes: const {5},
      destination: '/downloads/series/Test Anime/Season 03',
    );
    final search = _EpisodeSearchProvider();
    final client = _RecordingDownloadClient();
    final coordinator = DownloadCoordinator(
      myListRepository: myListRepository,
      settingsRepository: settingsRepository,
      searchProvider: search,
      downloadClientFactory: (_) => client,
      episodeFileChecker: (_, _) async => {5},
    );

    await coordinator.queuePendingForAnime(_anime.id);

    expect(search.episodes, [4, 6]);
    expect(client.requests, hasLength(2));
    expect(
      client.requests.map(
        (request) => (request.source as TorrentUriSource).uri,
      ),
      [
        Uri.parse('magnet:?xt=urn:btih:episode4'),
        Uri.parse('magnet:?xt=urn:btih:episode6'),
      ],
    );
  });

  test('rechecks and starts a torrent whose episode file is missing', () async {
    await myListRepository.saveDownloadIntent(
      anime: _anime,
      selectedEpisodes: const {5},
      allAvailableEpisodes: false,
      autoDownloadFuture: false,
      releaseGroup: 'Erai-raws',
      quality: '1080p',
      season: 3,
    );
    await myListRepository.saveDownloadJob(
      animeId: _anime.id,
      sourceId: 'existing-episode-5',
      source: Uri.parse('magnet:?xt=urn:btih:existing'),
      episodes: const {5},
      destination: '/downloads/series/Test Anime/Season 03',
      torrentHash: 'existing',
    );
    final search = _EpisodeSearchProvider();
    final client = _RecordingDownloadClient()..existingHashes.add('existing');
    final coordinator = DownloadCoordinator(
      myListRepository: myListRepository,
      settingsRepository: settingsRepository,
      searchProvider: search,
      downloadClientFactory: (_) => client,
      episodeFileChecker: (_, _) async => {},
    );

    await coordinator.queuePendingForAnime(_anime.id);

    expect(client.restartedHashes, ['existing']);
    expect(client.requests, isEmpty);
    expect(search.episodes, isEmpty);
  });

  test('keeps a download job when its episode exists on disk', () async {
    final destination = await Directory.systemTemp.createTemp(
      'anitorr-download-check-',
    );
    addTearDown(() => destination.delete(recursive: true));
    await File(
      '${destination.path}/[Erai-raws] Test Anime S03E05 [1080p].mkv',
    ).writeAsString('video');
    await myListRepository.saveDownloadIntent(
      anime: _anime,
      selectedEpisodes: const {5},
      allAvailableEpisodes: false,
      autoDownloadFuture: false,
      releaseGroup: 'Erai-raws',
      quality: '1080p',
      season: 3,
    );
    await myListRepository.saveDownloadJob(
      animeId: _anime.id,
      sourceId: 'episode-5-on-disk',
      source: Uri.parse('magnet:?xt=urn:btih:ondisk'),
      episodes: const {5},
      destination: destination.path,
      torrentHash: 'ondisk',
    );
    final search = _EpisodeSearchProvider();
    final client = _RecordingDownloadClient();
    final coordinator = DownloadCoordinator(
      myListRepository: myListRepository,
      settingsRepository: settingsRepository,
      searchProvider: search,
      downloadClientFactory: (_) => client,
    );

    await coordinator.queuePendingForAnime(_anime.id);

    expect(client.inspectedHashes, isEmpty);
    expect(client.requests, isEmpty);
    expect(search.episodes, isEmpty);
  });

  test('requeues a missing file when qBittorrent lost its torrent', () async {
    await myListRepository.saveDownloadIntent(
      anime: _anime,
      selectedEpisodes: const {5},
      allAvailableEpisodes: false,
      autoDownloadFuture: false,
      releaseGroup: 'Erai-raws',
      quality: '1080p',
      season: 3,
    );
    await myListRepository.saveDownloadJob(
      animeId: _anime.id,
      sourceId: 'stale-episode-5',
      source: Uri.parse('magnet:?xt=urn:btih:stale'),
      episodes: const {5},
      destination: '/downloads/series/Test Anime/Season 03',
      torrentHash: 'stale',
    );
    final search = _EpisodeSearchProvider();
    final client = _RecordingDownloadClient();
    final coordinator = DownloadCoordinator(
      myListRepository: myListRepository,
      settingsRepository: settingsRepository,
      searchProvider: search,
      downloadClientFactory: (_) => client,
      episodeFileChecker: (_, _) async => {},
    );

    await coordinator.queuePendingForAnime(_anime.id);

    expect(search.episodes, [5]);
    expect(client.requests, hasLength(1));
  });

  test('prefers the 1080p release closest to the saved file size', () async {
    await myListRepository.saveDownloadIntent(
      anime: _anime,
      selectedEpisodes: const {5},
      allAvailableEpisodes: false,
      autoDownloadFuture: false,
      releaseGroup: 'Erai-raws',
      quality: '1080p',
      season: 3,
      preferredSizeBytes: 1000,
    );
    final preference =
        (await myListRepository.watchLibrary().first).single.download!;
    final coordinator = DownloadCoordinator(
      myListRepository: myListRepository,
      settingsRepository: settingsRepository,
      searchProvider: _SizedSearchProvider(),
      downloadClientFactory: (_) => _RecordingDownloadClient(),
    );

    final candidate = await coordinator.findPreferredCandidate(
      anime: SavedAnime.fromAppAnime(_anime),
      preference: preference,
      episode: 5,
      season: 3,
    );

    expect(candidate?.id, 'similar-size');
  });
}

final class _EpisodeSearchProvider implements TorrentSearchProvider {
  final episodes = <int>[];

  @override
  Future<List<TorrentCandidate>> search(TorrentSearchRequest request) async {
    final episode = request.episode!;
    episodes.add(episode);
    return [
      TorrentCandidate(
        id: 'episode-$episode',
        name: '[Erai-raws] Test Anime - $episode [1080p]',
        uri: Uri.parse('magnet:?xt=urn:btih:episode$episode'),
        sizeBytes: 1,
        episodeCoverage: {episode},
        releaseGroup: 'Erai raws',
        quality: '1080p',
        season: 3,
        seeders: 10,
      ),
    ];
  }
}

final class _RecordingDownloadClient implements DownloadClient {
  final requests = <AddTorrentRequest>[];
  final existingHashes = <String>{};
  final inspectedHashes = <String>[];
  final restartedHashes = <String>[];

  @override
  Future<void> addTorrent(AddTorrentRequest request) async {
    requests.add(request);
  }

  @override
  Future<bool> hasTorrent(String infoHash) async {
    inspectedHashes.add(infoHash);
    return existingHashes.contains(infoHash);
  }

  @override
  Future<void> recheckAndStart(String infoHash) async {
    restartedHashes.add(infoHash);
  }

  @override
  Future<QBittorrentConnectionInfo> testConnection() async {
    return const QBittorrentConnectionInfo(
      applicationVersion: 'test',
      webApiVersion: 'test',
    );
  }
}

final class _SizedSearchProvider implements TorrentSearchProvider {
  @override
  Future<List<TorrentCandidate>> search(TorrentSearchRequest request) async {
    TorrentCandidate candidate(String id, int size) => TorrentCandidate(
      id: id,
      name: id,
      uri: Uri.parse('magnet:?xt=urn:btih:$id'),
      sizeBytes: size,
      episodeCoverage: const {5},
      releaseGroup: 'Erai-raws',
      quality: '1080p',
      season: 3,
      seeders: 10,
    );

    return [candidate('small-encode', 500), candidate('similar-size', 1050)];
  }
}

const _anime = AppAnime(
  id: 1,
  url: '',
  imageUrl: '',
  title: 'Test Anime Season 3',
  titleEnglish: 'Test Anime Season 3',
  titleSynonyms: [],
  type: 'TV',
  episodes: 12,
  airing: true,
  genres: [],
  tags: [],
  rankings: [],
  externalLinks: [],
  streamingEpisodes: [],
  relations: [],
);
