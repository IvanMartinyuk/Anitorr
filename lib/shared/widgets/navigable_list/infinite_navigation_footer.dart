import 'package:flutter/material.dart';

import 'list_navigation_config.dart';

class InfiniteNavigationFooter extends StatelessWidget {
  const InfiniteNavigationFooter({required this.config, super.key});

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
