import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/app_anime.dart';
import '../../data/anime_details_repository.dart';

final animeDetailsRepositoryProvider = Provider<AnimeDetailsRepository>((ref) {
  return AnimeDetailsRepository();
});

final animeDetailsProvider = FutureProvider.family<AppAnime, int>((ref, id) {
  return ref.watch(animeDetailsRepositoryProvider).getAnime(id);
});
