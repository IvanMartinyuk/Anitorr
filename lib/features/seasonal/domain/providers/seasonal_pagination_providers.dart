import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/pagination/pagination_providers.dart';

const visibleSeasonalPageCount = 5;

final seasonalPageProvider = NotifierProvider<SeasonalPageNotifier, int>(
  SeasonalPageNotifier.new,
);

final seasonalLastPageProvider = NotifierProvider<LastPageNotifier, int?>(
  LastPageNotifier.new,
);

final seasonalMaxLoadedPageProvider =
    NotifierProvider<MaxLoadedPageNotifier, int>(MaxLoadedPageNotifier.new);

final seasonalCacheGenerationProvider =
    NotifierProvider<ChangeGenerationNotifier, int>(
      ChangeGenerationNotifier.new,
    );

final seasonalFullCacheLoadingProvider =
    NotifierProvider<LoadingStateNotifier, bool>(LoadingStateNotifier.new);

class SeasonalPageNotifier extends PageCursorNotifier {
  @override
  int? get lastPage => ref.read(seasonalLastPageProvider);

  @override
  int get maxLoadedPage => ref.read(seasonalMaxLoadedPageProvider);
}
