import 'package:anitorr/shared/widgets/filters/filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('FilterLayout renders configured modules in order', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: FilterLayout(
            modules: [
              FilterWidgetModule(Text('Header')),
              FilterRowModule(children: [Text('Type'), Text('Airing')]),
              FilterWidgetModule(Text('Score')),
            ],
          ),
        ),
      ),
    );

    final headerTop = tester.getTopLeft(find.text('Header')).dy;
    final typeTop = tester.getTopLeft(find.text('Type')).dy;
    final scoreTop = tester.getTopLeft(find.text('Score')).dy;

    expect(headerTop, lessThan(typeTop));
    expect(typeTop, lessThan(scoreTop));
  });
}
