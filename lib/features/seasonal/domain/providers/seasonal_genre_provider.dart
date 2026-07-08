import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/seasonal_anime_filtering.dart';
import 'seasonal_anime_provider.dart';
import 'seasonal_filter_providers.dart';
import 'seasonal_repository_provider.dart';

final seasonalAvailableGenresProvider = Provider<List<String>>((ref) {
  final typeFilter = ref.watch(seasonalTypeFilterProvider);
  final anime = ref
      .watch(seasonalAnimeProvider)
      .maybeWhen(data: (items) => items, orElse: () => const []);
  final repository = ref.watch(seasonalAnimeRepositoryProvider);
  final genres = <String>{};

  for (final item in [...repository.getCachedAnime(), ...anime]) {
    if (!matchesSeasonalAnimeType(item, typeFilter)) {
      continue;
    }

    for (final genre in item.genres) {
      final name = genre.name.trim();
      if (name.isNotEmpty) {
        genres.add(name);
      }
    }
  }

  return genres.toList()..sort();
});
