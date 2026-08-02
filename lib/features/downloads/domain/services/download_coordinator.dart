import 'dart:async';
import 'dart:io';

import 'package:nyaa/nyaa.dart';

import '../../../my_list/data/my_list_repository.dart';
import '../../../my_list/domain/models/user_anime.dart';
import '../../data/download_settings_repository.dart';
import '../models/download_models.dart';
import 'download_folder_policy.dart';

typedef DownloadClientFactory =
    DownloadClient Function(DownloadSettings settings);
typedef AiringTimeProvider =
    Future<DateTime?> Function(int animeId, int episode);
typedef EpisodeFileChecker =
    Future<Set<int>> Function(Iterable<String> destinations, int season);

final class DownloadCoordinator {
  DownloadCoordinator({
    required MyListRepository myListRepository,
    required DownloadSettingsRepository settingsRepository,
    required TorrentSearchProvider searchProvider,
    required DownloadClientFactory downloadClientFactory,
    DownloadFolderPolicy folderPolicy = const DownloadFolderPolicy(),
    DateTime Function()? now,
    AiringTimeProvider? airingTimeProvider,
    EpisodeFileChecker? episodeFileChecker,
  }) : _myListRepository = myListRepository,
       _settingsRepository = settingsRepository,
       _searchProvider = searchProvider,
       _downloadClientFactory = downloadClientFactory,
       _folderPolicy = folderPolicy,
       _now = now ?? DateTime.now,
       _airingTimeProvider = airingTimeProvider ?? _noAiringTime,
       _episodeFileChecker = episodeFileChecker ?? _episodesOnDisk;

  final MyListRepository _myListRepository;
  final DownloadSettingsRepository _settingsRepository;
  final TorrentSearchProvider _searchProvider;
  final DownloadClientFactory _downloadClientFactory;
  final DownloadFolderPolicy _folderPolicy;
  final DateTime Function() _now;
  final AiringTimeProvider _airingTimeProvider;
  final EpisodeFileChecker _episodeFileChecker;
  bool _running = false;

  Future<TorrentCandidate?> findPreferredCandidate({
    required SavedAnime anime,
    required DownloadIntent preference,
    required int episode,
    required int season,
  }) async {
    if (preference.releaseGroup == null || preference.quality == null) {
      return null;
    }
    final candidates = await _searchProvider.search(
      TorrentSearchRequest(anime: anime, intent: preference, episode: episode),
    );
    final matches = _preferredMatches(
      candidates,
      preference,
      episode: episode,
      season: season,
    );
    return matches.isEmpty ? null : matches.first;
  }

  Future<void> queuePendingForAnime(
    int animeId, {
    bool reconcile = true,
  }) async {
    final settings = await _settingsRepository.load();
    if (!settings.isConfigured) {
      throw StateError('Configure qBittorrent and download folders first.');
    }
    final item = await _myListRepository.watchAnime(animeId).first;
    final intent = item?.download;
    if (item == null || intent == null || intent.paused) return;
    final client = _downloadClientFactory(settings);
    if (reconcile) {
      await _reconcileSelectedEpisodes(item.anime, intent, client);
    }
    await _process(item.anime, intent, settings, client);
  }

  Future<void> reconcileSelectedEpisodes(int animeId) async {
    final settings = await _settingsRepository.load();
    if (!settings.isConfigured) {
      throw StateError('Configure qBittorrent and download folders first.');
    }
    final item = await _myListRepository.watchAnime(animeId).first;
    final intent = item?.download;
    if (item == null || intent == null) return;
    await _reconcileSelectedEpisodes(
      item.anime,
      intent,
      _downloadClientFactory(settings),
    );
  }

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
    if (requestedEpisode != null &&
        (candidate.season ?? 1) != (item!.download!.season ?? 1)) {
      throw StateError('The selected torrent is for a different season.');
    }
    final coveredEpisodes = await _myListRepository.downloadJobEpisodeCoverage(
      animeId,
    );
    if (requestedEpisode != null &&
        coveredEpisodes.contains(requestedEpisode)) {
      return;
    }
    if (candidate.episodeCoverage.any(coveredEpisodes.contains)) {
      throw StateError(
        'This torrent includes an episode that is already queued.',
      );
    }
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
    var hasQueuedTorrent = false;
    var needsSelection = false;
    final coveredEpisodes = await _myListRepository.downloadJobEpisodeCoverage(
      anime.id,
    );
    for (final episode in episodes) {
      if (episode != null && coveredEpisodes.contains(episode)) {
        hasQueuedTorrent = true;
        continue;
      }
      final candidates = await _searchProvider.search(
        TorrentSearchRequest(anime: anime, intent: intent, episode: episode),
      );
      final relevant = candidates.where((candidate) {
        if (episode == null) return true;
        final requestedSeason = intent.season ?? 1;
        final candidateSeason = candidate.season ?? 1;
        return candidateSeason == requestedSeason &&
            candidate.episodeCoverage.contains(episode);
      }).toList();
      if (intent.releaseGroup == null || intent.quality == null) {
        needsSelection = relevant.isNotEmpty;
        continue;
      }
      final matches =
          _preferredMatches(
                relevant,
                intent,
                episode: episode,
                season: intent.season ?? 1,
              )
              .where(
                (candidate) =>
                    !candidate.episodeCoverage.any(coveredEpisodes.contains),
              )
              .toList();
      if (matches.isEmpty) {
        if (relevant.isNotEmpty) {
          needsSelection = true;
          await _handleAlternative(anime, intent, episode);
        }
        continue;
      }
      final candidate = matches.first;
      if (await _myListRepository.hasDownloadJob(candidate.id)) {
        hasQueuedTorrent = true;
        continue;
      }
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
      hasQueuedTorrent = true;
      coveredEpisodes.addAll(candidate.episodeCoverage);
    }
    await _myListRepository.updateDownloadState(
      anime.id,
      queuedAny || hasQueuedTorrent
          ? DownloadState.queued
          : needsSelection
          ? DownloadState.awaitingSelection
          : DownloadState.awaitingSearch,
      checked: true,
    );
  }

  Future<void> _reconcileSelectedEpisodes(
    SavedAnime anime,
    DownloadIntent intent,
    DownloadClient client,
  ) async {
    if (anime.isMovie || intent.selectedEpisodes.isEmpty) return;
    final jobs = await _myListRepository.loadDownloadJobs(anime.id);
    if (jobs.isEmpty) return;
    final episodesOnDisk = await _episodeFileChecker(
      jobs.map((job) => job.destination).toSet(),
      intent.season ?? 1,
    );
    for (final job in jobs) {
      final selectedCoverage = job.episodes.intersection(
        intent.selectedEpisodes,
      );
      if (selectedCoverage.isEmpty ||
          selectedCoverage.every(episodesOnDisk.contains)) {
        continue;
      }
      final infoHash = job.torrentHash ?? _infoHash(job.source);
      if (infoHash != null && await client.hasTorrent(infoHash)) {
        await client.recheckAndStart(infoHash);
      } else {
        await _myListRepository.deleteDownloadJob(job.id);
      }
    }
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

  List<TorrentCandidate> _preferredMatches(
    Iterable<TorrentCandidate> candidates,
    DownloadIntent preference, {
    required int? episode,
    required int season,
  }) {
    final matchingProfile = candidates.where((candidate) {
      final episodeMatches =
          episode == null || candidate.episodeCoverage.contains(episode);
      return episodeMatches &&
          (candidate.season ?? 1) == season &&
          _same(candidate.releaseGroup, preference.releaseGroup) &&
          _same(candidate.quality, preference.quality);
    });
    final preferredSize = preference.preferredSizeBytes;
    final matchingSize = preferredSize == null || preferredSize <= 0
        ? matchingProfile
        : matchingProfile.where(
            (candidate) =>
                (_episodeSize(candidate) - preferredSize).abs() /
                    preferredSize <=
                0.35,
          );
    return matchingSize.toList()..sort((left, right) {
      if (preferredSize != null && preferredSize > 0) {
        final leftDistance = (_episodeSize(left) - preferredSize).abs();
        final rightDistance = (_episodeSize(right) - preferredSize).abs();
        final sizeOrder = leftDistance.compareTo(rightDistance);
        if (sizeOrder != 0) return sizeOrder;
      }
      final leftSingle = left.episodeCoverage.length <= 1 ? 0 : 1;
      final rightSingle = right.episodeCoverage.length <= 1 ? 0 : 1;
      final singleOrder = leftSingle.compareTo(rightSingle);
      return singleOrder != 0
          ? singleOrder
          : right.seeders.compareTo(left.seeders);
    });
  }

  int _episodeSize(TorrentCandidate candidate) {
    final episodeCount = candidate.episodeCoverage.isEmpty
        ? 1
        : candidate.episodeCoverage.length;
    return candidate.sizeBytes ~/ episodeCount;
  }

  bool _same(String? left, String? right) {
    String normalize(String? value) =>
        value?.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '') ?? '';
    final normalizedRight = normalize(right);
    return normalizedRight.isNotEmpty && normalize(left) == normalizedRight;
  }
}

Future<DateTime?> _noAiringTime(int animeId, int episode) async => null;

String? _infoHash(Uri source) {
  final xt = source.queryParameters['xt'];
  if (xt == null) return null;
  final value = xt.split(':').last.trim();
  return value.isEmpty ? null : value;
}

Future<Set<int>> _episodesOnDisk(
  Iterable<String> destinations,
  int season,
) async {
  final episodes = <int>{};
  const videoExtensions = {'mkv', 'mp4', 'avi', 'm4v', 'webm', 'ts'};
  for (final destination in destinations) {
    final directory = Directory(destination);
    if (!await directory.exists()) continue;
    try {
      await for (final entity in directory.list(recursive: true)) {
        if (entity is! File) continue;
        final fileName = entity.uri.pathSegments.last;
        final extension = fileName.contains('.')
            ? fileName.split('.').last.toLowerCase()
            : '';
        if (!videoExtensions.contains(extension)) continue;
        final parsed = TorrentTitleParser.parse(fileName);
        if ((parsed.season ?? season) == season) {
          episodes.addAll(parsed.episodes);
        }
      }
    } on FileSystemException {
      // A remote or temporarily unavailable download folder is reconciled
      // against qBittorrent below instead.
    }
  }
  return episodes;
}

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
