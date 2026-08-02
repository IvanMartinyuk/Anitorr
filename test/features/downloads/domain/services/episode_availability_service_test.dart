import 'package:anitorr/features/downloads/domain/services/episode_availability_service.dart';
import 'package:anitorr/shared/models/app_anime.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('does not mix older seasons into the latest Nyaa episode', () {
    final latest = EpisodeAvailabilityService.latestNyaaEpisode(_anime, const [
      'Mushoku Tensei Jobless Reincarnation S03E06 1080p-VARYG',
      '[Erai-raws] Mushoku Tensei III: Isekai Ittara Honki Dasu - 06 [480p]',
      '[SubsPlease] Mushoku Tensei S3 - 06 (1080p) [FB09F4CC].mkv',
      '[SubsPlease] Mushoku Tensei S2 - 11 (1080p) [AAAAAAAA].mkv',
    ]);

    expect(latest, 6);
  });
}

const _anime = AppAnime(
  id: 1,
  url: '',
  imageUrl: '',
  title: 'Mushoku Tensei III: Isekai Ittara Honki Dasu',
  titleEnglish: 'Mushoku Tensei III: Isekai Ittara Honki Dasu',
  titleSynonyms: [],
  airing: true,
  episodes: 11,
  genres: [],
  tags: [],
  rankings: [],
  externalLinks: [],
  streamingEpisodes: [],
  relations: [],
);
