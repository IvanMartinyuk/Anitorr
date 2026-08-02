import 'dart:async';

import '../../../my_list/data/my_list_repository.dart';
import '../../../my_list/domain/models/user_anime.dart';
import '../../data/download_settings_repository.dart';
import '../models/download_models.dart';
import 'download_folder_policy.dart';

typedef DownloadClientFactory =
    DownloadClient Function(DownloadSettings settings);
typedef AiringTimeProvider =
    Future<DateTime?> Function(int animeId, int episode);

final class DownloadCoordinator {
  DownloadCoordinator({
    required MyListRepository myListRepository,
    required DownloadSettingsRepository settingsRepository,
    required TorrentSearchProvider searchProvider,
    required DownloadClientFactory downloadClientFactory,
    DownloadFolderPolicy folderPolicy = const DownloadFolderPolicy(),
    DateTime Function()? now,
    AiringTimeProvider? airingTimeProvider,
  }) : _myListRepository = myListRepository,
       _settingsRepository = settingsRepository,
       _searchProvider = searchProvider,
       _downloadClientFactory = downloadClientFactory,
       _folderPolicy = folderPolicy,
       _now = now ?? DateTime.now,
       _airingTimeProvider = airingTimeProvider ?? _noAiringTime;

  final MyListRepository _myListRepository;
  final DownloadSettingsRepository _settingsRepository;
  final TorrentSearchProvider _searchProvider;
  final DownloadClientFactory _downloadClientFactory;
  final DownloadFolderPolicy _folderPolicy;
  final DateTime Function() _now;
  final AiringTimeProvider _airingTimeProvider;
  bool _running = false;

  Future<void> queueSelected(
    int animeId,
    TorrentCandidate candidate, {
    int? requestedEpisode,
  }) async {
    if (requestedEpisode != null &&
        !candidate.episodeCoverage.contains(requestedEpisode)) {
      throw StateError(
        'The selected torrent does not contain episode $requestedEpisode.',
      );
    }
    if (await _myListRepository.hasDownloadJob(candidate.id)) return;
    final settings = await _settingsRepository.load();
    if (!settings.isConfigured) {
      throw StateError('Configure qBittorrent and download folders first.');
    }
    final item = await _myListRepository.watchAnime(animeId).first;
    if (item?.download == null) return;
    final destination = _folderPolicy.destinationFor(
      item!.anime,
      settings,
      intent: item.download,
    );
    await _downloadClientFactory(settings).addTorrent(
      AddTorrentRequest(
        source: TorrentUriSource(candidate.uri),
        savePath: destination,
        tag: 'anitorr-$animeId',
      ),
    );
    await _myListRepository.saveDownloadJob(
      animeId: animeId,
      sourceId: candidate.id,
      source: candidate.uri,
      episodes: candidate.episodeCoverage,
      destination: destination,
      torrentHash: candidate.infoHash,
    );
    await _myListRepository.updateDownloadState(animeId, DownloadState.queued);
  }

  Future<void> checkNow() async {
    if (_running) return;
    _running = true;
    try {
      final settings = await _settingsRepository.load();
      if (!settings.isConfigured) return;
      final client = _downloadClientFactory(settings);
      final library = await _myListRepository.watchLibrary().first;
      for (final item in library) {
        final intent = item.download;
        if (intent == null || intent.paused) continue;
        try {
          await _process(item.anime, intent, settings, client);
        } catch (error) {
          await _myListRepository.updateDownloadState(
            item.anime.id,
            DownloadState.error,
            errorMessage: '$error',
            checked: true,
          );
        }
      }
    } finally {
      _running = false;
    }
  }

  Future<void> _process(
    SavedAnime anime,
    DownloadIntent intent,
    DownloadSettings settings,
    DownloadClient client,
  ) async {
    final episodes = anime.isMovie
        ? <int?>[null]
        : (intent.selectedEpisodes.toList()..sort()).cast<int?>();
    var queuedAny = false;
    var needsSelection = false;
    for (final episode in episodes) {
      final candidates = await _searchProvider.search(
        TorrentSearchRequest(anime: anime, intent: intent, episode: episode),
      );
      final relevant = candidates.where((candidate) {
        return episode == null || candidate.episodeCoverage.contains(episode);
      }).toList();
      if (intent.releaseGroup == null || intent.quality == null) {
        needsSelection = relevant.isNotEmpty;
        continue;
      }
      final matches =
          relevant.where((candidate) {
            return _same(candidate.releaseGroup, intent.releaseGroup) &&
                _same(candidate.quality, intent.quality);
          }).toList()..sort((left, right) {
            final leftSingle = left.episodeCoverage.length <= 1 ? 0 : 1;
            final rightSingle = right.episodeCoverage.length <= 1 ? 0 : 1;
            final singleOrder = leftSingle.compareTo(rightSingle);
            return singleOrder != 0
                ? singleOrder
                : right.seeders.compareTo(left.seeders);
          });
      if (matches.isEmpty) {
        if (relevant.isNotEmpty) {
          needsSelection = true;
          await _handleAlternative(anime, intent, episode);
        }
        continue;
      }
      final candidate = matches.first;
      if (await _myListRepository.hasDownloadJob(candidate.id)) continue;
      final destination = _folderPolicy.destinationFor(
        anime,
        settings,
        intent: intent,
      );
      await client.addTorrent(
        AddTorrentRequest(
          source: TorrentUriSource(candidate.uri),
          savePath: destination,
          tag: 'anitorr-${anime.id}',
        ),
      );
      await _myListRepository.saveDownloadJob(
        animeId: anime.id,
        sourceId: candidate.id,
        source: candidate.uri,
        episodes: candidate.episodeCoverage,
        destination: destination,
        torrentHash: candidate.infoHash,
      );
      queuedAny = true;
    }
    await _myListRepository.updateDownloadState(
      anime.id,
      queuedAny
          ? DownloadState.queued
          : needsSelection
          ? DownloadState.awaitingSelection
          : DownloadState.awaitingSearch,
      checked: true,
    );
  }

  Future<void> _handleAlternative(
    SavedAnime anime,
    DownloadIntent intent,
    int? episode,
  ) async {
    if (episode != null) {
      final airingAt = await _airingTimeProvider(anime.id, episode);
      if (airingAt != null) {
        if (_now().isBefore(airingAt.add(const Duration(hours: 4)))) return;
        await _createPublisherAlert(anime, intent, episode);
        return;
      }
    }
    final firstSeen = intent.alternativeFirstSeenAt;
    if (firstSeen == null) {
      await _myListRepository.rememberAlternativeSeen(anime.id, _now());
      return;
    }
    if (_now().difference(firstSeen) < const Duration(hours: 4)) return;
    await _createPublisherAlert(anime, intent, episode);
  }

  Future<void> _createPublisherAlert(
    SavedAnime anime,
    DownloadIntent intent,
    int? episode,
  ) {
    return _myListRepository.createDownloadAlert(
      animeId: anime.id,
      episode: episode,
      message:
          '${intent.releaseGroup} ${intent.quality} is unavailable for '
          '${anime.title}${episode == null ? '' : ' episode $episode'}.',
    );
  }

  bool _same(String? left, String? right) =>
      left?.trim().toLowerCase() == right?.trim().toLowerCase();
}

Future<DateTime?> _noAiringTime(int animeId, int episode) async => null;

final class DownloadScheduler {
  DownloadScheduler(this._coordinator);
  final DownloadCoordinator _coordinator;
  Timer? _timer;

  void start(Duration interval) {
    _timer?.cancel();
    unawaited(_coordinator.checkNow());
    _timer = Timer.periodic(interval, (_) {
      unawaited(_coordinator.checkNow());
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
