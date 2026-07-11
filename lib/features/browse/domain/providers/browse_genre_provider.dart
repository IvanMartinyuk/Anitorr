import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'browse_repository_provider.dart';

final browseGenresProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(browseAnimeRepositoryProvider);
  final genres = await repository.getAnimeGenres();

  return [
    for (final genre in genres)
      if (genre.trim().isNotEmpty) genre,
  ]..sort();
});

final browseTagsProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(browseAnimeRepositoryProvider);
  return repository.getAnimeTags();
});
