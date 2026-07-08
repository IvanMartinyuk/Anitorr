import 'package:anitorr/shared/providers/pagination/pagination_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _testLastPageProvider = Provider<int?>((ref) => null);
final _testMaxLoadedPageProvider = Provider<int>((ref) => 1);

final _pageProvider = NotifierProvider<_TestPageNotifier, int>(
  _TestPageNotifier.new,
);

class _TestPageNotifier extends PageCursorNotifier {
  @override
  int? get lastPage => ref.read(_testLastPageProvider);

  @override
  int get maxLoadedPage => ref.read(_testMaxLoadedPageProvider);
}

void main() {
  test('goToNextPage waits for loaded pages when last page is unknown', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(_pageProvider.notifier).goToNextPage();
    expect(container.read(_pageProvider), 1);

    final loadedContainer = ProviderContainer(
      overrides: [_testMaxLoadedPageProvider.overrideWith((ref) => 2)],
    );
    addTearDown(loadedContainer.dispose);

    loadedContainer.read(_pageProvider.notifier).goToNextPage();

    expect(loadedContainer.read(_pageProvider), 2);
  });

  test('goToPage clamps to known last page', () {
    final container = ProviderContainer(
      overrides: [_testLastPageProvider.overrideWith((ref) => 3)],
    );
    addTearDown(container.dispose);

    container.read(_pageProvider.notifier).goToPage(10);

    expect(container.read(_pageProvider), 3);
  });

  test('loadNextPage can advance before max loaded page catches up', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(_pageProvider.notifier).loadNextPage();

    expect(container.read(_pageProvider), 2);
  });
}
