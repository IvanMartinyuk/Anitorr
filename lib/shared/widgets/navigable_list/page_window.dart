List<int> visiblePageWindow({
  required int currentPage,
  required int? lastPage,
  required int maxLoadedPage,
  required int visiblePageCount,
}) {
  final availableEnd = lastPage ?? maxLoadedPage;
  final halfWindow = visiblePageCount ~/ 2;
  final preferredEnd = currentPage <= halfWindow + 1
      ? visiblePageCount
      : currentPage + halfWindow;
  final end = preferredEnd.clamp(1, availableEnd);
  final start = (end - visiblePageCount + 1).clamp(1, end);

  return [for (var page = start; page <= end; page++) page];
}
