import 'package:anitorr/shared/models/app_anime.dart';
import 'package:anitorr/shared/widgets/anime/anime_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the next episode schedule on an anime card', (
    tester,
  ) async {
    final nextAiringAt = DateTime.now().add(const Duration(days: 2, hours: 3));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              AnimeGrid(
                items: [
                  _anime(
                    nextAiringAt: nextAiringAt,
                    nextAiringEpisodeNumber: 6,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.schedule_rounded), findsOneWidget);
    expect(find.textContaining('Ep 6'), findsOneWidget);
    expect(find.textContaining('in 2d'), findsOneWidget);
  });

  testWidgets('hides the schedule indicator without a next airing date', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              AnimeGrid(items: [_anime()]),
            ],
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.schedule_rounded), findsNothing);
  });
}

AppAnime _anime({DateTime? nextAiringAt, int? nextAiringEpisodeNumber}) {
  return AppAnime(
    id: 1,
    url: 'https://example.test/anime',
    imageUrl: '',
    title: 'Test anime',
    titleSynonyms: const [],
    airing: nextAiringAt != null,
    nextAiringAt: nextAiringAt,
    nextAiringEpisodeNumber: nextAiringEpisodeNumber,
    genres: const [],
    tags: const [],
    rankings: const [],
    externalLinks: const [],
    streamingEpisodes: const [],
    relations: const [],
  );
}
