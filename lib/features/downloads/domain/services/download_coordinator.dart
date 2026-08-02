import 'dart:async';

import '../../../my_list/data/my_list_repository.dart';
import '../../../my_list/domain/models/user_anime.dart';
import '../../data/download_settings_repository.dart';
import '../models/download_models.dart';

final class DownloadCoordinator {
  DownloadCoordinator({
    required MyListRepository myListRepository,
    required DownloadSettingsRepository settingsRepository,
    required TorrentSearchProvider searchProvider,
  }) : _myListRepository = myListRepository,
       _settingsRepository = settingsRepository,
       _searchProvider = searchProvider;

  final MyListRepository _myListRepository;
  final DownloadSettingsRepository _settingsRepository;
  final TorrentSearchProvider _searchProvider;
  bool _running = false;

  Future<void> checkNow() async {
    if (_running) {
      return;
    }
    _running = true;
    try {
      final settings = await _settingsRepository.load();
      if (!settings.isConfigured) {
        return;
      }
      final library = await _myListRepository.watchLibrary().first;
      for (final item in library) {
        final intent = item.download;
        if (intent == null || intent.paused) {
          continue;
        }
        try {
          final candidates = await _searchProvider.search(
            TorrentSearchRequest(anime: item.anime, intent: intent),
          );
          await _myListRepository.updateDownloadState(
            item.anime.id,
            candidates.isEmpty
                ? DownloadState.awaitingSearch
                : DownloadState.awaitingSelection,
            checked: true,
          );
        } catch (error) {
          await _myListRepository.updateDownloadState(
            item.anime.id,
            DownloadState.error,
            errorMessage: '$error',
            checked: true,
          );
        }
      }
    } finally {
      _running = false;
    }
  }
}

final class DownloadScheduler {
  DownloadScheduler(this._coordinator);

  final DownloadCoordinator _coordinator;
  Timer? _timer;

  void start(Duration interval) {
    _timer?.cancel();
    unawaited(_coordinator.checkNow());
    _timer = Timer.periodic(interval, (_) {
      unawaited(_coordinator.checkNow());
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }
}
