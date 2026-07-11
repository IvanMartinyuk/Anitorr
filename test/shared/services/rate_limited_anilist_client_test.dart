import 'package:anilist_api/anilist_api.dart';
import 'package:anitorr/shared/services/rate_limited_anilist_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'retries rate limit errors before returning a successful response',
    () async {
      final client = RateLimitedAniListClient(
        perSecondLimit: 100,
        perMinuteLimit: 100,
        retryDelay: Duration.zero,
      );
      var attempts = 0;

      final result = await client.execute((_) async {
        attempts += 1;
        if (attempts < 3) {
          throw const AniListRateLimitException('Rate limited.');
        }

        return 'ok';
      });

      expect(result, 'ok');
      expect(attempts, 3);
    },
  );

  test('throws rate limit errors after retry limit is exhausted', () async {
    final client = RateLimitedAniListClient(
      perSecondLimit: 100,
      perMinuteLimit: 100,
      maxRetries: 2,
      retryDelay: Duration.zero,
    );
    var attempts = 0;

    final result = client.execute((_) async {
      attempts += 1;
      throw const AniListRateLimitException('Rate limited.');
    });

    await expectLater(result, throwsA(isA<AniListRateLimitException>()));
    expect(attempts, 3);
  });
}
