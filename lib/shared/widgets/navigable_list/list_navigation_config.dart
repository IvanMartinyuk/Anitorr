import 'package:flutter/material.dart';

enum ListNavigationMode { infiniteScroll, pages }

final class PageNavigationConfig {
  const PageNavigationConfig({
    required this.currentPage,
    required this.maxLoadedPage,
    required this.hasNextPage,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onPageSelected,
    this.lastPage,
    this.visiblePageCount = 5,
  });

  final int currentPage;
  final int maxLoadedPage;
  final int? lastPage;
  final bool hasNextPage;
  final int visiblePageCount;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final ValueChanged<int> onPageSelected;
}

final class InfiniteScrollConfig {
  const InfiniteScrollConfig({
    required this.canLoadMore,
    required this.isLoading,
    required this.onLoadMore,
    this.thresholdPixels = 520,
    this.loadingLabel = 'Loading more...',
    this.endLabel = 'End of results',
  });

  final bool canLoadMore;
  final bool isLoading;
  final VoidCallback onLoadMore;
  final double thresholdPixels;
  final String loadingLabel;
  final String endLabel;
}
