import 'package:anitorr/app/app.dart';
import 'package:anitorr/app/theme/theme_mode_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('app starts on My list route', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: AnitorrApp()));

    expect(find.text('My list'), findsWidgets);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('settings theme dropdown changes app theme mode', (tester) async {
    final container = ProviderContainer();
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

    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
    await tester.pump(const Duration(milliseconds: 1));
  });

  testWidgets('mouse back and forward buttons navigate route history', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: AnitorrApp()));

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    expect(find.text('Global'), findsOneWidget);

    final backGesture = await tester.startGesture(
      const Offset(400, 300),
      kind: PointerDeviceKind.mouse,
      buttons: kBackMouseButton,
    );
    await backGesture.up();
    await tester.pumpAndSettle();
    expect(find.text('Global'), findsNothing);

    final forwardGesture = await tester.startGesture(
      const Offset(400, 300),
      kind: PointerDeviceKind.mouse,
      buttons: kForwardMouseButton,
    );
    await forwardGesture.up();
    await tester.pumpAndSettle();
    expect(find.text('Global'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  });
}
