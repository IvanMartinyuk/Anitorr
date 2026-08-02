import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../shared/widgets/anime/anime_grid.dart';
import '../../downloads/domain/providers/download_providers.dart';
import '../../downloads/domain/services/download_folder_policy.dart';
import '../domain/models/user_anime.dart';
import '../domain/providers/my_list_providers.dart';
import 'widgets/anime_list_actions.dart';

class MyListPage extends ConsumerWidget {
  const MyListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(myListFilterProvider);
    final library = ref.watch(filteredLibraryProvider);
    final allItems = ref.watch(libraryProvider).value ?? const [];
    final customLists = ref.watch(customListsProvider).value ?? const [];

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(32, 28, 32, 20),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'My Lists',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => _createCustomList(context, ref),
                        icon: const Icon(Icons.playlist_add_rounded),
                        label: const Text('New list'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search My Lists',
                      prefixIcon: Icon(Icons.search_rounded),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: ref.read(myListFilterProvider.notifier).setQuery,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ChoiceChip(
                        label: Text('All (${allItems.length})'),
                        selected: filter.type == MyListViewType.all,
                        onSelected: (_) =>
                            ref.read(myListFilterProvider.notifier).showAll(),
                      ),
                      for (final status in AnimeListStatus.values)
                        ChoiceChip(
                          label: Text(
                            '${status.label} (${allItems.where((item) => item.entry?.status == status).length})',
                          ),
                          selected:
                              filter.type == MyListViewType.status &&
                              filter.status == status,
                          onSelected: (_) => ref
                              .read(myListFilterProvider.notifier)
                              .showStatus(status),
                        ),
                      ChoiceChip(
                        avatar: const Icon(Icons.download_outlined, size: 18),
                        label: Text(
                          'Download (${allItems.where((item) => item.download != null).length})',
                        ),
                        selected: filter.type == MyListViewType.download,
                        onSelected: (_) => ref
                            .read(myListFilterProvider.notifier)
                            .showDownloads(),
                      ),
                      for (final list in customLists)
                        InputChip(
                          label: Text(list.name),
                          selected:
                              filter.type == MyListViewType.custom &&
                              filter.customListId == list.id,
                          onPressed: () => ref
                              .read(myListFilterProvider.notifier)
                              .showCustomList(list.id),
                          onDeleted: () =>
                              _deleteCustomList(context, ref, list),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ...library.when(
            data: (items) => [
              if (items.isEmpty)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No anime in this list yet.')),
                )
              else if (filter.type == MyListViewType.download)
                _DownloadDashboardSliver(items: items)
              else
                AnimeGrid(
                  items: [for (final item in items) item.anime.toAppAnime()],
                  actionsBuilder: (context, anime) =>
                      AnimeCardListActions(anime: anime),
                  onAnimeSelected: (anime) {
                    context.pushNamed(
                      AppRoute.animeDetails.name,
                      pathParameters: {'animeId': anime.id.toString()},
                      extra: AnimeDetailsRouteExtra(
                        anime: anime,
                        sourceRoute: AppRoute.myList,
                      ),
                    );
                  },
                ),
            ],
            loading: () => const [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
            error: (error, stackTrace) => [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('Could not load My Lists: $error')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _createCustomList(BuildContext context, WidgetRef ref) async {
    final name = await _askForName(context, title: 'New custom list');
    if (name == null || name.trim().isEmpty) {
      return;
    }
    try {
      await ref.read(myListControllerProvider).createCustomList(name);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A list with that name already exists.'),
          ),
        );
      }
    }
  }

  Future<void> _deleteCustomList(
    BuildContext context,
    WidgetRef ref,
    CustomAnimeList list,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${list.name}?'),
        content: const Text(
          'Anime tracking and downloads will not be removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(myListControllerProvider).deleteCustomList(list.id);
      ref.read(myListFilterProvider.notifier).showAll();
    }
  }
}

class _DownloadDashboardSliver extends ConsumerWidget {
  const _DownloadDashboardSliver({required this.items});

  final List<LibraryAnime> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(downloadSettingsProvider).value;
    const folderPolicy = DownloadFolderPolicy();
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      sliver: SliverList.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          final intent = item.download!;
          final selectedLabel = intent.allAvailableEpisodes
              ? 'All available episodes'
              : intent.selectedEpisodes.isEmpty
              ? 'No episodes selected'
              : '${intent.selectedEpisodes.length} episodes selected';
          final destination = settings?.isConfigured == true
              ? folderPolicy.destinationFor(item.anime, settings!)
              : 'Configure download folders in Settings';
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 56,
                    height: 76,
                    child: Image.network(
                      item.anime.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported_outlined),
                    ),
                  ),
                ),
                title: Text(item.anime.titleEnglish ?? item.anime.title),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    '${intent.state.label} • $selectedLabel'
                    '${intent.autoDownloadFuture ? ' • Future episodes on' : ''}\n'
                    '$destination',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: intent.paused
                          ? 'Resume automation'
                          : 'Pause automation',
                      onPressed: () => ref
                          .read(myListControllerProvider)
                          .setDownloadPaused(item.anime.id, !intent.paused),
                      icon: Icon(
                        intent.paused
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remove from Download',
                      onPressed: () => _removeDownload(context, ref, item),
                      icon: const Icon(Icons.delete_outline_rounded),
                    ),
                  ],
                ),
                onTap: () {
                  final anime = item.anime.toAppAnime();
                  context.pushNamed(
                    AppRoute.animeDetails.name,
                    pathParameters: {'animeId': anime.id.toString()},
                    extra: AnimeDetailsRouteExtra(
                      anime: anime,
                      sourceRoute: AppRoute.myList,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _removeDownload(
    BuildContext context,
    WidgetRef ref,
    LibraryAnime item,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove download subscription?'),
        content: const Text(
          'This removes Anitorr history and automation. Existing qBittorrent transfers are not deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref
          .read(myListControllerProvider)
          .removeDownloadIntent(item.anime.id);
    }
  }
}

Future<String?> _askForName(
  BuildContext context, {
  required String title,
}) async {
  final controller = TextEditingController();
  final value = await showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
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
  return value;
}
