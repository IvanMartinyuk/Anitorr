import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;

import 'nyaa_models.dart';

final class NyaaClient {
  NyaaClient({http.Client? httpClient, Uri? baseUri})
    : _httpClient = httpClient ?? http.Client(),
      _baseUri = baseUri ?? Uri.parse('https://nyaa.si/');

  final http.Client _httpClient;
  final Uri _baseUri;

  Future<NyaaSearchPage> search(NyaaSearchRequest request) async {
    final uri = _baseUri.replace(
      queryParameters: {
        'f': request.filter.code.toString(),
        'c': request.category.code,
        'q': request.query.trim(),
        if (request.page > 1) 'p': request.page.toString(),
      },
    );
    final response = await _get(uri);
    return parseSearchHtml(response.body, baseUri: _baseUri);
  }

  Future<NyaaTorrentDetails> getTorrentDetails(int id) async {
    final response = await _get(_baseUri.resolve('view/$id'));
    return parseDetailsHtml(response.body, baseUri: _baseUri);
  }

  Future<http.Response> _get(Uri uri) async {
    final response = await _httpClient.get(
      uri,
      headers: const {'Accept': 'text/html', 'User-Agent': 'Anitorr/0.0.1'},
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw NyaaHttpException(
        'Nyaa returned HTTP ${response.statusCode}.',
        response.statusCode,
      );
    }
    return response;
  }

  static NyaaSearchPage parseSearchHtml(String html, {required Uri baseUri}) {
    final document = html_parser.parse(html);
    final items = <NyaaTorrent>[];
    for (final row in document.querySelectorAll(
      'table.torrent-list tbody tr',
    )) {
      final cells = row.children
          .where((node) => node.localName == 'td')
          .toList();
      if (cells.length < 8) continue;
      final detailsLinks = row.querySelectorAll('a[href^="/view/"]');
      final detailsLink = detailsLinks
          .where((link) => !link.classes.contains('comments'))
          .firstOrNull;
      final torrentLink = row.querySelector('a[href^="/download/"]');
      final magnetLink = row.querySelector('a[href^="magnet:"]');
      if (detailsLink == null || torrentLink == null || magnetLink == null) {
        continue;
      }
      final detailsHref = detailsLink.attributes['href']!;
      final id = int.tryParse(
        RegExp(r'/view/(\d+)').firstMatch(detailsHref)?.group(1) ?? '',
      );
      if (id == null) continue;
      final categoryHref =
          cells.first.querySelector('a')?.attributes['href'] ?? '';
      final categoryCode =
          RegExp(r'c=(\d+_\d+)').firstMatch(categoryHref)?.group(1) ?? '0_0';
      final timestamp = int.tryParse(
        cells[4].attributes['data-timestamp'] ?? '',
      );
      final title = detailsLink.attributes['title']?.trim();
      items.add(
        NyaaTorrent(
          id: id,
          category: NyaaCategory.fromCode(categoryCode),
          name: title?.isNotEmpty == true ? title! : detailsLink.text.trim(),
          detailsUri: baseUri.resolve(detailsHref),
          torrentUri: baseUri.resolve(torrentLink.attributes['href']!),
          magnetUri: Uri.parse(magnetLink.attributes['href']!),
          sizeBytes: parseSize(cells[3].text),
          uploadedAt: timestamp == null
              ? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)
              : DateTime.fromMillisecondsSinceEpoch(
                  timestamp * 1000,
                  isUtc: true,
                ),
          seeders: int.tryParse(cells[5].text.trim()) ?? 0,
          leechers: int.tryParse(cells[6].text.trim()) ?? 0,
          completedDownloads: int.tryParse(cells[7].text.trim()) ?? 0,
          status: row.classes.contains('success')
              ? NyaaTorrentStatus.trusted
              : row.classes.contains('danger')
              ? NyaaTorrentStatus.remake
              : NyaaTorrentStatus.normal,
        ),
      );
    }
    final pageInfo =
        document.querySelector('.pagination-page-info')?.text ?? '';
    final total = int.tryParse(
      RegExp(
            r'out of ([\d,]+)',
          ).firstMatch(pageInfo)?.group(1)?.replaceAll(',', '') ??
          '',
    );
    return NyaaSearchPage(items: items, totalResults: total);
  }

  static NyaaTorrentDetails parseDetailsHtml(
    String html, {
    required Uri baseUri,
  }) {
    final document = html_parser.parse(html);
    final title = document.querySelector('.panel-title')?.text.trim();
    final torrentLink = document.querySelector(
      '.panel-footer a[href^="/download/"]',
    );
    final magnetLink = document.querySelector(
      '.panel-footer a[href^="magnet:"]',
    );
    final id = int.tryParse(
      RegExp(
            r'/download/(\d+)',
          ).firstMatch(torrentLink?.attributes['href'] ?? '')?.group(1) ??
          '',
    );
    if (title == null ||
        torrentLink == null ||
        magnetLink == null ||
        id == null) {
      throw const NyaaParseException(
        'The Nyaa torrent page is missing required fields.',
      );
    }

    String valueAfter(String label) {
      for (final row in document.querySelectorAll('.panel-body .row')) {
        final cells = row.children
            .where((node) => node.localName == 'div')
            .toList();
        for (var index = 0; index + 1 < cells.length; index += 2) {
          if (cells[index].text.trim().startsWith(label)) {
            return cells[index + 1].text.trim();
          }
        }
      }
      return '';
    }

    final timestampNode = document.querySelector('[data-timestamp]');
    final timestamp = int.tryParse(
      timestampNode?.attributes['data-timestamp'] ?? '',
    );
    final categoryLinks = document.querySelectorAll(
      '.panel-body a[href^="/?c="]',
    );
    final categoryCode = categoryLinks.isEmpty
        ? '0_0'
        : RegExp(r'c=(\d+_\d+)')
                  .firstMatch(categoryLinks.last.attributes['href'] ?? '')
                  ?.group(1) ??
              '0_0';
    final files = document
        .querySelectorAll('.torrent-file-list li')
        .map((node) {
          final sizeNode = node.querySelector('.file-size');
          final size = sizeNode?.text.replaceAll(RegExp(r'[()]'), '') ?? '';
          final path = node.text.replaceFirst(sizeNode?.text ?? '', '').trim();
          return NyaaTorrentFile(path: path, sizeBytes: parseSize(size));
        })
        .toList(growable: false);
    final torrent = NyaaTorrent(
      id: id,
      category: NyaaCategory.fromCode(categoryCode),
      name: title,
      detailsUri: baseUri.resolve('view/$id'),
      torrentUri: baseUri.resolve(torrentLink.attributes['href']!),
      magnetUri: Uri.parse(magnetLink.attributes['href']!),
      sizeBytes: parseSize(valueAfter('File size:')),
      uploadedAt: timestamp == null
          ? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true)
          : DateTime.fromMillisecondsSinceEpoch(timestamp * 1000, isUtc: true),
      seeders: int.tryParse(valueAfter('Seeders:')) ?? 0,
      leechers: int.tryParse(valueAfter('Leechers:')) ?? 0,
      completedDownloads: int.tryParse(valueAfter('Completed:')) ?? 0,
      status: NyaaTorrentStatus.normal,
    );
    return NyaaTorrentDetails(
      torrent: torrent,
      files: files,
      submitter: valueAfter('Submitter:'),
      description: document.querySelector('#torrent-description')?.text.trim(),
      infoHash: document.querySelector('kbd')?.text.trim(),
    );
  }

  static int parseSize(String input) {
    final match = RegExp(
      r'([\d.]+)\s*([KMGT]?i?B)',
      caseSensitive: false,
    ).firstMatch(input.trim());
    if (match == null) return 0;
    final value = double.parse(match.group(1)!);
    final unit = match.group(2)!.toUpperCase();
    final multiplier = switch (unit) {
      'KIB' => 1024,
      'MIB' => 1024 * 1024,
      'GIB' => 1024 * 1024 * 1024,
      'TIB' => 1024 * 1024 * 1024 * 1024,
      'KB' => 1000,
      'MB' => 1000 * 1000,
      'GB' => 1000 * 1000 * 1000,
      'TB' => 1000 * 1000 * 1000 * 1000,
      _ => 1,
    };
    return (value * multiplier).round();
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    return iterator.moveNext() ? iterator.current : null;
  }
}
