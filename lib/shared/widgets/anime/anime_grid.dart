import 'package:flutter/material.dart';

import '../../models/app_anime.dart';

class AnimeGrid extends StatelessWidget {
  const AnimeGrid({
    required this.items,
    this.onAnimeSelected,
    this.actionsBuilder,
    super.key,
  });

  final List<AppAnime> items;
  final ValueChanged<AppAnime>? onAnimeSelected;
  final Widget Function(BuildContext context, AppAnime anime)? actionsBuilder;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.crossAxisExtent;
          final columnCount = (width / 220).floor().clamp(2, 6);

          return SliverGrid.builder(
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columnCount,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.58,
            ),
            itemBuilder: (context, index) {
              return _AnimeCard(
                anime: items[index],
                onSelected: onAnimeSelected,
                actions: actionsBuilder?.call(context, items[index]),
              );
            },
          );
        },
      ),
    );
  }
}

class _AnimeCard extends StatelessWidget {
  const _AnimeCard({
    required this.anime,
    required this.onSelected,
    this.actions,
  });

  final AppAnime anime;
  final ValueChanged<AppAnime>? onSelected;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final title = anime.titleEnglish?.trim().isNotEmpty ?? false
        ? anime.titleEnglish!
        : anime.title;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onSelected == null ? null : () => onSelected!(anime),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        anime.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return ColoredBox(
                            color: colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: colorScheme.onSurfaceVariant,
                              size: 36,
                            ),
                          );
                        },
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _AnimeRatingBadge(anime: anime),
                      ),
                      if (actions != null)
                        Positioned(left: 8, bottom: 8, child: actions!),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 38,
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimeRatingBadge extends StatelessWidget {
  const _AnimeRatingBadge({required this.anime});

  final AppAnime anime;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final score = anime.score;
    final label = score == null ? 'N/A' : score.toStringAsFixed(1);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, size: 16, color: colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
