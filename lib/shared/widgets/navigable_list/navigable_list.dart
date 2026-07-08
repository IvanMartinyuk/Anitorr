import 'package:flutter/material.dart';

import 'list_navigation_config.dart';
import 'list_navigation_footer.dart';

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
      slivers: [...widget.slivers, if (widget.showFooter) _footerSliver()],
    );
  }

  Widget _footerSliver() {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      sliver: SliverToBoxAdapter(
        child: switch (widget.mode) {
          ListNavigationMode.pages => ListNavigationFooter.pages(
            config: widget.pageConfig!,
          ),
          ListNavigationMode.infiniteScroll => ListNavigationFooter.infinite(
            config: widget.infiniteConfig!,
          ),
        },
      ),
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
