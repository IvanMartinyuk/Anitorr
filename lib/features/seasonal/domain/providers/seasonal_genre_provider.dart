import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'seasonal_repository_provider.dart';

final seasonalAvailableGenresProvider = FutureProvider<List<String>>((
  ref,
) async {
  final repository = ref.watch(seasonalAnimeRepositoryProvider);
  final genres = await repository.getAnimeGenres();
  final genreNames = <String>{};

  for (final genre in genres) {
    final name = genre.name.trim();
    if (name.isNotEmpty) {
      genreNames.add(name);
    }
  }

  return genreNames.toList()..sort();
});
