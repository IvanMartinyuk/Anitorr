import 'package:flutter_riverpod/flutter_riverpod.dart';

class LastPageNotifier extends Notifier<int?> {
  @override
  int? build() {
    return null;
  }

  void rememberLastPage(int page) {
    final normalizedPage = page < 1 ? 1 : page;
    if (state == null || normalizedPage < state!) {
      state = normalizedPage;
    }
  }

  void reset() {
    state = null;
  }
}

class MaxLoadedPageNotifier extends Notifier<int> {
  @override
  int build() {
    return 1;
  }

  void rememberMaxLoadedPage(int page) {
    if (page > state) {
      state = page;
    }
  }

  void reset() {
    state = 1;
  }
}

class ChangeGenerationNotifier extends Notifier<int> {
  @override
  int build() {
    return 0;
  }

  void bump() {
    state += 1;
  }
}

class LoadingStateNotifier extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  void setLoading(bool loading) {
    state = loading;
  }
}
