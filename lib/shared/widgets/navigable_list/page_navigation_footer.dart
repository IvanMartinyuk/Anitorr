import 'package:flutter/material.dart';

import 'list_navigation_config.dart';
import 'page_window.dart';
import 'pagination_button.dart';

class PageNavigationFooter extends StatelessWidget {
  const PageNavigationFooter({required this.config, super.key});

  final PageNavigationConfig config;

  @override
  Widget build(BuildContext context) {
    final pages = visiblePageWindow(
      currentPage: config.currentPage,
      lastPage: config.lastPage,
      maxLoadedPage: config.maxLoadedPage,
      visiblePageCount: config.visiblePageCount,
    );
    final lastPage = config.lastPage;
    final canGoNext =
        config.hasNextPage &&
        config.currentPage < config.maxLoadedPage &&
        (lastPage == null || config.currentPage < lastPage);

    return Center(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          PaginationButton(
            tooltip: 'Previous page',
            onPressed: config.currentPage <= 1 ? null : config.onPreviousPage,
            child: const Icon(Icons.chevron_left_rounded),
          ),
          for (final visiblePage in pages)
            _PageNumberButton(
              page: visiblePage,
              selected: visiblePage == config.currentPage,
              onPressed: () => config.onPageSelected(visiblePage),
            ),
          PaginationButton(
            tooltip: 'Next page',
            onPressed: canGoNext ? config.onNextPage : null,
            child: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }
}

class _PageNumberButton extends StatelessWidget {
  const _PageNumberButton({
    required this.page,
    required this.selected,
    required this.onPressed,
  });

  final int page;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return PaginationButton(
      selected: selected,
      onPressed: selected ? null : onPressed,
      child: Text(
        '$page',
        style: textTheme.labelLarge?.copyWith(
          color: selected
              ? colorScheme.onPrimaryContainer
              : colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
