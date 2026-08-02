import 'package:anitorr/features/downloads/data/qbittorrent_client.dart';
import 'package:anitorr/features/downloads/domain/models/download_models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

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

  test('finds, rechecks, and starts an existing torrent', () async {
    final requests = <http.Request>[];
    final client = QBittorrentClient(
      endpoint: 'http://localhost:8080',
      apiKey: 'secret',
      httpClient: MockClient((request) async {
        requests.add(request);
        return http.Response(
          request.url.path.endsWith('/info') ? '[{"hash":"abc"}]' : '',
          200,
        );
      }),
    );

    expect(await client.hasTorrent('abc'), isTrue);
    await client.recheckAndStart('abc');

    expect(requests.map((request) => request.url.path), [
      '/api/v2/torrents/info',
      '/api/v2/torrents/recheck',
      '/api/v2/torrents/start',
    ]);
    expect(requests.first.url.queryParameters['hashes'], 'abc');
    expect(requests[1].bodyFields['hashes'], 'abc');
    expect(requests[2].bodyFields['hashes'], 'abc');
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
