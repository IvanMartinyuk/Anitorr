import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../my_list/domain/providers/my_list_providers.dart';
import '../../data/download_settings_repository.dart';
import '../../data/qbittorrent_client.dart';
import '../models/download_models.dart';
import '../services/autostart_service.dart';
import '../services/download_coordinator.dart';

final downloadSettingsRepositoryProvider = Provider<DownloadSettingsRepository>(
  (ref) {
    return DownloadSettingsRepository(ref.watch(appDatabaseProvider));
  },
);

final downloadSettingsProvider = StreamProvider<DownloadSettings>((ref) {
  return ref.watch(downloadSettingsRepositoryProvider).watch();
});

final torrentSearchProvider = Provider<TorrentSearchProvider>((ref) {
  return const UnavailableTorrentSearchProvider();
});

final downloadCoordinatorProvider = Provider<DownloadCoordinator>((ref) {
  return DownloadCoordinator(
    myListRepository: ref.watch(myListRepositoryProvider),
    settingsRepository: ref.watch(downloadSettingsRepositoryProvider),
    searchProvider: ref.watch(torrentSearchProvider),
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
