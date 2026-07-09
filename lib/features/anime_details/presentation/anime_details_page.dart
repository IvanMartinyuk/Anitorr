import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/router.dart';
import '../../../shared/models/app_anime.dart';
import '../domain/providers/anime_details_provider.dart';

class AnimeDetailsPage extends ConsumerWidget {
  const AnimeDetailsPage({required this.animeId, this.initialAnime, super.key});

  final int animeId;
  final AppAnime? initialAnime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anime = initialAnime;
    if (anime != null) {
      return _AnimeDetailsView(anime: anime);
    }

    final loadedAnime = ref.watch(animeDetailsProvider(animeId));

    return loadedAnime.when(
      data: (anime) => _AnimeDetailsView(anime: anime),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => _AnimeDetailsError(error: error),
    );
  }
}

class _AnimeDetailsView extends StatelessWidget {
  const _AnimeDetailsView({required this.anime});

  final AppAnime anime;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(32, 28, 32, 32),
            sliver: SliverToBoxAdapter(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1180),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton.filledTonal(
                      tooltip: 'Back',
                      onPressed: () => context.go(AppRoute.seasonal.path),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const SizedBox(height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final useSideBySide = constraints.maxWidth >= 760;

                        if (!useSideBySide) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _Poster(anime: anime),
                              const SizedBox(height: 24),
                              _Header(anime: anime),
                            ],
                          );
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 300, child: _Poster(anime: anime)),
                            const SizedBox(width: 32),
                            Expanded(child: _Header(anime: anime)),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 28),
                    Text('Synopsis', style: textTheme.titleLarge),
                    const SizedBox(height: 10),
                    Text(
                      _fallback(anime.synopsis, 'No synopsis available.'),
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                    if (_hasText(anime.background)) ...[
                      const SizedBox(height: 24),
                      Text('Background', style: textTheme.titleLarge),
                      const SizedBox(height: 10),
                      Text(
                        anime.background!,
                        style: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                      ),
                    ],
                    const SizedBox(height: 28),
                    _DetailSections(anime: anime),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.anime});

  final AppAnime anime;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final titles = _headerTitleItems(anime);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final indexedTitle in titles.indexed) ...[
          _CopyableDetailRow(
            item: indexedTitle.$2,
            showLabel: false,
            valueStyle: indexedTitle.$1 == 0
                ? textTheme.displaySmall
                : textTheme.titleLarge,
            contentPadding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
          ),
          if (indexedTitle.$1 != titles.length - 1) const SizedBox(height: 8),
        ],
        if (titles.isEmpty)
          Text('Unknown title', style: textTheme.displaySmall),
        const SizedBox(height: 18),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _InfoChip(icon: Icons.star_rounded, label: _scoreLabel(anime)),
            _InfoChip(
              icon: anime.airing
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_unchecked_rounded,
              label: anime.airing ? 'Airing' : 'Not airing',
            ),
            if (_hasText(anime.status))
              _InfoChip(icon: Icons.timeline_rounded, label: anime.status!),
            if (_hasText(anime.type))
              _InfoChip(icon: Icons.tv_rounded, label: anime.type!),
            if (anime.episodes != null)
              _InfoChip(
                icon: Icons.format_list_numbered_rounded,
                label: '${anime.episodes} episodes',
              ),
          ],
        ),
        const SizedBox(height: 20),
        _StatsGrid(anime: anime),
      ],
    );
  }
}

class _Poster extends StatelessWidget {
  const _Poster({required this.anime});

  final AppAnime anime;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 2 / 3,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          anime.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return ColoredBox(
              color: colorScheme.surfaceContainerHighest,
              child: Icon(
                Icons.image_not_supported_outlined,
                color: colorScheme.onSurfaceVariant,
                size: 48,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.anime});

  final AppAnime anime;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _DetailItem('Rank', anime.rank == null ? null : '#${anime.rank}'),
      _DetailItem(
        'Popularity',
        anime.popularity == null ? null : '#${anime.popularity}',
      ),
      _DetailItem('Members', _compactNumber(anime.members)),
      _DetailItem('Favorites', _compactNumber(anime.favorites)),
      _DetailItem('Scored by', _compactNumber(anime.scoredBy)),
      _DetailItem('MAL ID', anime.malId.toString()),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final stat in stats)
          SizedBox(width: 150, child: _DetailStat(item: stat)),
      ],
    );
  }
}

class _DetailSections extends StatelessWidget {
  const _DetailSections({required this.anime});

  final AppAnime anime;

  @override
  Widget build(BuildContext context) {
    final sections = [
      _DetailSectionData(
        title: 'Release',
        items: [
          _DetailItem('Season', _seasonLabel(anime)),
          _DetailItem('Aired', anime.aired),
          _DetailItem('Broadcast', anime.broadcast),
          _DetailItem('Duration', anime.duration),
          _DetailItem('Rating', anime.rating),
          _DetailItem('Source', anime.source),
        ],
      ),
      _DetailSectionData(title: 'Titles', items: _detailTitleItems(anime)),
      _DetailSectionData(
        title: 'Tags',
        items: [
          _DetailItem('Genres', _joinMeta(anime.genres)),
          _DetailItem('Explicit genres', _joinMeta(anime.explicitGenres)),
          _DetailItem('Themes', _joinMeta(anime.themes)),
          _DetailItem('Demographics', _joinMeta(anime.demographics)),
        ],
      ),
      _DetailSectionData(
        title: 'Production',
        items: [
          _DetailItem('Studios', _joinMeta(anime.studios)),
          _DetailItem('Producers', _joinMeta(anime.producers)),
          _DetailItem('Licensors', _joinMeta(anime.licensors)),
        ],
      ),
      _DetailSectionData(
        title: 'Links',
        items: [
          _DetailItem('MyAnimeList', anime.url),
          _DetailItem('Trailer', anime.trailerUrl),
        ],
      ),
      _DetailSectionData(
        title: 'Themes',
        items: [
          _DetailItem('Openings', _joinStrings(anime.openingThemes)),
          _DetailItem('Endings', _joinStrings(anime.endingThemes)),
        ],
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final sectionWidth = constraints.maxWidth < 360
            ? constraints.maxWidth
            : 360.0;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final section in sections)
              SizedBox(
                width: sectionWidth,
                child: _DetailSection(section: section),
              ),
          ],
        );
      },
    );
  }
}

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.section});

  final _DetailSectionData section;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(section.title, style: textTheme.titleMedium),
            const SizedBox(height: 12),
            for (final item in section.items)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _DetailRow(item: item),
              ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.item});

  final _DetailItem item;

  @override
  Widget build(BuildContext context) {
    if (item.copyable && _hasText(item.value)) {
      return _CopyableDetailRow(
        item: item,
        contentPadding: const EdgeInsets.fromLTRB(0, 6, 4, 6),
      );
    }

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        SelectableText(
          _fallback(item.value, 'Unknown'),
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class _CopyableDetailRow extends StatefulWidget {
  const _CopyableDetailRow({
    required this.item,
    this.showLabel = true,
    this.valueStyle,
    this.contentPadding = const EdgeInsets.fromLTRB(8, 6, 4, 6),
  });

  final _DetailItem item;
  final bool showLabel;
  final TextStyle? valueStyle;
  final EdgeInsetsGeometry contentPadding;

  @override
  State<_CopyableDetailRow> createState() => _CopyableDetailRowState();
}

class _CopyableDetailRowState extends State<_CopyableDetailRow> {
  var _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final value = widget.item.value!.trim();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: _hovered
              ? colorScheme.primaryContainer.withValues(alpha: 0.42)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: widget.contentPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showLabel) ...[
                    Text(
                      widget.item.label,
                      style: textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                  ],
                  SelectableText(
                    value,
                    style: widget.valueStyle ?? textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            AnimatedOpacity(
              opacity: _hovered ? 1 : 0,
              duration: const Duration(milliseconds: 140),
              child: IgnorePointer(
                ignoring: !_hovered,
                child: IconButton(
                  tooltip: 'Copy ${widget.item.label.toLowerCase()} title',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _copyTitle(context, value),
                  icon: const Icon(Icons.copy_rounded, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _copyTitle(BuildContext context, String title) async {
    await Clipboard.setData(ClipboardData(text: title));

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Copied ${widget.item.label.toLowerCase()} title'),
        ),
      );
  }
}

class _DetailStat extends StatelessWidget {
  const _DetailStat({required this.item});

  final _DetailItem item;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.label,
              style: textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _fallback(item.value, 'Unknown'),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Chip(
      avatar: Icon(icon, size: 18, color: colorScheme.primary),
      label: Text(label),
      side: BorderSide.none,
      backgroundColor: colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

class _AnimeDetailsError extends StatelessWidget {
  const _AnimeDetailsError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton.filledTonal(
              tooltip: 'Back',
              onPressed: () => context.go(AppRoute.seasonal.path),
              icon: const Icon(Icons.arrow_back_rounded),
            ),
            const SizedBox(height: 24),
            Icon(
              Icons.error_outline_rounded,
              size: 44,
              color: colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text('Could not load anime details', style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              '$error',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailSectionData {
  const _DetailSectionData({required this.title, required this.items});

  final String title;
  final List<_DetailItem> items;
}

class _DetailItem {
  const _DetailItem(this.label, this.value, {this.copyable = false});

  final String label;
  final String? value;
  final bool copyable;
}

List<_DetailItem> _headerTitleItems(AppAnime anime) {
  return [
    if (_hasText(anime.titleEnglish))
      _DetailItem('English', anime.titleEnglish, copyable: true),
    if (_hasText(anime.titleJapanese))
      _DetailItem('Japanese', anime.titleJapanese, copyable: true),
  ];
}

List<_DetailItem> _detailTitleItems(AppAnime anime) {
  return [
    _DetailItem('Default', anime.title, copyable: true),
    if (_hasText(anime.titleEnglish))
      _DetailItem('English', anime.titleEnglish, copyable: true),
    if (_hasText(anime.titleJapanese))
      _DetailItem('Japanese', anime.titleJapanese, copyable: true),
  ];
}

String _scoreLabel(AppAnime anime) {
  final score = anime.score;
  return score == null ? 'N/A score' : '${score.toStringAsFixed(1)} score';
}

String? _seasonLabel(AppAnime anime) {
  final season = anime.season;
  final year = anime.year;
  if (!_hasText(season) && year == null) {
    return null;
  }

  return [
    if (_hasText(season)) season![0].toUpperCase() + season.substring(1),
    if (year != null) year.toString(),
  ].join(' ');
}

String? _joinMeta(Iterable<AppAnimeMeta> items) {
  final names = [
    for (final item in items)
      if (_hasText(item.name)) item.name,
  ];

  return names.isEmpty ? null : names.join(', ');
}

String? _joinStrings(Iterable<String>? items) {
  if (items == null) {
    return null;
  }

  final values = items.where(_hasText).toList();
  return values.isEmpty ? null : values.join('\n');
}

String? _compactNumber(int? value) {
  if (value == null) {
    return null;
  }

  return NumberFormat.compact().format(value);
}

String _fallback(String? value, String fallback) {
  return _hasText(value) ? value!.trim() : fallback;
}

bool _hasText(String? value) {
  return value?.trim().isNotEmpty ?? false;
}
