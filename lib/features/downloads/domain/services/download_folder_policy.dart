import '../../../my_list/domain/models/user_anime.dart';
import '../models/download_models.dart';

final class DownloadFolderPolicy {
  const DownloadFolderPolicy();

  String destinationFor(SavedAnime anime, DownloadSettings settings) {
    final root = anime.isMovie ? settings.moviesRoot : settings.seriesRoot;
    final year = anime.year == null ? '' : ' (${anime.year})';
    final folder = _sanitize('${anime.title}$year');
    final separator = root.contains(r'\') ? r'\' : '/';
    return '${root.replaceAll(RegExp(r'[/\\]+$'), '')}$separator$folder';
  }

  String _sanitize(String value) {
    return value
        .replaceAll(RegExp(r'[<>:"/\\|?*\x00-\x1F]'), '_')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .replaceAll(RegExp(r'[. ]+$'), '');
  }
}
