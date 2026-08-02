import 'dart:io';

import 'package:nyaa/nyaa.dart';
import 'package:test/test.dart';

void main() {
  final baseUri = Uri.parse('https://nyaa.si/');

  test('parses the supplied search response', () {
    final html = File('examples/search.txt').readAsStringSync();
    final page = NyaaClient.parseSearchHtml(html, baseUri: baseUri);

    expect(page.items, hasLength(45));
    expect(page.totalResults, 45);
    final toonsHub = page.items.firstWhere((item) => item.id == 2140845);
    expect(toonsHub.category, NyaaCategory.animeEnglishTranslated);
    expect(toonsHub.sizeBytes, 1288490189);
    expect(toonsHub.seeders, 168);
    expect(toonsHub.leechers, 14);
    expect(toonsHub.magnetUri.scheme, 'magnet');
    expect(toonsHub.torrentUri.path, '/download/2140845.torrent');
  });

  test('parses the supplied torrent detail response', () {
    final html = File('examples/torrent_page.txt').readAsStringSync();
    final details = NyaaClient.parseDetailsHtml(html, baseUri: baseUri);

    expect(details.torrent.id, 2140845);
    expect(details.infoHash, 'e0d2103e982487eee54b2ee4b8a989c33c6b39e9');
    expect(details.files, hasLength(1));
    expect(details.files.single.path, endsWith('MSubs-ToonsHub.mkv'));
  });

  test('contains every documented filter and category code', () {
    expect(NyaaFilter.values.map((value) => value.code), [0, 1, 2]);
    expect(NyaaCategory.values, hasLength(24));
    expect(NyaaCategory.animeEnglishTranslated.code, '1_2');
    expect(NyaaCategory.softwareGames.code, '6_2');
  });
}
