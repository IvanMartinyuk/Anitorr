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

class NavigableSliverList extends StatefulWidget {
  const NavigableSliverList({
    required this.mode,
    required this.slivers,
    this.pageConfig,
    this.infiniteConfig,
    this.showFooter = true,
    this.controller,
    super.key,
  });

  final ListNavigationMode mode;
  final List<Widget> slivers;
  final PageNavigationConfig? pageConfig;
  final InfiniteScrollConfig? infiniteConfig;
  final bool showFooter;
  final ScrollController? controller;

  @override
  State<NavigableSliverList> createState() => _NavigableSliverListState();
}

class _NavigableSliverListState extends State<NavigableSliverList> {
  ScrollController? _ownedController;
  bool _loadRequested = false;

  ScrollController get _controller {
    return widget.controller ?? (_ownedController ??= ScrollController());
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleScroll);
  }

  @override
  void didUpdateWidget(NavigableSliverList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleScroll);
      _ownedController?.removeListener(_handleScroll);
      _ownedController = null;
      _controller.addListener(_handleScroll);
    }

    final infiniteConfig = widget.infiniteConfig;
    if (infiniteConfig == null || !infiniteConfig.isLoading) {
      _loadRequested = false;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleScroll);
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        ...widget.slivers,
        if (widget.showFooter)
          switch (widget.mode) {
            ListNavigationMode.pages => SliverPadding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              sliver: SliverToBoxAdapter(
                child: ListNavigationFooter.pages(config: widget.pageConfig!),
              ),
            ),
            ListNavigationMode.infiniteScroll => SliverPadding(
              padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
              sliver: SliverToBoxAdapter(
                child: ListNavigationFooter.infinite(
                  config: widget.infiniteConfig!,
                ),
              ),
            ),
          },
      ],
    );
  }

  void _handleScroll() {
    if (widget.mode != ListNavigationMode.infiniteScroll) {
      return;
    }

    final infiniteConfig = widget.infiniteConfig;
    if (infiniteConfig == null ||
        infiniteConfig.isLoading ||
        !infiniteConfig.canLoadMore ||
        _loadRequested ||
        !_controller.hasClients) {
      return;
    }

    final position = _controller.position;
    if (position.extentAfter <= infiniteConfig.thresholdPixels) {
      _loadRequested = true;
      infiniteConfig.onLoadMore();
    }
  }
}

class ListNavigationFooter extends StatelessWidget {
  const ListNavigationFooter.pages({
    required PageNavigationConfig config,
    super.key,
  }) : mode = ListNavigationMode.pages,
       pageConfig = config,
       infiniteConfig = null;

  const ListNavigationFooter.infinite({
    required InfiniteScrollConfig config,
    super.key,
  }) : mode = ListNavigationMode.infiniteScroll,
       pageConfig = null,
       infiniteConfig = config;

  final ListNavigationMode mode;
  final PageNavigationConfig? pageConfig;
  final InfiniteScrollConfig? infiniteConfig;

  @override
  Widget build(BuildContext context) {
    return switch (mode) {
      ListNavigationMode.pages => _PageNavigation(config: pageConfig!),
      ListNavigationMode.infiniteScroll => _InfiniteNavigation(
        config: infiniteConfig!,
      ),
    };
  }
}

class _InfiniteNavigation extends StatelessWidget {
  const _InfiniteNavigation({required this.config});

  final InfiniteScrollConfig config;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (config.isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: 12),
              Text(config.loadingLabel, style: textTheme.labelLarge),
            ],
          ),
        ),
      );
    }

    if (!config.canLoadMore) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            config.endLabel,
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return Center(
      child: FilledButton.icon(
        onPressed: config.onLoadMore,
        icon: const Icon(Icons.expand_more_rounded),
        label: const Text('Load more'),
      ),
    );
  }
}

class _PageNavigation extends StatelessWidget {
  const _PageNavigation({required this.config});

  final PageNavigationConfig config;

  @override
  Widget build(BuildContext context) {
    final pages = _visiblePages(
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
          _PaginationButton(
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
          _PaginationButton(
            tooltip: 'Next page',
            onPressed: canGoNext ? config.onNextPage : null,
            child: const Icon(Icons.chevron_right_rounded),
          ),
        ],
      ),
    );
  }

  List<int> _visiblePages({
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

    return _PaginationButton(
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

class _PaginationButton extends StatelessWidget {
  const _PaginationButton({
    required this.child,
    this.onPressed,
    this.selected = false,
    this.tooltip,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final bool selected;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onPressed != null;
    final foregroundColor = selected
        ? colorScheme.onPrimaryContainer
        : enabled
        ? colorScheme.onSurface
        : colorScheme.onSurface.withValues(alpha: 0.38);

    final button = SizedBox.square(
      dimension: 40,
      child: Material(
        color: selected
            ? colorScheme.primaryContainer
            : colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Center(
            child: IconTheme(
              data: IconThemeData(color: foregroundColor),
              child: DefaultTextStyle.merge(
                style: TextStyle(color: foregroundColor),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );

    if (tooltip == null) {
      return button;
    }

    return Tooltip(message: tooltip!, child: button);
  }
}
