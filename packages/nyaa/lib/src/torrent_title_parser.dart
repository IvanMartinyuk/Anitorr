final class ParsedTorrentTitle {
  const ParsedTorrentTitle({
    required this.original,
    required this.animeName,
    required this.episodes,
    this.publisher,
    this.season,
    this.resolution,
  });

  final String original;
  final String animeName;
  final String? publisher;
  final int? season;
  final Set<int> episodes;
  final String? resolution;
}

abstract final class TorrentTitleParser {
  static ParsedTorrentTitle parse(String input) {
    final normalized = input.replaceAll(RegExp(r'[._]+'), ' ').trim();
    final leadingGroup = RegExp(r'^\[([^\]]+)\]\s*').firstMatch(normalized);
    final body = leadingGroup == null
        ? normalized
        : normalized.substring(leadingGroup.end).trim();
    final resolutionMatch = RegExp(
      r'(?<!\d)(480|576|720|1080|1440|2160|4320)p(?!\w)',
      caseSensitive: false,
    ).firstMatch(body);
    final seasonEpisode = RegExp(
      r'\bS(\d{1,2})\s*E(\d{1,4})(?:\s*[-~+]\s*(?:S\d{1,2}E)?(\d{1,4}))?',
      caseSensitive: false,
    ).firstMatch(body);
    final seasonWord = RegExp(
      r'\bSeason\s+(\d{1,2})\b',
      caseSensitive: false,
    ).firstMatch(body);
    final standaloneSeason = RegExp(
      r'\bS(\d{1,2})(?=\s*-\s*\d)',
      caseSensitive: false,
    ).firstMatch(body);
    final romanSeason = RegExp(
      r'\b(V|IV|III|II)\b',
      caseSensitive: false,
    ).firstMatch(body);
    final episodeWord = RegExp(
      r'\b(?:Episode|Ep)\s*(\d{1,4})(?:\s*[-~+]\s*(\d{1,4}))?',
      caseSensitive: false,
    ).firstMatch(body);
    final dashEpisode = RegExp(
      r'\s-\s(\d{1,3})(?:\s*[-~+]\s*(\d{1,3}))?(?=\s|$)',
    ).firstMatch(body);

    final episodes = <int>{};
    final episodeMatch = seasonEpisode ?? episodeWord ?? dashEpisode;
    if (episodeMatch != null) {
      final isSeasonEpisode = seasonEpisode != null;
      final start = int.parse(episodeMatch.group(isSeasonEpisode ? 2 : 1)!);
      final end =
          int.tryParse(episodeMatch.group(isSeasonEpisode ? 3 : 2) ?? '') ??
          start;
      if (end >= start && end - start <= 200) {
        for (var episode = start; episode <= end; episode++) {
          episodes.add(episode);
        }
      }
    }

    final indexes = [
      seasonEpisode?.start,
      seasonWord?.start,
      standaloneSeason?.start,
      romanSeason?.start,
      episodeWord?.start,
      dashEpisode?.start,
      resolutionMatch?.start,
    ].whereType<int>().toList();
    indexes.sort();
    var animeName = (indexes.isEmpty ? body : body.substring(0, indexes.first))
        .replaceAll(RegExp(r'\s+-\s*$'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    String? publisher = leadingGroup?.group(1)?.trim();
    if (publisher == null) {
      final matches = RegExp(
        r'-([A-Za-z][A-Za-z0-9 ._-]{1,30})(?=\s*(?:\(|\[|$))',
      ).allMatches(body).toList();
      publisher = matches.isEmpty ? null : matches.last.group(1)?.trim();
      publisher = publisher?.replaceFirst(
        RegExp(r'^(?:DL|Rip|Encode)-', caseSensitive: false),
        '',
      );
    }
    if (animeName.isEmpty) animeName = body;

    return ParsedTorrentTitle(
      original: input,
      animeName: animeName,
      publisher: publisher,
      season:
          int.tryParse(
            seasonEpisode?.group(1) ??
                seasonWord?.group(1) ??
                standaloneSeason?.group(1) ??
                '',
          ) ??
          _romanNumber(romanSeason?.group(1)),
      episodes: episodes,
      resolution: resolutionMatch == null
          ? null
          : '${resolutionMatch.group(1)}p',
    );
  }

  static int? _romanNumber(String? value) {
    return switch (value?.toUpperCase()) {
      'II' => 2,
      'III' => 3,
      'IV' => 4,
      'V' => 5,
      _ => null,
    };
  }
}
