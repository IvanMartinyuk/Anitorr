import 'package:anitorr/shared/utils/running_task_counter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('reports loading while at least one task is running', () {
    final states = <bool>[];
    final counter = RunningTaskCounter(onChanged: states.add);

    counter.start();
    counter.start();
    counter.finish();
    counter.finish();

    expect(states, [true, true, true, false]);
  });
}
