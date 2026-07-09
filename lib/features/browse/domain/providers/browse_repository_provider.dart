import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/browse_anime_repository.dart';

final browseAnimeRepositoryProvider = Provider<BrowseAnimeRepository>((ref) {
  return BrowseAnimeRepository();
});
