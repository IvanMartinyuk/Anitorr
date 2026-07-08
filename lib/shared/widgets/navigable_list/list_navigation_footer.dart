import 'package:flutter/material.dart';

import 'infinite_navigation_footer.dart';
import 'list_navigation_config.dart';
import 'page_navigation_footer.dart';

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
      ListNavigationMode.pages => PageNavigationFooter(config: pageConfig!),
      ListNavigationMode.infiniteScroll => InfiniteNavigationFooter(
        config: infiniteConfig!,
      ),
    };
  }
}
