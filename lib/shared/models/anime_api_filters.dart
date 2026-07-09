enum AppAnimeType {
  tv('TV', 'tv'),
  movie('Movie', 'movie'),
  ova('OVA', 'ova'),
  ona('ONA', 'ona'),
  special('Special', 'special'),
  music('Music', 'music'),
  cm('CM', 'cm'),
  pv('PV', 'pv'),
  tvSpecial('TV Special', 'tv_special');

  const AppAnimeType(this.label, this.apiValue);

  final String label;
  final String apiValue;
}

enum AnimeSearchStatus {
  airing('Airing', 'airing'),
  complete('Complete', 'complete'),
  upcoming('Upcoming', 'upcoming');

  const AnimeSearchStatus(this.label, this.apiValue);

  final String label;
  final String apiValue;
}

enum AnimeSearchRating {
  g('G - All Ages', 'g'),
  pg('PG - Children', 'pg'),
  pg13('PG-13 - Teens 13 or older', 'pg13'),
  r17('R - 17+ (violence & profanity)', 'r17'),
  rPlus('R+ - Mild Nudity', 'r'),
  rx('Rx - Hentai', 'rx');

  const AnimeSearchRating(this.label, this.apiValue);

  final String label;
  final String apiValue;
}
