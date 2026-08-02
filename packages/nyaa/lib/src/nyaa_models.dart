enum NyaaFilter {
  none(0, 'No filter'),
  noRemakes(1, 'No remakes'),
  trustedOnly(2, 'Trusted only');

  const NyaaFilter(this.code, this.label);
  final int code;
  final String label;
}

enum NyaaCategory {
  all('0_0', 'All categories'),
  anime('1_0', 'Anime'),
  animeMusicVideo('1_1', 'Anime Music Video'),
  animeEnglishTranslated('1_2', 'Anime - English-translated'),
  animeNonEnglishTranslated('1_3', 'Anime - Non-English-translated'),
  animeRaw('1_4', 'Anime - Raw'),
  audio('2_0', 'Audio'),
  audioLossless('2_1', 'Audio - Lossless'),
  audioLossy('2_2', 'Audio - Lossy'),
  literature('3_0', 'Literature'),
  literatureEnglishTranslated('3_1', 'Literature - English-translated'),
  literatureNonEnglishTranslated('3_2', 'Literature - Non-English-translated'),
  literatureRaw('3_3', 'Literature - Raw'),
  liveAction('4_0', 'Live Action'),
  liveActionEnglishTranslated('4_1', 'Live Action - English-translated'),
  liveActionIdolPromotionalVideo('4_2', 'Live Action - Idol/Promotional Video'),
  liveActionNonEnglishTranslated('4_3', 'Live Action - Non-English-translated'),
  liveActionRaw('4_4', 'Live Action - Raw'),
  pictures('5_0', 'Pictures'),
  picturesGraphics('5_1', 'Pictures - Graphics'),
  picturesPhotos('5_2', 'Pictures - Photos'),
  software('6_0', 'Software'),
  softwareApplications('6_1', 'Software - Applications'),
  softwareGames('6_2', 'Software - Games');

  const NyaaCategory(this.code, this.label);
  final String code;
  final String label;

  static NyaaCategory fromCode(String code) => values.firstWhere(
    (value) => value.code == code,
    orElse: () => NyaaCategory.all,
  );
}

enum NyaaTorrentStatus { normal, trusted, remake }

final class NyaaSearchRequest {
  const NyaaSearchRequest({
    required this.query,
    this.filter = NyaaFilter.none,
    this.category = NyaaCategory.all,
    this.page = 1,
  });

  final String query;
  final NyaaFilter filter;
  final NyaaCategory category;
  final int page;
}

final class NyaaSearchPage {
  const NyaaSearchPage({required this.items, this.totalResults});
  final List<NyaaTorrent> items;
  final int? totalResults;
}

final class NyaaTorrent {
  const NyaaTorrent({
    required this.id,
    required this.category,
    required this.name,
    required this.detailsUri,
    required this.torrentUri,
    required this.magnetUri,
    required this.sizeBytes,
    required this.uploadedAt,
    required this.seeders,
    required this.leechers,
    required this.completedDownloads,
    required this.status,
  });

  final int id;
  final NyaaCategory category;
  final String name;
  final Uri detailsUri;
  final Uri torrentUri;
  final Uri magnetUri;
  final int sizeBytes;
  final DateTime uploadedAt;
  final int seeders;
  final int leechers;
  final int completedDownloads;
  final NyaaTorrentStatus status;
}

final class NyaaTorrentFile {
  const NyaaTorrentFile({required this.path, required this.sizeBytes});
  final String path;
  final int sizeBytes;
}

final class NyaaTorrentDetails {
  const NyaaTorrentDetails({
    required this.torrent,
    required this.files,
    this.submitter,
    this.description,
    this.infoHash,
  });
  final NyaaTorrent torrent;
  final List<NyaaTorrentFile> files;
  final String? submitter;
  final String? description;
  final String? infoHash;
}

sealed class NyaaException implements Exception {
  const NyaaException(this.message);
  final String message;
  @override
  String toString() => message;
}

final class NyaaHttpException extends NyaaException {
  const NyaaHttpException(super.message, this.statusCode);
  final int statusCode;
}

final class NyaaParseException extends NyaaException {
  const NyaaParseException(super.message);
}
