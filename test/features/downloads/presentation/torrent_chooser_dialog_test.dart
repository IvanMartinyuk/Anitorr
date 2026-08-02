import 'dart:io';
import 'dart:convert';

import 'package:anitorr/features/downloads/domain/providers/download_providers.dart';
import 'package:anitorr/features/downloads/presentation/torrent_chooser_dialog.dart';
import 'package:anitorr/shared/models/app_anime.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:nyaa/nyaa.dart';

void main() {
  testWidgets('shows only torrents containing the requested episode', (
    tester,
  ) async {
    final html = File('packages/nyaa/examples/search.txt').readAsStringSync();
    final client = NyaaClient(
      httpClient: MockClient(
        (request) async => http.Response.bytes(
          utf8.encode(html),
          200,
          headers: {'content-type': 'text/html; charset=utf-8'},
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [nyaaClientProvider.overrideWithValue(client)],
        child: const MaterialApp(
          home: Scaffold(body: TorrentChooserDialog(anime: _anime, episode: 4)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('S01E04'), findsWidgets);
    expect(find.textContaining('S01E05'), findsNothing);
    expect(find.textContaining('S01E03'), findsNothing);
  });

  testWidgets('reports an unavailable requested episode', (tester) async {
    final html = File('packages/nyaa/examples/search.txt').readAsStringSync();
    final client = NyaaClient(
      httpClient: MockClient(
        (request) async => http.Response.bytes(
          utf8.encode(html),
          200,
          headers: {'content-type': 'text/html; charset=utf-8'},
        ),
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [nyaaClientProvider.overrideWithValue(client)],
        child: const MaterialApp(
          home: Scaffold(
            body: TorrentChooserDialog(anime: _anime, episode: 11),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Episode 11 is not available on Nyaa yet.'),
      findsOneWidget,
    );
    expect(find.byType(DataTable), findsNothing);
  });
}

const _anime = AppAnime(
  id: 1,
  url: '',
  imageUrl: '',
  title: 'Sparks of Tomorrow',
  titleEnglish: 'Sparks of Tomorrow',
  titleSynonyms: [],
  airing: true,
  episodes: 14,
  genres: [],
  tags: [],
  rankings: [],
  externalLinks: [],
  streamingEpisodes: [],
  relations: [],
);
