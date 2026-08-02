import '../../../my_list/domain/models/user_anime.dart';
import '../models/download_models.dart';

final class DownloadFolderPolicy {
  const DownloadFolderPolicy();

  String destinationFor(
    SavedAnime anime,
    DownloadSettings settings, {
    DownloadIntent? intent,
  }) {
    final root = anime.isMovie ? settings.moviesRoot : settings.seriesRoot;
    final year = anime.year == null ? '' : ' (${anime.year})';
    final folder = _sanitize(intent?.seriesTitle ?? '${anime.title}$year');
    final separator = root.contains(r'\') ? r'\' : '/';
    final base = '${root.replaceAll(RegExp(r'[/\\]+$'), '')}$separator$folder';
    if (anime.isMovie) return base;
    final season = (intent?.season ?? 1).toString().padLeft(2, '0');
    return '$base${separator}Season $season';
  }

  String _sanitize(String value) {
    return value
        .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .replaceAll(RegExp(r'[. ]+$'), '');
  }
}
