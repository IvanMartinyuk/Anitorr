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
  const TorrentSearchRequest({required this.anime, required this.intent});

  final SavedAnime anime;
  final DownloadIntent intent;
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
  });

  final String id;
  final String name;
  final Uri uri;
  final int sizeBytes;
  final Set<int> episodeCoverage;
  final String? infoHash;
  final String? quality;
  final String? releaseGroup;
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

final class AddTorrentRequest {
  const AddTorrentRequest({
    required this.source,
    required this.savePath,
    required this.tag,
    this.category = 'anitorr',
    this.paused = false,
  });

  final Uri source;
  final String savePath;
  final String tag;
  final String category;
  final bool paused;
}

abstract interface class DownloadClient {
  Future<QBittorrentConnectionInfo> testConnection();

  Future<void> addTorrent(AddTorrentRequest request);
}
