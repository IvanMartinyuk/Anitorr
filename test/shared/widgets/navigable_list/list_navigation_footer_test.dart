import 'package:anitorr/shared/widgets/navigable_list/navigable_list_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('infinite footer shows loading state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListNavigationFooter.infinite(
            config: InfiniteScrollConfig(
              canLoadMore: true,
              isLoading: true,
              onLoadMore: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading more...'), findsOneWidget);
  });

  testWidgets('page footer calls selected page callback', (tester) async {
    var selectedPage = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListNavigationFooter.pages(
            config: PageNavigationConfig(
              currentPage: 1,
              maxLoadedPage: 3,
              lastPage: 3,
              hasNextPage: true,
              onPreviousPage: () {},
              onNextPage: () {},
              onPageSelected: (page) {
                selectedPage = page;
              },
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();

    expect(selectedPage, 2);
  });
}
