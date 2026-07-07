import 'package:anitorr_pc/app/app.dart';
import 'package:anitorr_pc/app/theme/theme_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('app starts on My list route', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AnitorrApp()));

    expect(find.text('My list'), findsWidgets);
  });

  testWidgets('settings theme dropdown changes app theme mode', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const AnitorrApp(),
      ),
    );

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Global'), findsOneWidget);
    expect(find.text('Theme'), findsOneWidget);
    expect(container.read(themeModeProvider), ThemeMode.system);

    await tester.tap(find.byType(DropdownButtonFormField<ThemeMode>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dark').last);
    await tester.pumpAndSettle();

    expect(container.read(themeModeProvider), ThemeMode.dark);
  });
}
