import 'package:anitorr/shared/services/navigation_history.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('NavigationHistory traverses backward and forward', () {
    final history = NavigationHistory()
      ..sync(location: '/my-list')
      ..push(location: '/browse')
      ..push(location: '/anime/1', extra: 'details');

    expect(history.back()?.location, '/browse');
    expect(history.back()?.location, '/my-list');
    expect(history.back(), isNull);
    expect(history.forward()?.location, '/browse');
    expect(history.forward()?.extra, 'details');
    expect(history.forward(), isNull);
  });

  test('NavigationHistory clears forward entries after new navigation', () {
    final history = NavigationHistory()
      ..sync(location: '/my-list')
      ..push(location: '/browse')
      ..back()
      ..push(location: '/settings');

    expect(history.forward(), isNull);
    expect(history.back()?.location, '/my-list');
  });
}
