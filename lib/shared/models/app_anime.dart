import 'package:jikan_moe/jikan_moe.dart';

final class AppAnime {
  const AppAnime({
    required this.malId,
    required this.url,
    required this.imageUrl,
    required this.title,
    required this.titleSynonyms,
    required this.airing,
    required this.genres,
    required this.explicitGenres,
    required this.themes,
    required this.demographics,
    required this.producers,
    required this.licensors,
    required this.studios,
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
    this.scoredBy,
    this.rank,
    this.popularity,
    this.members,
    this.favorites,
    this.synopsis,
    this.background,
    this.season,
    this.year,
    this.trailerUrl,
    this.openingThemes,
    this.endingThemes,
  });

  factory AppAnime.fromAnimeData(AnimeData anime) {
    return AppAnime(
      malId: anime.malId,
      url: anime.url,
      imageUrl: anime.images.jpg.imageUrl,
      title: anime.title,
      titleEnglish: anime.titleEnglish,
      titleJapanese: anime.titleJapanese,
      titleSynonyms: anime.titleSynonyms,
      type: anime.type,
      source: anime.source,
      episodes: anime.episodes,
      status: anime.status,
      airing: anime.airing,
      aired: anime.aired.string,
      broadcast: anime.broadcast?.string,
      duration: anime.duration,
      rating: anime.rating,
      score: anime.score,
      scoredBy: anime.scoredBy,
      rank: anime.rank,
      popularity: anime.popularity,
      members: anime.members,
      favorites: anime.favorites,
      synopsis: anime.synopsis,
      background: anime.background,
      season: anime.season,
      year: anime.year,
      trailerUrl: anime.trailer.url,
      genres: [
        for (final item in anime.genres) AppAnimeMeta.fromAnimeGenre(item),
      ],
      explicitGenres: [
        for (final item in anime.explicitGenres)
          AppAnimeMeta.fromAnimeGenre(item),
      ],
      themes: [
        for (final item in anime.themes) AppAnimeMeta.fromAnimeGenre(item),
      ],
      demographics: [
        for (final item in anime.demographics)
          AppAnimeMeta.fromAnimeGenre(item),
      ],
      producers: [
        for (final item in anime.producers)
          AppAnimeMeta.fromAnimeProducer(item),
      ],
      licensors: [
        for (final item in anime.licensors)
          AppAnimeMeta.fromAnimeProducer(item),
      ],
      studios: [
        for (final item in anime.studios) AppAnimeMeta.fromAnimeProducer(item),
      ],
    );
  }

  factory AppAnime.fromAnimeSearchData(AnimeSearchData anime) {
    return AppAnime(
      malId: anime.malId,
      url: anime.url,
      imageUrl: anime.images.jpg.imageUrl ?? '',
      title: anime.title,
      titleEnglish: anime.titleEnglish,
      titleJapanese: anime.titleJapanese,
      titleSynonyms: anime.titleSynonyms,
      type: anime.type,
      source: anime.source,
      episodes: anime.episodes,
      status: anime.status,
      airing: anime.airing,
      aired: anime.aired.string,
      broadcast: anime.broadcast.string,
      duration: anime.duration,
      rating: anime.rating,
      score: anime.score,
      scoredBy: anime.scoredBy,
      rank: anime.rank,
      popularity: anime.popularity,
      members: anime.members,
      favorites: anime.favorites,
      synopsis: anime.synopsis,
      background: anime.background,
      season: anime.season,
      year: anime.year,
      trailerUrl: anime.trailer.url,
      genres: [
        for (final item in anime.genres)
          AppAnimeMeta.fromAnimeSearchGenre(item),
      ],
      explicitGenres: [
        for (final item in anime.explicitGenres)
          AppAnimeMeta.fromAnimeSearchGenre(item),
      ],
      themes: [
        for (final item in anime.themes)
          AppAnimeMeta.fromAnimeSearchGenre(item),
      ],
      demographics: [
        for (final item in anime.demographics)
          AppAnimeMeta.fromAnimeSearchGenre(item),
      ],
      producers: [
        for (final item in anime.producers)
          AppAnimeMeta.fromAnimeSearchProducer(item),
      ],
      licensors: [
        for (final item in anime.licensors)
          AppAnimeMeta.fromAnimeSearchProducer(item),
      ],
      studios: [
        for (final item in anime.studios)
          AppAnimeMeta.fromAnimeSearchProducer(item),
      ],
    );
  }

  factory AppAnime.fromAnimeFullData(AnimeFullData anime) {
    return AppAnime(
      malId: anime.malId,
      url: anime.url,
      imageUrl: anime.images.jpg.imageUrl,
      title: anime.title,
      titleEnglish: anime.titleEnglish,
      titleJapanese: anime.titleJapanese,
      titleSynonyms: anime.titleSynonyms,
      type: anime.type,
      source: anime.source,
      episodes: anime.episodes,
      status: anime.status,
      airing: anime.airing,
      aired: anime.aired.string,
      broadcast: anime.broadcast?.string,
      duration: anime.duration,
      rating: anime.rating,
      score: anime.score,
      scoredBy: anime.scoredBy,
      rank: anime.rank,
      popularity: anime.popularity,
      members: anime.members,
      favorites: anime.favorites,
      synopsis: anime.synopsis,
      background: anime.background,
      season: anime.season,
      year: anime.year,
      trailerUrl: anime.trailer.url,
      openingThemes: anime.theme.openings,
      endingThemes: anime.theme.endings,
      genres: [
        for (final item in anime.genres) AppAnimeMeta.fromAnimeGenre(item),
      ],
      explicitGenres: [
        for (final item in anime.explicitGenres)
          AppAnimeMeta.fromAnimeGenre(item),
      ],
      themes: [
        for (final item in anime.themes) AppAnimeMeta.fromAnimeGenre(item),
      ],
      demographics: [
        for (final item in anime.demographics)
          AppAnimeMeta.fromAnimeGenre(item),
      ],
      producers: [
        for (final item in anime.producers)
          AppAnimeMeta.fromAnimeProducer(item),
      ],
      licensors: [
        for (final item in anime.licensors)
          AppAnimeMeta.fromAnimeProducer(item),
      ],
      studios: [
        for (final item in anime.studios) AppAnimeMeta.fromAnimeProducer(item),
      ],
    );
  }

  final int malId;
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
  final int? scoredBy;
  final int? rank;
  final int? popularity;
  final int? members;
  final int? favorites;
  final String? synopsis;
  final String? background;
  final String? season;
  final int? year;
  final String? trailerUrl;
  final List<String>? openingThemes;
  final List<String>? endingThemes;
  final List<AppAnimeMeta> genres;
  final List<AppAnimeMeta> explicitGenres;
  final List<AppAnimeMeta> themes;
  final List<AppAnimeMeta> demographics;
  final List<AppAnimeMeta> producers;
  final List<AppAnimeMeta> licensors;
  final List<AppAnimeMeta> studios;
}

final class AppAnimeMeta {
  const AppAnimeMeta({
    required this.malId,
    required this.type,
    required this.name,
    required this.url,
  });

  factory AppAnimeMeta.fromAnimeGenre(AnimeGenre meta) {
    return AppAnimeMeta(
      malId: meta.malId,
      type: meta.type,
      name: meta.name,
      url: meta.url,
    );
  }

  factory AppAnimeMeta.fromAnimeSearchGenre(AnimeSearchGenre meta) {
    return AppAnimeMeta(
      malId: meta.malId,
      type: meta.type,
      name: meta.name,
      url: meta.url,
    );
  }

  factory AppAnimeMeta.fromAnimeProducer(AnimeProducer meta) {
    return AppAnimeMeta(
      malId: meta.malId,
      type: meta.type,
      name: meta.name,
      url: meta.url,
    );
  }

  factory AppAnimeMeta.fromAnimeSearchProducer(AnimeSearchProducer meta) {
    return AppAnimeMeta(
      malId: meta.malId,
      type: meta.type,
      name: meta.name,
      url: meta.url,
    );
  }

  final int malId;
  final String type;
  final String name;
  final String url;
}
