import 'package:anitorr/features/downloads/domain/models/download_models.dart';
import 'package:anitorr/features/downloads/domain/services/download_folder_policy.dart';
import 'package:anitorr/features/my_list/domain/models/user_anime.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = DownloadFolderPolicy();
  const settings = DownloadSettings(
    endpoint: 'http://localhost:8080',
    seriesRoot: '/media/Anime/Series/',
    moviesRoot: r'D:\Anime\Movies',
    checkIntervalMinutes: 30,
    startAtLogin: false,
  );

  test('series use the configured series root and a safe folder name', () {
    final destination = policy.destinationFor(_series, settings);

    expect(destination, '/media/Anime/Series/Test_ Anime_ (2026)');
  });

  test('movies use Windows separators when the root is Windows-style', () {
    final destination = policy.destinationFor(_movie, settings);

    expect(destination, r'D:\Anime\Movies\Movie_ Name (2024)');
  });
}

const _series = SavedAnime(
  id: 1,
  title: 'Test: Anime?',
  imageUrl: '',
  type: 'TV',
  year: 2026,
  airing: true,
);

const _movie = SavedAnime(
  id: 2,
  title: 'Movie* Name',
  imageUrl: '',
  type: 'Movie',
  year: 2024,
  airing: false,
);
