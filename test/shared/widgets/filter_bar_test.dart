import 'package:anitorr/shared/widgets/filters/filters.dart';
import 'package:anitorr/shared/models/sort_direction.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FilterBar hides selected sort label when collapsed', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FilterBar<_SortValue>(
            expanded: false,
            searchLabel: 'Title',
            searchValue: '',
            sortValue: _SortValue.title,
            sortOptions: const [
              FilterSortOption(value: _SortValue.title, label: 'Title'),
              FilterSortOption(value: _SortValue.score, label: 'Score'),
            ],
            activeFilterCount: 2,
            onSearchChanged: (_) {},
            onSortSelected: (_) {},
            onToggleFilters: () {},
          ),
        ),
      ),
    );

    expect(find.text('Title'), findsOneWidget);
    expect(find.byIcon(Icons.sort_rounded), findsOneWidget);
  });

  testWidgets('FilterBar opens sort menu and reports selection', (
    tester,
  ) async {
    var selected = _SortValue.title;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FilterBar<_SortValue>(
            expanded: true,
            searchLabel: 'Title',
            searchValue: '',
            sortValue: selected,
            sortOptions: const [
              FilterSortOption(value: _SortValue.title, label: 'Title'),
              FilterSortOption(value: _SortValue.score, label: 'Score'),
            ],
            activeFilterCount: 0,
            onSearchChanged: (_) {},
            onSortSelected: (value) {
              selected = value;
            },
            onToggleFilters: () {},
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.sort_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Score'));
    await tester.pumpAndSettle();

    expect(selected, _SortValue.score);
  });

  testWidgets('FilterBar reports sort direction toggle', (tester) async {
    var toggled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FilterBar<_SortValue>(
            expanded: true,
            searchLabel: 'Title',
            searchValue: '',
            sortValue: _SortValue.title,
            sortDirection: SortDirection.descending,
            sortOptions: const [
              FilterSortOption(value: _SortValue.title, label: 'Title'),
              FilterSortOption(value: _SortValue.score, label: 'Score'),
            ],
            activeFilterCount: 0,
            onSearchChanged: (_) {},
            onSortSelected: (_) {},
            onSortDirectionToggle: () {
              toggled = true;
            },
            onToggleFilters: () {},
          ),
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.south_rounded));
    await tester.pumpAndSettle();

    expect(toggled, isTrue);
  });
}

enum _SortValue { title, score }
