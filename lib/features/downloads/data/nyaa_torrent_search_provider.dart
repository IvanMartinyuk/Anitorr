import 'package:nyaa/nyaa.dart';

import '../domain/models/download_models.dart';

final class NyaaTorrentSearchProvider implements TorrentSearchProvider {
  NyaaTorrentSearchProvider(this._client);

  final NyaaClient _client;

  @override
  Future<List<TorrentCandidate>> search(TorrentSearchRequest request) async {
    final title = request.anime.titleEnglish ?? request.anime.title;
    final page = await _client.search(
      NyaaSearchRequest(
        query: title,
        category: NyaaCategory.fromCode(request.intent.category),
      ),
    );
    return [for (final item in page.items) _candidate(item)];
  }

  TorrentCandidate _candidate(NyaaTorrent item) {
    final parsed = TorrentTitleParser.parse(item.name);
    return TorrentCandidate(
      id: item.id.toString(),
      name: item.name,
      uri: item.magnetUri,
      torrentUri: item.torrentUri,
      sizeBytes: item.sizeBytes,
      episodeCoverage: parsed.episodes,
      infoHash: item.magnetUri.queryParameters['xt']?.split(':').last,
      quality: parsed.resolution,
      releaseGroup: parsed.publisher,
      uploadedAt: item.uploadedAt,
      seeders: item.seeders,
      leechers: item.leechers,
      category: item.category.code,
    );
  }
}
