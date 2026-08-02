import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../my_list/domain/providers/my_list_providers.dart';
import '../../../../shared/services/rate_limited_anilist_client.dart';
import '../../data/download_settings_repository.dart';
import '../../data/qbittorrent_client.dart';
import '../../data/nyaa_torrent_search_provider.dart';
import 'package:nyaa/nyaa.dart';
import '../models/download_models.dart';
import '../services/autostart_service.dart';
import '../services/download_coordinator.dart';
import '../services/episode_availability_service.dart';

final nyaaClientProvider = Provider<NyaaClient>((ref) => NyaaClient());

final episodeAvailabilityServiceProvider = Provider<EpisodeAvailabilityService>(
  (ref) => EpisodeAvailabilityService(
    aniListClient: RateLimitedAniListClient.instance,
    nyaaClient: ref.watch(nyaaClientProvider),
  ),
);

final downloadSettingsRepositoryProvider = Provider<DownloadSettingsRepository>(
  (ref) {
    return DownloadSettingsRepository(ref.watch(appDatabaseProvider));
  },
);

final downloadSettingsProvider = StreamProvider<DownloadSettings>((ref) {
  return ref.watch(downloadSettingsRepositoryProvider).watch();
});

final torrentSearchProvider = Provider<TorrentSearchProvider>((ref) {
  return NyaaTorrentSearchProvider(ref.watch(nyaaClientProvider));
});

final downloadCoordinatorProvider = Provider<DownloadCoordinator>((ref) {
  return DownloadCoordinator(
    myListRepository: ref.watch(myListRepositoryProvider),
    settingsRepository: ref.watch(downloadSettingsRepositoryProvider),
    searchProvider: ref.watch(torrentSearchProvider),
    downloadClientFactory: (settings) =>
        QBittorrentClient(endpoint: settings.endpoint, apiKey: settings.apiKey),
    airingTimeProvider: (animeId, episode) async {
      final response = await RateLimitedAniListClient.instance.execute(
        (client) => client.getAiringSchedule(mediaId: animeId, perPage: 50),
      );
      for (final schedule in response.data) {
        if (schedule.episode == episode) {
          return DateTime.fromMillisecondsSinceEpoch(
            schedule.airingAt * 1000,
            isUtc: true,
          );
        }
      }
      return null;
    },
  );
});

final autostartServiceProvider = Provider<AutostartService>((ref) {
  return const AutostartService();
});

final downloadSettingsControllerProvider = Provider<DownloadSettingsController>(
  (ref) {
    return DownloadSettingsController(
      ref.watch(downloadSettingsRepositoryProvider),
      ref.watch(autostartServiceProvider),
    );
  },
);

final class DownloadSettingsController {
  const DownloadSettingsController(this._repository, this._autostartService);

  final DownloadSettingsRepository _repository;
  final AutostartService _autostartService;

  Future<void> save(DownloadSettings settings) async {
    await _repository.save(settings);
    await _autostartService.setEnabled(settings.startAtLogin);
  }

  Future<QBittorrentConnectionInfo> testConnection(DownloadSettings settings) {
    return QBittorrentClient(
      endpoint: settings.endpoint,
      apiKey: settings.apiKey,
    ).testConnection();
  }
}
