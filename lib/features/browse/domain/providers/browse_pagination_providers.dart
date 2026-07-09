import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/providers/pagination/pagination_providers.dart';

const visibleBrowsePageCount = 5;

final browsePageProvider = NotifierProvider<BrowsePageNotifier, int>(
  BrowsePageNotifier.new,
);

final browseLastPageProvider = NotifierProvider<LastPageNotifier, int?>(
  LastPageNotifier.new,
);

final browseMaxLoadedPageProvider =
    NotifierProvider<MaxLoadedPageNotifier, int>(MaxLoadedPageNotifier.new);

class BrowsePageNotifier extends PageCursorNotifier {
  @override
  int? get lastPage => ref.read(browseLastPageProvider);

  @override
  int get maxLoadedPage => ref.read(browseMaxLoadedPageProvider);
}
