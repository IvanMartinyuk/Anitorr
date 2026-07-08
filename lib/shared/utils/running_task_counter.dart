final class RunningTaskCounter {
  RunningTaskCounter({required this.onChanged});

  final void Function(bool hasRunningTasks) onChanged;
  int _count = 0;

  void start() {
    _count += 1;
    onChanged(true);
  }

  void finish() {
    if (_count == 0) {
      onChanged(false);
      return;
    }

    _count -= 1;
    onChanged(_count > 0);
  }
}
