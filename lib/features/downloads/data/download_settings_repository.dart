import 'package:drift/drift.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../my_list/data/app_database.dart' as db;
import '../domain/models/download_models.dart';

final class DownloadSettingsRepository {
  DownloadSettingsRepository(
    this._database, {
    FlutterSecureStorage secureStorage = const FlutterSecureStorage(),
  }) : _secureStorage = secureStorage;

  static const _apiKeyStorageKey = 'qbittorrent_api_key';
  static const _endpointKey = 'qbittorrent_endpoint';
  static const _seriesRootKey = 'series_root';
  static const _moviesRootKey = 'movies_root';
  static const _checkIntervalKey = 'download_check_interval';
  static const _startAtLoginKey = 'start_at_login';

  final db.AppDatabase _database;
  final FlutterSecureStorage _secureStorage;

  Stream<DownloadSettings> watch() {
    return _database.select(_database.appSettings).watch().asyncMap((
      rows,
    ) async {
      final values = {for (final row in rows) row.key: row.value};
      return DownloadSettings(
        endpoint: values[_endpointKey] ?? '',
        apiKey: await _secureStorage.read(key: _apiKeyStorageKey) ?? '',
        seriesRoot: values[_seriesRootKey] ?? '',
        moviesRoot: values[_moviesRootKey] ?? '',
        checkIntervalMinutes:
            int.tryParse(values[_checkIntervalKey] ?? '') ?? 30,
        startAtLogin: values[_startAtLoginKey] == 'true',
      );
    });
  }

  Future<DownloadSettings> load() async {
    final rows = await _database.select(_database.appSettings).get();
    final values = {for (final row in rows) row.key: row.value};
    return DownloadSettings(
      endpoint: values[_endpointKey] ?? '',
      apiKey: await _secureStorage.read(key: _apiKeyStorageKey) ?? '',
      seriesRoot: values[_seriesRootKey] ?? '',
      moviesRoot: values[_moviesRootKey] ?? '',
      checkIntervalMinutes: int.tryParse(values[_checkIntervalKey] ?? '') ?? 30,
      startAtLogin: values[_startAtLoginKey] == 'true',
    );
  }

  Future<void> save(DownloadSettings settings) async {
    await _database.batch((batch) {
      void put(String key, String value) {
        batch.insert(
          _database.appSettings,
          db.AppSettingsCompanion.insert(key: key, value: value),
          mode: InsertMode.insertOrReplace,
        );
      }

      put(_endpointKey, settings.endpoint.trim());
      put(_seriesRootKey, settings.seriesRoot.trim());
      put(_moviesRootKey, settings.moviesRoot.trim());
      put(_checkIntervalKey, settings.checkIntervalMinutes.toString());
      put(_startAtLoginKey, settings.startAtLogin.toString());
    });
    await _secureStorage.write(
      key: _apiKeyStorageKey,
      value: settings.apiKey.trim(),
    );
  }
}
