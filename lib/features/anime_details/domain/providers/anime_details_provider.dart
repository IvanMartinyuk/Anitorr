import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jikan_api/jikan_api.dart';

import '../../data/anime_details_repository.dart';

final animeDetailsRepositoryProvider = Provider<AnimeDetailsRepository>((ref) {
  return AnimeDetailsRepository();
});

final animeDetailsProvider = FutureProvider.family<Anime, int>((ref, id) {
  return ref.watch(animeDetailsRepositoryProvider).getAnime(id);
});
