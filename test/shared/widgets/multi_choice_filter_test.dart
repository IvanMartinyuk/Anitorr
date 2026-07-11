import 'package:anitorr/shared/widgets/filters/filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'MultiChoiceFilter renders chips below the large-list threshold',
    (tester) async {
      final selected = <String>{};

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MultiChoiceFilter<String>(
              options: const [
                FilterOption(value: 'Action', label: 'Action'),
                FilterOption(value: 'Drama', label: 'Drama'),
              ],
              selectedValues: selected,
              onToggle: selected.add,
            ),
          ),
        ),
      );

      expect(find.byType(FilterChip), findsNWidgets(2));
      expect(find.byType(TextField), findsNothing);
    },
  );

  testWidgets('MultiChoiceFilter uses search menu for large option lists', (
    tester,
  ) async {
    final selected = <String>{};

    await tester.pumpWidget(
      StatefulBuilder(
        builder: (context, setState) {
          return MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  MultiChoiceFilter<String>(
                    largeListThreshold: 2,
                    options: const [
                      FilterOption(value: 'Action', label: 'Action'),
                      FilterOption(value: 'Drama', label: 'Drama'),
                      FilterOption(value: 'Romance', label: 'Romance'),
                    ],
                    selectedValues: selected,
                    onToggle: (value) {
                      setState(() {
                        if (!selected.add(value)) {
                          selected.remove(value);
                        }
                      });
                    },
                  ),
                  const Text('Outside'),
                ],
              ),
            ),
          );
        },
      ),
    );

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(FilterChip), findsNothing);

    await tester.tap(find.byType(TextField));
    await tester.pumpAndSettle();

    expect(
      find.byIcon(Icons.check_box_outline_blank_rounded),
      findsNWidgets(3),
    );

    await tester.enterText(find.byType(TextField), 'dra');
    await tester.pumpAndSettle();

    expect(find.text('Drama'), findsOneWidget);
    expect(find.text('Action'), findsNothing);

    await tester.tap(find.text('Drama'));
    await tester.pumpAndSettle();

    expect(selected, {'Drama'});

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.byType(FilterChip), findsOneWidget);
    expect(find.text('Drama'), findsOneWidget);
  });
}
