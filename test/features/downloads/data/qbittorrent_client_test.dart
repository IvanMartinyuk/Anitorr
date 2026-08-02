import 'package:anitorr/features/downloads/data/qbittorrent_client.dart';
import 'package:anitorr/features/downloads/domain/models/download_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  test('sends magnet sources through the urls field', () async {
    final httpClient = _RecordingClient();
    final client = QBittorrentClient(
      endpoint: 'http://localhost:8080',
      apiKey: 'secret',
      httpClient: httpClient,
    );

    await client.addTorrent(
      AddTorrentRequest(
        source: TorrentUriSource(Uri.parse('magnet:?xt=urn:btih:abc')),
        savePath: '/anime/Show/Season 01',
        tag: 'anitorr-1',
      ),
    );

    final captured = httpClient.request! as http.MultipartRequest;
    expect(captured.fields['urls'], 'magnet:?xt=urn:btih:abc');
    expect(captured.files, isEmpty);
  });

  test('uploads local torrent bytes as multipart data', () async {
    final httpClient = _RecordingClient();
    final client = QBittorrentClient(
      endpoint: 'http://localhost:8080',
      apiKey: 'secret',
      httpClient: httpClient,
    );

    await client.addTorrent(
      const AddTorrentRequest(
        source: TorrentFileSource(bytes: [1, 2, 3], fileName: 'show.torrent'),
        savePath: '/anime/Show/Season 01',
        tag: 'anitorr-1',
      ),
    );

    final captured = httpClient.request! as http.MultipartRequest;
    expect(captured.fields.containsKey('urls'), isFalse);
    expect(captured.files.single.filename, 'show.torrent');
  });
}

final class _RecordingClient extends http.BaseClient {
  http.BaseRequest? request;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    this.request = request;
    return http.StreamedResponse(const Stream.empty(), 200);
  }
}
