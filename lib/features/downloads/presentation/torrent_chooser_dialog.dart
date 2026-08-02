import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nyaa/nyaa.dart';

import '../../../shared/models/app_anime.dart';
import '../domain/models/download_models.dart';
import '../domain/providers/download_providers.dart';

const defaultReleaseGroups = ['ToonsHub', 'Erai-raws', 'SubsPlease'];
const animeCategories = [
  NyaaCategory.anime,
  NyaaCategory.animeEnglishTranslated,
  NyaaCategory.animeNonEnglishTranslated,
  NyaaCategory.animeRaw,
];

final class TorrentChoice {
  const TorrentChoice({
    required this.torrent,
    required this.publisher,
    required this.quality,
    required this.category,
    required this.seriesTitle,
    this.season,
  });

  final NyaaTorrent torrent;
  final String publisher;
  final String quality;
  final NyaaCategory category;
  final String seriesTitle;
  final int? season;

  TorrentCandidate toCandidate() {
    final parsed = TorrentTitleParser.parse(torrent.name);
    return TorrentCandidate(
      id: torrent.id.toString(),
      name: torrent.name,
      uri: torrent.magnetUri,
      torrentUri: torrent.torrentUri,
      sizeBytes: torrent.sizeBytes,
      episodeCoverage: parsed.episodes,
      infoHash: torrent.magnetUri.queryParameters['xt']?.split(':').last,
      quality: quality,
      releaseGroup: publisher,
      uploadedAt: torrent.uploadedAt,
      seeders: torrent.seeders,
      leechers: torrent.leechers,
      category: category.code,
    );
  }
}

class TorrentChooserDialog extends ConsumerStatefulWidget {
  const TorrentChooserDialog({
    required this.anime,
    this.episode,
    this.initialPublisher,
    this.initialQuality,
    super.key,
  });

  final AppAnime anime;
  final int? episode;
  final String? initialPublisher;
  final String? initialQuality;

  @override
  ConsumerState<TorrentChooserDialog> createState() =>
      _TorrentChooserDialogState();
}

class _TorrentChooserDialogState extends ConsumerState<TorrentChooserDialog> {
  NyaaCategory _category = NyaaCategory.animeEnglishTranslated;
  String? _publisher;
  String? _quality;
  bool _expandedSearch = false;
  late Future<NyaaSearchPage> _results;
  final _publisherController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _publisher = widget.initialPublisher;
    _quality = widget.initialQuality;
    _results = _search();
  }

  @override
  void dispose() {
    _publisherController.dispose();
    super.dispose();
  }

  Future<NyaaSearchPage> _search() {
    final title = widget.anime.titleEnglish ?? widget.anime.title;
    final query = [
      title,
      if (_expandedSearch && _publisherController.text.trim().isNotEmpty)
        _publisherController.text.trim(),
    ].join(' ');
    return ref
        .read(nyaaClientProvider)
        .search(NyaaSearchRequest(query: query, category: _category));
  }

  void _refresh() => setState(() => _results = _search());

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1120, maxHeight: 760),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Choose torrent for ${widget.anime.titleEnglish ?? widget.anime.title}'
                      '${widget.episode == null ? '' : ' · Episode ${widget.episode}'}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final publisher in defaultReleaseGroups)
                    FilterChip(
                      label: Text(publisher),
                      selected: _publisher == publisher,
                      onSelected: (selected) => setState(
                        () => _publisher = selected ? publisher : null,
                      ),
                    ),
                  TextButton.icon(
                    onPressed: () =>
                        setState(() => _expandedSearch = !_expandedSearch),
                    icon: const Icon(Icons.manage_search),
                    label: const Text('Find another publisher'),
                  ),
                ],
              ),
              if (_expandedSearch) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _publisherController,
                        decoration: const InputDecoration(
                          labelText: 'Publisher',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _refresh(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    DropdownMenu<NyaaCategory>(
                      initialSelection: _category,
                      label: const Text('Anime category'),
                      dropdownMenuEntries: [
                        for (final category in animeCategories)
                          DropdownMenuEntry(
                            value: category,
                            label: category.label,
                          ),
                      ],
                      onSelected: (value) {
                        if (value == null) return;
                        _category = value;
                        _refresh();
                      },
                    ),
                    const SizedBox(width: 12),
                    IconButton.filled(
                      tooltip: 'Search',
                      onPressed: _refresh,
                      icon: const Icon(Icons.search),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<NyaaSearchPage>(
                  future: _results,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Could not search Nyaa: ${snapshot.error}'),
                      );
                    }
                    final parsedResults = [
                      for (final torrent in snapshot.data?.items ?? const [])
                        (
                          torrent: torrent,
                          title: TorrentTitleParser.parse(torrent.name),
                        ),
                    ];
                    final parsed = parsedResults.where((item) {
                      final episode = widget.episode;
                      return episode == null ||
                          item.title.episodes.contains(episode);
                    }).toList();
                    final publishers = parsed
                        .map((item) => item.title.publisher)
                        .whereType<String>()
                        .toSet();
                    final qualities =
                        parsed
                            .map((item) => item.title.resolution)
                            .whereType<String>()
                            .toSet()
                            .toList()
                          ..sort();
                    final visible = parsed.where((item) {
                      return (_publisher == null ||
                              item.title.publisher?.toLowerCase() ==
                                  _publisher!.toLowerCase()) &&
                          (_quality == null ||
                              item.title.resolution == _quality);
                    }).toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (publishers.isNotEmpty || qualities.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            children: [
                              for (final quality in qualities)
                                ChoiceChip(
                                  label: Text(quality),
                                  selected: _quality == quality,
                                  onSelected: (selected) => setState(
                                    () => _quality = selected ? quality : null,
                                  ),
                                ),
                            ],
                          ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: visible.isEmpty
                              ? Center(
                                  child: Text(
                                    parsed.isEmpty && widget.episode != null
                                        ? 'Episode ${widget.episode} is not available on Nyaa yet.'
                                        : 'No torrents match the selected publisher and quality.',
                                  ),
                                )
                              : SingleChildScrollView(
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: DataTable(
                                      columns: const [
                                        DataColumn(label: Text('Name')),
                                        DataColumn(label: Text('Size')),
                                        DataColumn(label: Text('Date')),
                                        DataColumn(label: Text('Seeders')),
                                        DataColumn(label: Text('Leechers')),
                                      ],
                                      rows: [
                                        for (final item in visible)
                                          DataRow(
                                            onSelectChanged: (_) {
                                              final publisher =
                                                  item.title.publisher;
                                              final quality =
                                                  item.title.resolution;
                                              if (publisher == null ||
                                                  quality == null) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                      'Publisher and resolution could not be parsed.',
                                                    ),
                                                  ),
                                                );
                                                return;
                                              }
                                              Navigator.pop(
                                                context,
                                                TorrentChoice(
                                                  torrent: item.torrent,
                                                  publisher: publisher,
                                                  quality: quality,
                                                  category: _category,
                                                  seriesTitle:
                                                      item.title.animeName,
                                                  season: item.title.season,
                                                ),
                                              );
                                            },
                                            cells: [
                                              DataCell(
                                                ConstrainedBox(
                                                  constraints:
                                                      const BoxConstraints(
                                                        maxWidth: 560,
                                                      ),
                                                  child: Text(
                                                    item.torrent.name,
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  _formatBytes(
                                                    item.torrent.sizeBytes,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                Text(
                                                  DateFormat.yMd()
                                                      .add_Hm()
                                                      .format(
                                                        item.torrent.uploadedAt
                                                            .toLocal(),
                                                      ),
                                                ),
                                              ),
                                              DataCell(
                                                Text('${item.torrent.seeders}'),
                                              ),
                                              DataCell(
                                                Text(
                                                  '${item.torrent.leechers}',
                                                ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _formatBytes(int bytes) {
  const units = ['B', 'KiB', 'MiB', 'GiB', 'TiB'];
  var value = bytes.toDouble();
  var unit = 0;
  while (value >= 1024 && unit < units.length - 1) {
    value /= 1024;
    unit++;
  }
  return '${value.toStringAsFixed(unit == 0 ? 0 : 1)} ${units[unit]}';
}
