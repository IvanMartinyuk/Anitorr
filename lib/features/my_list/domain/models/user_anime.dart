import '../../../../shared/models/app_anime.dart';

enum AnimeListStatus {
  watching('Watching'),
  planning('Plan to watch'),
  completed('Completed'),
  paused('On hold'),
  dropped('Dropped'),
  rewatching('Rewatching');

  const AnimeListStatus(this.label);

  final String label;
}

enum DownloadState {
  awaitingSearch('Awaiting search integration'),
  searching('Searching'),
  awaitingSelection('Awaiting selection'),
  queued('Queued'),
  downloading('Downloading'),
  completed('Completed'),
  paused('Paused'),
  error('Error');

  const DownloadState(this.label);

  final String label;
}

final class SavedAnime {
  const SavedAnime({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.airing,
    this.titleEnglish,
    this.type,
    this.episodes,
    this.score,
    this.year,
  });

  factory SavedAnime.fromAppAnime(AppAnime anime) {
    return SavedAnime(
      id: anime.id,
      title: anime.title,
      titleEnglish: anime.titleEnglish,
      imageUrl: anime.imageUrl,
      type: anime.type,
      episodes: anime.episodes,
      score: anime.score,
      year: anime.year,
      airing: anime.airing,
    );
  }

  final int id;
  final String title;
  final String? titleEnglish;
  final String imageUrl;
  final String? type;
  final int? episodes;
  final double? score;
  final int? year;
  final bool airing;

  bool get isMovie => type?.toLowerCase() == 'movie';

  AppAnime toAppAnime() {
    return AppAnime(
      id: id,
      url: '',
      imageUrl: imageUrl,
      title: title,
      titleEnglish: titleEnglish,
      titleSynonyms: const [],
      type: type,
      episodes: episodes,
      score: score,
      year: year,
      airing: airing,
      genres: const [],
      tags: const [],
      rankings: const [],
      externalLinks: const [],
      streamingEpisodes: const [],
      relations: const [],
    );
  }
}

final class UserAnimeEntry {
  const UserAnimeEntry({
    required this.animeId,
    required this.status,
    required this.progress,
    required this.rewatchCount,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
    this.userScore,
    this.startedAt,
    this.completedAt,
  });

  final int animeId;
  final AnimeListStatus status;
  final int progress;
  final double? userScore;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int rewatchCount;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
}

final class CustomAnimeList {
  const CustomAnimeList({
    required this.id,
    required this.name,
    required this.createdAt,
  });

  final int id;
  final String name;
  final DateTime createdAt;
}

final class DownloadIntent {
  const DownloadIntent({
    required this.animeId,
    required this.selectedEpisodes,
    required this.allAvailableEpisodes,
    required this.autoDownloadFuture,
    required this.state,
    required this.paused,
    required this.createdAt,
    required this.updatedAt,
    this.destinationOverride,
    this.lastCheckedAt,
    this.errorMessage,
  });

  final int animeId;
  final Set<int> selectedEpisodes;
  final bool allAvailableEpisodes;
  final bool autoDownloadFuture;
  final DownloadState state;
  final bool paused;
  final String? destinationOverride;
  final DateTime? lastCheckedAt;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
}

final class LibraryAnime {
  const LibraryAnime({
    required this.anime,
    required this.customListIds,
    this.entry,
    this.download,
  });

  final SavedAnime anime;
  final UserAnimeEntry? entry;
  final Set<int> customListIds;
  final DownloadIntent? download;
}
