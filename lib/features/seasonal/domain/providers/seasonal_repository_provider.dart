import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/seasonal_anime_repository.dart';

final seasonalAnimeRepositoryProvider = Provider<SeasonalAnimeRepository>((
  ref,
) {
  return SeasonalAnimeRepository();
});
