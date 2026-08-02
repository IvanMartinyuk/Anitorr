import '../../../my_list/domain/models/user_anime.dart';

final class DownloadSettings {
  const DownloadSettings({
    this.endpoint = '',
    this.apiKey = '',
    this.seriesRoot = '',
    this.moviesRoot = '',
    this.checkIntervalMinutes = 30,
    this.startAtLogin = false,
  });

  final String endpoint;
  final String apiKey;
  final String seriesRoot;
  final String moviesRoot;
  final int checkIntervalMinutes;
  final bool startAtLogin;

  bool get isConfigured =>
      endpoint.trim().isNotEmpty &&
      apiKey.trim().isNotEmpty &&
      seriesRoot.trim().isNotEmpty &&
      moviesRoot.trim().isNotEmpty;
}

final class TorrentSearchRequest {
  const TorrentSearchRequest({
    required this.anime,
    required this.intent,
    this.episode,
  });

  final SavedAnime anime;
  final DownloadIntent intent;
  final int? episode;
}

final class TorrentCandidate {
  const TorrentCandidate({
    required this.id,
    required this.name,
    required this.uri,
    required this.sizeBytes,
    required this.episodeCoverage,
    this.infoHash,
    this.quality,
    this.releaseGroup,
    this.torrentUri,
    this.uploadedAt,
    this.seeders = 0,
    this.leechers = 0,
    this.category = '0_0',
    this.season,
  });

  final String id;
  final String name;
  final Uri uri;
  final int sizeBytes;
  final Set<int> episodeCoverage;
  final String? infoHash;
  final String? quality;
  final String? releaseGroup;
  final Uri? torrentUri;
  final DateTime? uploadedAt;
  final int seeders;
  final int leechers;
  final String category;
  final int? season;
}

abstract interface class TorrentSearchProvider {
  Future<List<TorrentCandidate>> search(TorrentSearchRequest request);
}

final class UnavailableTorrentSearchProvider implements TorrentSearchProvider {
  const UnavailableTorrentSearchProvider();

  @override
  Future<List<TorrentCandidate>> search(TorrentSearchRequest request) async {
    return const [];
  }
}

final class QBittorrentConnectionInfo {
  const QBittorrentConnectionInfo({
    required this.applicationVersion,
    required this.webApiVersion,
  });

  final String applicationVersion;
  final String webApiVersion;
}

sealed class TorrentSource {
  const TorrentSource();
}

final class TorrentUriSource extends TorrentSource {
  const TorrentUriSource(this.uri);
  final Uri uri;
}

final class TorrentFileSource extends TorrentSource {
  const TorrentFileSource({required this.bytes, required this.fileName});
  final List<int> bytes;
  final String fileName;
}

final class AddTorrentRequest {
  const AddTorrentRequest({
    required this.source,
    required this.savePath,
    required this.tag,
    this.category = 'anitorr',
    this.paused = false,
  });

  final TorrentSource source;
  final String savePath;
  final String tag;
  final String category;
  final bool paused;
}

abstract interface class DownloadClient {
  Future<QBittorrentConnectionInfo> testConnection();

  Future<void> addTorrent(AddTorrentRequest request);

  Future<bool> hasTorrent(String infoHash);

  Future<void> recheckAndStart(String infoHash);
}
