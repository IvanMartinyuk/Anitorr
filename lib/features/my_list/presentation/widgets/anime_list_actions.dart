import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/app_anime.dart';
import '../../../downloads/domain/providers/download_providers.dart';
import '../../../downloads/presentation/torrent_chooser_dialog.dart';
import '../../domain/models/user_anime.dart';
import '../../domain/providers/my_list_providers.dart';

class AnimeCardListActions extends ConsumerWidget {
  const AnimeCardListActions({required this.anime, super.key});

  final AppAnime anime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryAnime = ref.watch(libraryAnimeProvider(anime.id)).value;
    final customLists = ref.watch(customListsProvider).value ?? const [];
    final status = libraryAnime?.entry?.status;
    final download = libraryAnime?.download;

    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StatusMenuButton(
            anime: anime,
            status: status,
            customLists: customLists,
            selectedCustomListIds: libraryAnime?.customListIds ?? const {},
            compact: true,
          ),
          _DownloadButton(anime: anime, intent: download, compact: true),
        ],
      ),
    );
  }
}

class AnimeDetailsListActions extends ConsumerWidget {
  const AnimeDetailsListActions({required this.anime, super.key});

  final AppAnime anime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryAnime = ref.watch(libraryAnimeProvider(anime.id)).value;
    final customLists = ref.watch(customListsProvider).value ?? const [];
    final entry = libraryAnime?.entry;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _StatusMenuButton(
          anime: anime,
          status: libraryAnime?.entry?.status,
          customLists: customLists,
          selectedCustomListIds: libraryAnime?.customListIds ?? const {},
          compact: false,
        ),
        _DownloadButton(
          anime: anime,
          intent: libraryAnime?.download,
          compact: false,
        ),
        if (entry != null)
          OutlinedButton.icon(
            onPressed: () => _editTracking(context, ref, anime, entry),
            icon: const Icon(Icons.edit_note_rounded),
            label: Text('Progress ${entry.progress}/${anime.episodes ?? '?'}'),
          ),
      ],
    );
  }
}

Future<void> _editTracking(
  BuildContext context,
  WidgetRef ref,
  AppAnime anime,
  UserAnimeEntry entry,
) async {
  final value = await showDialog<_TrackingValue>(
    context: context,
    builder: (context) => _TrackingDialog(anime: anime, entry: entry),
  );
  if (value == null) {
    return;
  }
  final controller = ref.read(myListControllerProvider);
  await controller.updateTracking(
    animeId: anime.id,
    progress: value.progress,
    userScore: value.userScore,
    startedAt: value.startedAt,
    completedAt: value.completedAt,
    rewatchCount: value.rewatchCount,
    notes: value.notes,
  );
  if (!context.mounted) {
    return;
  }
  AnimeListStatus? suggestedStatus;
  if (anime.episodes != null && value.progress >= anime.episodes!) {
    suggestedStatus = AnimeListStatus.completed;
  } else if (value.progress > 0 && entry.status == AnimeListStatus.planning) {
    suggestedStatus = AnimeListStatus.watching;
  }
  if (suggestedStatus != null && suggestedStatus != entry.status) {
    final accepted = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Move to ${suggestedStatus!.label}?'),
        content: const Text('Your progress suggests a new list status.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Move'),
          ),
        ],
      ),
    );
    if (accepted == true) {
      await controller.setStatus(anime, suggestedStatus);
    }
  }
}

class _TrackingDialog extends StatefulWidget {
  const _TrackingDialog({required this.anime, required this.entry});

  final AppAnime anime;
  final UserAnimeEntry entry;

  @override
  State<_TrackingDialog> createState() => _TrackingDialogState();
}

class _TrackingDialogState extends State<_TrackingDialog> {
  late final TextEditingController _progress;
  late final TextEditingController _score;
  late final TextEditingController _rewatches;
  late final TextEditingController _notes;
  DateTime? _startedAt;
  DateTime? _completedAt;

  @override
  void initState() {
    super.initState();
    final entry = widget.entry;
    _progress = TextEditingController(text: entry.progress.toString());
    _score = TextEditingController(text: entry.userScore?.toString() ?? '');
    _rewatches = TextEditingController(text: entry.rewatchCount.toString());
    _notes = TextEditingController(text: entry.notes);
    _startedAt = entry.startedAt;
    _completedAt = entry.completedAt;
  }

  @override
  void dispose() {
    _progress.dispose();
    _score.dispose();
    _rewatches.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Tracking details'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _progress,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Episodes watched',
                        suffixText: widget.anime.episodes == null
                            ? null
                            : '/ ${widget.anime.episodes}',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _score,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Your score (0–10)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _DateButton(
                      label: 'Started',
                      value: _startedAt,
                      onChanged: (value) => setState(() => _startedAt = value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DateButton(
                      label: 'Completed',
                      value: _completedAt,
                      onChanged: (value) =>
                          setState(() => _completedAt = value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _rewatches,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Rewatch count',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _notes,
                minLines: 3,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            final progress = int.tryParse(_progress.text.trim()) ?? 0;
            final score = double.tryParse(_score.text.trim());
            Navigator.of(context).pop(
              _TrackingValue(
                progress: widget.anime.episodes == null
                    ? progress.clamp(0, 100000)
                    : progress.clamp(0, widget.anime.episodes!),
                userScore: score?.clamp(0, 10),
                startedAt: _startedAt,
                completedAt: _completedAt,
                rewatchCount: int.tryParse(_rewatches.text.trim()) ?? 0,
                notes: _notes.text,
              ),
            );
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    return OutlinedButton.icon(
      onPressed: () async {
        final selected = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (selected != null) {
          onChanged(selected);
        }
      },
      onLongPress: value == null ? null : () => onChanged(null),
      icon: const Icon(Icons.calendar_month_outlined),
      label: Text(
        value == null
            ? label
            : '$label: ${localizations.formatMediumDate(value!)}',
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _StatusMenuButton extends ConsumerWidget {
  const _StatusMenuButton({
    required this.anime,
    required this.status,
    required this.customLists,
    required this.selectedCustomListIds,
    required this.compact,
  });

  final AppAnime anime;
  final AnimeListStatus? status;
  final List<CustomAnimeList> customLists;
  final Set<int> selectedCustomListIds;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_ListAction>(
      tooltip: status?.label ?? 'Add to My Lists',
      onSelected: (action) => _handleAction(context, ref, action),
      itemBuilder: (context) => [
        for (final option in AnimeListStatus.values)
          PopupMenuItem(
            value: _ListAction.status(option),
            child: _CheckedMenuLabel(
              checked: status == option,
              label: option.label,
            ),
          ),
        if (status != null) ...[
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: _ListAction.removeStatus(),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.bookmark_remove_outlined),
              title: Text('Remove status'),
            ),
          ),
        ],
        const PopupMenuDivider(),
        for (final list in customLists)
          PopupMenuItem(
            value: _ListAction.customList(list.id),
            child: _CheckedMenuLabel(
              checked: selectedCustomListIds.contains(list.id),
              label: list.name,
            ),
          ),
        const PopupMenuItem(
          value: _ListAction.createCustomList(),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.add_rounded),
            title: Text('New custom list'),
          ),
        ),
      ],
      child: compact
          ? Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                status == null
                    ? Icons.bookmark_add_outlined
                    : Icons.bookmark_rounded,
                size: 20,
              ),
            )
          : IgnorePointer(
              child: FilledButton.tonalIcon(
                onPressed: () {},
                icon: Icon(
                  status == null
                      ? Icons.bookmark_add_outlined
                      : Icons.bookmark_rounded,
                ),
                label: Text(status?.label ?? 'Add to My Lists'),
              ),
            ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    _ListAction action,
  ) async {
    final controller = ref.read(myListControllerProvider);
    if (action.status != null) {
      await controller.setStatus(anime, action.status!);
    } else if (action.removeStatus) {
      await controller.removeStatus(anime.id);
    } else if (action.customListId != null) {
      final listId = action.customListId!;
      await controller.setCustomListMembership(
        anime: anime,
        listId: listId,
        selected: !selectedCustomListIds.contains(listId),
      );
    } else if (action.createCustomList && context.mounted) {
      final name = await _showListNameDialog(context);
      if (name != null && name.trim().isNotEmpty) {
        final listId = await controller.createCustomList(name);
        await controller.setCustomListMembership(
          anime: anime,
          listId: listId,
          selected: true,
        );
      }
    }
  }
}

class _DownloadButton extends ConsumerWidget {
  const _DownloadButton({
    required this.anime,
    required this.intent,
    required this.compact,
  });

  final AppAnime anime;
  final DownloadIntent? intent;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final icon = intent == null
        ? Icons.download_outlined
        : intent!.state == DownloadState.completed
        ? Icons.download_done_rounded
        : Icons.downloading_rounded;
    final label = intent == null ? 'Download' : intent!.state.label;
    void onPressed() => _configureDownload(context, ref);

    if (compact) {
      return IconButton(
        tooltip: label,
        visualDensity: VisualDensity.compact,
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
      );
    }

    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }

  Future<void> _configureDownload(BuildContext context, WidgetRef ref) async {
    final controller = ref.read(myListControllerProvider);
    final inheritedPreference = _relatedDownloadPreference(
      anime,
      ref.read(libraryProvider).value ?? const [],
    );
    final preferredPublisher =
        intent?.releaseGroup ?? inheritedPreference?.releaseGroup;
    final preferredQuality = intent?.quality ?? inheritedPreference?.quality;
    if (anime.type?.toLowerCase() == 'movie') {
      final choice = await showDialog<TorrentChoice>(
        context: context,
        builder: (context) => TorrentChooserDialog(
          anime: anime,
          initialPublisher: preferredPublisher,
          initialQuality: preferredQuality,
        ),
      );
      if (choice == null) return;
      await controller.saveDownloadIntent(
        anime: anime,
        selectedEpisodes: const {},
        allAvailableEpisodes: true,
        autoDownloadFuture: false,
        releaseGroup: choice.publisher,
        quality: choice.quality,
        category: choice.category.code,
        seriesTitle: choice.seriesTitle,
      );
      try {
        await ref
            .read(downloadCoordinatorProvider)
            .queueSelected(anime.id, choice.toCandidate());
      } catch (error) {
        if (context.mounted) _showDownloadError(context, error);
      }
      unawaited(ref.read(downloadCoordinatorProvider).checkNow());
      if (context.mounted) {
        _showDownloadSavedMessage(context);
      }
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Checking which episodes are available…'),
        duration: Duration(seconds: 30),
      ),
    );
    final availableEpisodes = await ref
        .read(episodeAvailabilityServiceProvider)
        .availableEpisodes(anime);
    if (!context.mounted) return;
    messenger.hideCurrentSnackBar();
    if (availableEpisodes <= 0) {
      messenger.showSnackBar(
        const SnackBar(content: Text('No episodes are available yet.')),
      );
      return;
    }

    final selection = await showDialog<_EpisodeSelection>(
      context: context,
      builder: (context) => _EpisodeSelectionDialog(
        anime: anime,
        availableEpisodeCount: availableEpisodes,
        existing: intent,
      ),
    );
    if (selection == null) {
      return;
    }
    if (!context.mounted) return;

    final firstEpisode = selection.episodes.isEmpty
        ? null
        : (selection.episodes.toList()..sort()).first;
    final choice = await showDialog<TorrentChoice>(
      context: context,
      builder: (context) => TorrentChooserDialog(
        anime: anime,
        episode: firstEpisode,
        initialPublisher: preferredPublisher,
        initialQuality: preferredQuality,
      ),
    );
    if (choice == null) return;

    await controller.saveDownloadIntent(
      anime: anime,
      selectedEpisodes: selection.episodes,
      allAvailableEpisodes: selection.allAvailable,
      autoDownloadFuture: selection.autoFuture,
      releaseGroup: choice.publisher,
      quality: choice.quality,
      category: choice.category.code,
      season: choice.season,
      seriesTitle: choice.seriesTitle,
    );
    try {
      await ref
          .read(downloadCoordinatorProvider)
          .queueSelected(
            anime.id,
            choice.toCandidate(),
            requestedEpisode: firstEpisode,
          );
    } catch (error) {
      if (context.mounted) _showDownloadError(context, error);
    }
    unawaited(ref.read(downloadCoordinatorProvider).checkNow());
    if (context.mounted) {
      _showDownloadSavedMessage(context);
    }
  }
}

DownloadIntent? _relatedDownloadPreference(
  AppAnime anime,
  List<LibraryAnime> library,
) {
  final relatedTitles = {
    _normalizedSeriesTitle(anime.title),
    if (anime.titleEnglish != null) _normalizedSeriesTitle(anime.titleEnglish!),
    for (final relation in anime.relations)
      _normalizedSeriesTitle(relation.title),
  };
  for (final item in library) {
    final download = item.download;
    if (download == null ||
        download.releaseGroup == null ||
        download.quality == null) {
      continue;
    }
    final titles = {
      _normalizedSeriesTitle(item.anime.title),
      if (item.anime.titleEnglish != null)
        _normalizedSeriesTitle(item.anime.titleEnglish!),
    };
    if (titles.any(relatedTitles.contains)) return download;
  }
  return null;
}

String _normalizedSeriesTitle(String value) {
  return value
      .toLowerCase()
      .replaceAll(
        RegExp(r'\b(?:season\s*\d+|\d+(?:st|nd|rd|th)\s+season|part\s*\d+)\b'),
        '',
      )
      .replaceAll(RegExp(r'[^a-z0-9]+'), '')
      .trim();
}

class _EpisodeSelectionDialog extends StatefulWidget {
  const _EpisodeSelectionDialog({
    required this.anime,
    required this.availableEpisodeCount,
    this.existing,
  });

  final AppAnime anime;
  final int availableEpisodeCount;
  final DownloadIntent? existing;

  @override
  State<_EpisodeSelectionDialog> createState() =>
      _EpisodeSelectionDialogState();
}

class _EpisodeSelectionDialogState extends State<_EpisodeSelectionDialog> {
  late Set<int> _selected;
  late bool _allAvailable;
  late bool _autoFuture;

  @override
  void initState() {
    super.initState();
    final count = widget.availableEpisodeCount;
    _selected = widget.existing?.allAvailableEpisodes == true
        ? {for (var episode = 1; episode <= count; episode++) episode}
        : widget.existing?.selectedEpisodes
                  .where((episode) => episode <= count)
                  .toSet() ??
              {for (var episode = 1; episode <= count; episode++) episode};
    _allAvailable = _selected.length == count;
    _autoFuture = widget.existing?.autoDownloadFuture ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.availableEpisodeCount;
    return AlertDialog(
      title: const Text('Choose episodes to download'),
      content: SizedBox(
        width: 620,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.anime.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              Text(
                widget.anime.episodes == null
                    ? '$count episodes currently available'
                    : '$count of ${widget.anime.episodes} episodes currently available',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              ...[
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selected = {
                            for (var episode = 1; episode <= count; episode++)
                              episode,
                          };
                          _allAvailable = true;
                        });
                      },
                      child: const Text('Select all'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selected.clear();
                          _allAvailable = false;
                        });
                      },
                      child: const Text('Clear'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var episode = 1; episode <= count; episode++)
                      FilterChip(
                        label: Text('$episode'),
                        selected: _selected.contains(episode),
                        onSelected: (selected) {
                          setState(() {
                            selected
                                ? _selected.add(episode)
                                : _selected.remove(episode);
                            _allAvailable = _selected.length == count;
                          });
                        },
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _autoFuture,
                onChanged: (value) {
                  setState(() => _autoFuture = value ?? false);
                },
                title: const Text('Automatically download future episodes'),
                subtitle: const Text(
                  'Checks continue while Anitorr is running in the tray.',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _allAvailable || _selected.isNotEmpty
              ? () => Navigator.of(context).pop(
                  _EpisodeSelection(
                    episodes: _selected,
                    allAvailable: _allAvailable,
                    autoFuture: _autoFuture,
                  ),
                )
              : null,
          child: const Text('Add to Download'),
        ),
      ],
    );
  }
}

class _CheckedMenuLabel extends StatelessWidget {
  const _CheckedMenuLabel({required this.checked, required this.label});

  final bool checked;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(checked ? Icons.check_rounded : null),
      title: Text(label),
    );
  }
}

final class _ListAction {
  const _ListAction._({
    this.status,
    this.customListId,
    this.removeStatus = false,
    this.createCustomList = false,
  });

  const _ListAction.status(AnimeListStatus value) : this._(status: value);
  const _ListAction.customList(int id) : this._(customListId: id);
  const _ListAction.removeStatus() : this._(removeStatus: true);
  const _ListAction.createCustomList() : this._(createCustomList: true);

  final AnimeListStatus? status;
  final int? customListId;
  final bool removeStatus;
  final bool createCustomList;
}

final class _EpisodeSelection {
  const _EpisodeSelection({
    required this.episodes,
    required this.allAvailable,
    required this.autoFuture,
  });

  final Set<int> episodes;
  final bool allAvailable;
  final bool autoFuture;
}

final class _TrackingValue {
  const _TrackingValue({
    required this.progress,
    required this.userScore,
    required this.startedAt,
    required this.completedAt,
    required this.rewatchCount,
    required this.notes,
  });

  final int progress;
  final double? userScore;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int rewatchCount;
  final String notes;
}

Future<String?> _showListNameDialog(BuildContext context) async {
  final controller = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('New custom list'),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'List name',
          border: OutlineInputBorder(),
        ),
        onSubmitted: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(controller.text),
          child: const Text('Create'),
        ),
      ],
    ),
  );
  controller.dispose();
  return result;
}

void _showDownloadError(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Download saved, but could not be queued: $error')),
  );
}

void _showDownloadSavedMessage(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text(
        'Saved to Download. Torrent search integration is pending.',
      ),
    ),
  );
}
