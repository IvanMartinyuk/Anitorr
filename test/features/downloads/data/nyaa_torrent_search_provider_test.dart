import 'dart:convert';
import 'dart:io';

import 'package:anitorr/features/downloads/data/nyaa_torrent_search_provider.dart';
import 'package:anitorr/features/downloads/domain/models/download_models.dart';
import 'package:anitorr/features/my_list/domain/models/user_anime.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaa/nyaa.dart';

void main() {
  test('narrows automatic searches by publisher and episode', () async {
    final html = File('packages/nyaa/examples/search.txt').readAsStringSync();
    String? query;
    final provider = NyaaTorrentSearchProvider(
      NyaaClient(
        httpClient: MockClient((request) async {
          query = request.url.queryParameters['q'];
          return http.Response.bytes(
            utf8.encode(html),
            200,
            headers: {'content-type': 'text/html; charset=utf-8'},
          );
        }),
      ),
    );
    final now = DateTime(2026);

    await provider.search(
      TorrentSearchRequest(
        anime: const SavedAnime(
          id: 1,
          title: 'Sparks of Tomorrow Season 3',
          titleEnglish: 'Sparks of Tomorrow Season 3',
          imageUrl: '',
          airing: true,
        ),
        intent: DownloadIntent(
          animeId: 1,
          selectedEpisodes: const {5},
          allAvailableEpisodes: false,
          autoDownloadFuture: false,
          state: DownloadState.awaitingSearch,
          paused: false,
          releaseGroup: 'Erai-raws',
          quality: '1080p',
          season: 3,
          createdAt: now,
          updatedAt: now,
        ),
        episode: 5,
      ),
    );

    expect(query, contains('Sparks of Tomorrow'));
    expect(query, isNot(contains('Season 3')));
    expect(query, contains('Erai-raws'));
    expect(query, endsWith('5'));
  });
}
