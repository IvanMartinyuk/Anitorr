import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class PageCursorNotifier extends Notifier<int> {
  int? get lastPage;

  int get maxLoadedPage;

  @override
  int build() {
    return 1;
  }

  void goToPreviousPage() {
    if (state <= 1) {
      return;
    }

    state -= 1;
  }

  void goToNextPage({int? lastPageOverride}) {
    final knownLastPage = lastPageOverride ?? lastPage;
    if (knownLastPage != null && state >= knownLastPage) {
      return;
    }

    if (knownLastPage == null && state >= maxLoadedPage) {
      return;
    }

    state += 1;
  }

  void loadNextPage() {
    final knownLastPage = lastPage;
    if (knownLastPage != null && state >= knownLastPage) {
      return;
    }

    state += 1;
  }

  void goToPage(int page, {int? lastPageOverride}) {
    if (page < 1) {
      return;
    }

    final availablePage = lastPageOverride ?? lastPage ?? maxLoadedPage;
    state = page <= availablePage ? page : availablePage;
  }

  void reset() {
    state = 1;
  }
}
