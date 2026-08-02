import 'package:http/http.dart' as http;

import '../domain/models/download_models.dart';

final class QBittorrentClient implements DownloadClient {
  QBittorrentClient({
    required String endpoint,
    required String apiKey,
    http.Client? httpClient,
  }) : _endpoint = Uri.parse(endpoint.endsWith('/') ? endpoint : '$endpoint/'),
       _apiKey = apiKey,
       _httpClient = httpClient ?? http.Client();

  final Uri _endpoint;
  final String _apiKey;
  final http.Client _httpClient;

  @override
  Future<QBittorrentConnectionInfo> testConnection() async {
    final responses = await Future.wait([
      _get('api/v2/app/version'),
      _get('api/v2/app/webapiVersion'),
    ]);
    final appVersion = responses[0].body.trim();
    final webApiVersion = responses[1].body.trim();
    if (!_isSupportedVersion(appVersion)) {
      throw QBittorrentException(
        'qBittorrent 5.2 or newer is required. Server reports $appVersion.',
      );
    }
    return QBittorrentConnectionInfo(
      applicationVersion: appVersion,
      webApiVersion: webApiVersion,
    );
  }

  @override
  Future<void> addTorrent(AddTorrentRequest request) async {
    final operation =
        http.MultipartRequest('POST', _endpoint.resolve('api/v2/torrents/add'))
          ..headers.addAll(_headers)
          ..fields.addAll({
            'savepath': request.savePath,
            'category': request.category,
            'tags': request.tag,
            'paused': request.paused.toString(),
            'root_folder': 'true',
          });
    switch (request.source) {
      case TorrentUriSource(:final uri):
        operation.fields['urls'] = uri.toString();
      case TorrentFileSource(:final bytes, :final fileName):
        operation.files.add(
          http.MultipartFile.fromBytes('torrents', bytes, filename: fileName),
        );
    }
    final response = await _httpClient.send(operation);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw QBittorrentException(
        'qBittorrent rejected the torrent (${response.statusCode}).',
      );
    }
  }

  @override
  Future<bool> hasTorrent(String infoHash) async {
    final uri = _endpoint
        .resolve('api/v2/torrents/info')
        .replace(queryParameters: {'hashes': infoHash});
    final response = await _httpClient.get(uri, headers: _headers);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw QBittorrentException(
        'Could not inspect qBittorrent (${response.statusCode}).',
      );
    }
    final body = response.body.trim();
    return body.isNotEmpty && body != '[]';
  }

  @override
  Future<void> recheckAndStart(String infoHash) async {
    await _postTorrentAction('api/v2/torrents/recheck', infoHash);
    await _postTorrentAction('api/v2/torrents/start', infoHash);
  }

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $_apiKey',
    'Accept': 'application/json',
  };

  Future<http.Response> _get(String path) async {
    final response = await _httpClient.get(
      _endpoint.resolve(path),
      headers: _headers,
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw QBittorrentException(
        'Could not connect to qBittorrent (${response.statusCode}).',
      );
    }
    return response;
  }

  Future<void> _postTorrentAction(String path, String infoHash) async {
    final response = await _httpClient.post(
      _endpoint.resolve(path),
      headers: {
        ..._headers,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'hashes': infoHash},
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw QBittorrentException(
        'qBittorrent could not restart the torrent (${response.statusCode}).',
      );
    }
  }

  bool _isSupportedVersion(String value) {
    final match = RegExp(r'(\d+)\.(\d+)').firstMatch(value);
    if (match == null) {
      return false;
    }
    final major = int.parse(match.group(1)!);
    final minor = int.parse(match.group(2)!);
    return major > 5 || major == 5 && minor >= 2;
  }
}

final class QBittorrentException implements Exception {
  const QBittorrentException(this.message);

  final String message;

  @override
  String toString() => message;
}
