import 'package:nyaa/nyaa.dart';
import 'package:test/test.dart';

void main() {
  test('parses bracketed publisher, season, episode, and resolution', () {
    final parsed = TorrentTitleParser.parse(
      '[ToonsHub] Sparks of Tomorrow S01E05 1080p NF WEB-DL MULTi H.264',
    );

    expect(parsed.publisher, 'ToonsHub');
    expect(parsed.animeName, 'Sparks of Tomorrow');
    expect(parsed.season, 1);
    expect(parsed.episodes, {5});
    expect(parsed.resolution, '1080p');
  });

  test('parses episode ranges without treating resolution as an episode', () {
    final parsed = TorrentTitleParser.parse(
      '[SubsPlease] Example Show - 01-03 (1080p) [ABC12345]',
    );

    expect(parsed.publisher, 'SubsPlease');
    expect(parsed.episodes, {1, 2, 3});
    expect(parsed.resolution, '1080p');
  });

  test('parses a trailing publisher', () {
    final parsed = TorrentTitleParser.parse(
      'Example Show S02E04 720p WEB-DL-Erai-raws [AAAA]',
    );

    expect(parsed.publisher, 'Erai-raws');
    expect(parsed.season, 2);
    expect(parsed.episodes, {4});
  });
}
