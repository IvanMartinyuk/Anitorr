import 'package:anitorr/shared/providers/pagination/pagination_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _lastPageProvider = NotifierProvider<LastPageNotifier, int?>(
  LastPageNotifier.new,
);

final _maxLoadedPageProvider = NotifierProvider<MaxLoadedPageNotifier, int>(
  MaxLoadedPageNotifier.new,
);

final _generationProvider = NotifierProvider<ChangeGenerationNotifier, int>(
  ChangeGenerationNotifier.new,
);

final _loadingProvider = NotifierProvider<LoadingStateNotifier, bool>(
  LoadingStateNotifier.new,
);

void main() {
  group('LastPageNotifier', () {
    test('keeps the earliest known last page', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(_lastPageProvider.notifier);
      notifier.rememberLastPage(8);
      notifier.rememberLastPage(10);
      notifier.rememberLastPage(6);

      expect(container.read(_lastPageProvider), 6);
    });
  });

  group('MaxLoadedPageNotifier', () {
    test('keeps the highest contiguous loaded page', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(_maxLoadedPageProvider.notifier);
      notifier.rememberMaxLoadedPage(2);
      notifier.rememberMaxLoadedPage(1);
      notifier.rememberMaxLoadedPage(4);

      expect(container.read(_maxLoadedPageProvider), 4);
    });
  });

  test('ChangeGenerationNotifier increments its generation', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(_generationProvider.notifier).bump();
    container.read(_generationProvider.notifier).bump();

    expect(container.read(_generationProvider), 2);
  });

  test('LoadingStateNotifier stores loading state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    container.read(_loadingProvider.notifier).setLoading(true);

    expect(container.read(_loadingProvider), isTrue);
  });
}
