import 'package:anitorr_pc/app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('app starts on My list route', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AnitorrApp()));

    expect(find.text('My list'), findsWidgets);
  });
}
