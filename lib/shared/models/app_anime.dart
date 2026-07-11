import 'package:anilist_api/anilist_api.dart';

final class AppAnime {
  const AppAnime({
    required this.id,
    required this.url,
    required this.imageUrl,
    required this.title,
    required this.titleSynonyms,
    required this.airing,
    required this.genres,
    required this.tags,
    required this.rankings,
    required this.externalLinks,
    required this.streamingEpisodes,
    required this.relations,
    this.titleEnglish,
    this.titleJapanese,
    this.type,
    this.source,
    this.episodes,
    this.status,
    this.aired,
    this.broadcast,
    this.duration,
    this.rating,
    this.score,
    this.meanScore,
    this.scoredBy,
    this.rank,
    this.popularity,
    this.trending,
    this.members,
    this.favorites,
    this.synopsis,
    this.background,
    this.season,
    this.year,
    this.countryOfOrigin,
    this.hashtag,
    this.nextAiringEpisode,
    this.trailerUrl,
    this.openingThemes,
    this.endingThemes,
  });

  factory AppAnime.fromAnimeData(AnimeData anime) {
    return AppAnime(
      id: anime.id,
      url: anime.siteUrl ?? '',
      imageUrl: anime.coverImage?.extraLarge ?? anime.coverImage?.large ?? '',
      title:
          anime.title?.userPreferred ??
          anime.title?.romaji ??
          anime.title?.english ??
          'Unknown title',
      titleEnglish: anime.titleEnglish,
      titleJapanese: anime.titleNative,
      titleSynonyms: anime.synonyms,
      type: _displayEnumName(anime.format),
      source: _displayEnumName(anime.source),
      episodes: anime.episodes,
      status: _displayEnumName(anime.status),
      airing:
          anime.status == MediaStatus.releasing.graphqlName ||
          anime.nextAiringEpisode != null,
      aired: _dateRange(anime.startDate, anime.endDate),
      duration: anime.duration == null ? null : '${anime.duration} min',
      rating: anime.isAdult == true ? 'Adult' : null,
      score: _score(anime.averageScore),
      meanScore: _score(anime.meanScore),
      scoredBy: _scoredBy(anime.stats),
      rank: _rank(anime.rankings),
      rankings: _rankings(anime.rankings),
      popularity: anime.popularity,
      trending: anime.trending,
      members: anime.popularity,
      favorites: anime.favourites,
      synopsis: _stripHtml(anime.description),
      season: _displayEnumName(anime.season),
      year: anime.seasonYear,
      countryOfOrigin: anime.countryOfOrigin,
      hashtag: anime.hashtag,
      nextAiringEpisode: _nextAiringEpisode(anime.nextAiringEpisode),
      trailerUrl: _trailerUrl(anime.trailer),
      genres: [for (final item in anime.genres) AppAnimeMeta.fromName(item)],
      tags: [
        for (final tag in anime.tags)
          if (tag.isAdult != true && _hasText(tag.name))
            AppAnimeTag(
              id: tag.id,
              name: tag.name,
              category: tag.category,
              rank: tag.rank,
              description: _stripHtml(tag.description),
            ),
      ],
      externalLinks: [
        for (final link in anime.externalLinks)
          if (_hasText(link.site) && _hasText(link.url))
            AppAnimeLink(label: link.site, url: link.url!),
      ],
      streamingEpisodes: [
        for (final episode in anime.streamingEpisodes)
          if (_hasText(episode.title) || _hasText(episode.site))
            AppAnimeStreamingEpisode(
              title: episode.title,
              site: episode.site,
              url: episode.url,
            ),
      ],
      relations: [
        for (final relation in anime.relations)
          if (relation.media != null)
            AppAnimeRelation(
              relationType: _displayEnumName(relation.relationType),
              title:
                  relation.media!.title?.userPreferred ??
                  relation.media!.title?.romaji ??
                  relation.media!.title?.english ??
                  'Unknown title',
            ),
      ],
    );
  }

  factory AppAnime.fromAnimeSearchData(AnimeData anime) =>
      AppAnime.fromAnimeData(anime);

  factory AppAnime.fromAnimeFullData(AnimeFullData anime) {
    return AppAnime.fromAnimeData(anime);
  }

  final int id;
  final String url;
  final String imageUrl;
  final String title;
  final String? titleEnglish;
  final String? titleJapanese;
  final List<String> titleSynonyms;
  final String? type;
  final String? source;
  final int? episodes;
  final String? status;
  final bool airing;
  final String? aired;
  final String? broadcast;
  final String? duration;
  final String? rating;
  final double? score;
  final double? meanScore;
  final int? scoredBy;
  final int? rank;
  final List<AppAnimeRanking> rankings;
  final int? popularity;
  final int? trending;
  final int? members;
  final int? favorites;
  final String? synopsis;
  final String? background;
  final String? season;
  final int? year;
  final String? countryOfOrigin;
  final String? hashtag;
  final String? nextAiringEpisode;
  final String? trailerUrl;
  final List<String>? openingThemes;
  final List<String>? endingThemes;
  final List<AppAnimeMeta> genres;
  final List<AppAnimeTag> tags;
  final List<AppAnimeLink> externalLinks;
  final List<AppAnimeStreamingEpisode> streamingEpisodes;
  final List<AppAnimeRelation> relations;
}

final class AppAnimeMeta {
  const AppAnimeMeta({
    required this.id,
    required this.type,
    required this.name,
    required this.url,
  });

  factory AppAnimeMeta.fromName(String name, {String type = 'genre'}) {
    return AppAnimeMeta(id: name.hashCode, type: type, name: name, url: '');
  }

  final int id;
  final String type;
  final String name;
  final String url;
}

final class AppAnimeTag {
  const AppAnimeTag({
    required this.id,
    required this.name,
    this.category,
    this.rank,
    this.description,
  });

  final int id;
  final String name;
  final String? category;
  final int? rank;
  final String? description;
}

final class AppAnimeRanking {
  const AppAnimeRanking({required this.rank, required this.label});

  final int rank;
  final String label;
}

final class AppAnimeLink {
  const AppAnimeLink({required this.label, required this.url});

  final String label;
  final String url;
}

final class AppAnimeStreamingEpisode {
  const AppAnimeStreamingEpisode({this.title, this.site, this.url});

  final String? title;
  final String? site;
  final String? url;
}

final class AppAnimeRelation {
  const AppAnimeRelation({required this.relationType, required this.title});

  final String? relationType;
  final String title;
}

String? _displayEnumName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  }

  return value
      .split('_')
      .map((part) {
        if (part.length <= 3) {
          return part;
        }
        return part[0] + part.substring(1).toLowerCase();
      })
      .join(' ');
}

double? _score(double? averageScore) {
  return averageScore == null ? null : averageScore / 10;
}

int? _rank(List<MediaRank> rankings) {
  for (final ranking in rankings) {
    if (ranking.type == 'RATED' && ranking.allTime == true) {
      return ranking.rank;
    }
  }
  return rankings.isEmpty ? null : rankings.first.rank;
}

List<AppAnimeRanking> _rankings(List<MediaRank> rankings) {
  return [
    for (final ranking in rankings)
      if (ranking.rank > 0)
        AppAnimeRanking(rank: ranking.rank, label: _rankingLabel(ranking)),
  ];
}

String _rankingLabel(MediaRank ranking) {
  final context = ranking.context.trim();
  if (context.isNotEmpty) {
    return context;
  }

  final type = _displayEnumName(ranking.type) ?? 'Ranking';
  final scope = [
    if (ranking.allTime == true) 'all time',
    if (ranking.allTime != true && _hasText(ranking.season))
      _displayEnumName(ranking.season),
    if (ranking.allTime != true && ranking.year != null)
      ranking.year.toString(),
  ].whereType<String>().join(' ');
  return scope.isEmpty ? type : '$type $scope';
}

int? _scoredBy(MediaStats? stats) {
  final values = stats?.scoreDistribution;
  if (values == null || values.isEmpty) {
    return null;
  }

  var total = 0;
  for (final item in values) {
    total += item.amount ?? 0;
  }
  return total == 0 ? null : total;
}

String? _nextAiringEpisode(AiringScheduleData? airing) {
  if (airing == null) {
    return null;
  }

  final episode = 'Episode ${airing.episode}';
  final timeUntilAiring = airing.timeUntilAiring;
  if (timeUntilAiring <= 0) {
    return episode;
  }

  final days = timeUntilAiring ~/ Duration.secondsPerDay;
  final hours =
      (timeUntilAiring % Duration.secondsPerDay) ~/ Duration.secondsPerHour;
  final remaining = days > 0 ? '${days}d ${hours}h' : '${hours}h';
  return '$episode in $remaining';
}

String? _trailerUrl(MediaTrailer? trailer) {
  final id = trailer?.id;
  if (!_hasText(id)) {
    return null;
  }

  if (trailer?.site?.toLowerCase() == 'youtube') {
    return 'https://www.youtube.com/watch?v=$id';
  }
  return id;
}

String? _dateRange(FuzzyDate? startDate, FuzzyDate? endDate) {
  final start = _date(startDate);
  final end = _date(endDate);
  if (start == null) {
    return end;
  }
  if (end == null || start == end) {
    return start;
  }
  return '$start to $end';
}

String? _date(FuzzyDate? date) {
  final year = date?.year;
  if (year == null) {
    return null;
  }

  final buffer = StringBuffer(year);
  final month = date?.month;
  if (month != null) {
    buffer.write('-${month.toString().padLeft(2, '0')}');
  }
  final day = date?.day;
  if (day != null) {
    buffer.write('-${day.toString().padLeft(2, '0')}');
  }
  return buffer.toString();
}

String? _stripHtml(String? value) {
  if (value == null) {
    return null;
  }

  return value
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&quot;', '"')
      .replaceAll('&#039;', "'")
      .replaceAll('&amp;', '&')
      .trim();
}

bool _hasText(String? value) {
  return value?.trim().isNotEmpty ?? false;
}
