import 'package:anitorr/shared/widgets/navigable_list/navigable_list_widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('visiblePageWindow starts at page one near the beginning', () {
    expect(
      visiblePageWindow(
        currentPage: 1,
        lastPage: 10,
        maxLoadedPage: 10,
        visiblePageCount: 5,
      ),
      [1, 2, 3, 4, 5],
    );
  });

  test('visiblePageWindow centers around later pages and clamps at end', () {
    expect(
      visiblePageWindow(
        currentPage: 8,
        lastPage: 9,
        maxLoadedPage: 9,
        visiblePageCount: 5,
      ),
      [5, 6, 7, 8, 9],
    );
  });
}
