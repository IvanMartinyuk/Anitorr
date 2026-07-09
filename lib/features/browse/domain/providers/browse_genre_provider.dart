import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_moe/jikan_moe.dart';

import 'browse_repository_provider.dart';

final browseGenresProvider = FutureProvider<List<AnimeGenreData>>((ref) async {
  final repository = ref.watch(browseAnimeRepositoryProvider);
  final genres = await repository.getAnimeGenres();

  return [
    for (final genre in genres)
      if (genre.name.trim().isNotEmpty) genre,
  ]..sort((a, b) => a.name.compareTo(b.name));
});
