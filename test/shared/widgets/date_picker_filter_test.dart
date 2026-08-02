import 'package:anitorr/shared/widgets/filters/filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DatePickerFilter opens a calendar and reports a date', (
    tester,
  ) async {
    DateTime? selectedDate;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DatePickerFilter(
            label: 'Start date',
            value: null,
            firstDate: DateTime(2024),
            lastDate: DateTime(2024, 12, 31),
            onChanged: (value) {
              selectedDate = value;
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('mm/dd/yyyy'));
    await tester.pumpAndSettle();

    expect(find.byType(DatePickerDialog), findsOneWidget);

    await tester.tap(find.text('15').first);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(selectedDate, isNotNull);
    expect(selectedDate!.day, 15);
  });

  testWidgets('DatePickerFilter clears a selected date', (tester) async {
    DateTime? selectedDate = DateTime(2024, 6, 15);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DatePickerFilter(
            label: 'End date',
            value: selectedDate,
            onChanged: (value) {
              selectedDate = value;
            },
          ),
        ),
      ),
    );

    expect(find.text('Sat, Jun 15'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close_rounded));

    expect(selectedDate, isNull);
    expect(find.byType(DatePickerDialog), findsNothing);
  });
}
