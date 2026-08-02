final class NavigationHistoryEntry {
  const NavigationHistoryEntry({required this.location, this.extra});

  final String location;
  final Object? extra;
}

final class NavigationHistory {
  final List<NavigationHistoryEntry> _entries = [];
  int _currentIndex = -1;

  void sync({required String location, Object? extra}) {
    if (_currentIndex >= 0 && _entries[_currentIndex].location == location) {
      return;
    }

    if (_currentIndex > 0 && _entries[_currentIndex - 1].location == location) {
      _currentIndex -= 1;
      return;
    }

    push(location: location, extra: extra);
  }

  void push({required String location, Object? extra}) {
    if (_currentIndex >= 0 && _entries[_currentIndex].location == location) {
      return;
    }

    if (_currentIndex < _entries.length - 1) {
      _entries.removeRange(_currentIndex + 1, _entries.length);
    }

    _entries.add(NavigationHistoryEntry(location: location, extra: extra));
    _currentIndex = _entries.length - 1;
  }

  NavigationHistoryEntry? back() {
    if (_currentIndex <= 0) {
      return null;
    }

    _currentIndex -= 1;
    return _entries[_currentIndex];
  }

  NavigationHistoryEntry? forward() {
    if (_currentIndex < 0 || _currentIndex >= _entries.length - 1) {
      return null;
    }

    _currentIndex += 1;
    return _entries[_currentIndex];
  }
}
