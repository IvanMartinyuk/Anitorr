import 'package:anitorr/shared/services/rate_limited_jikan_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jikan_moe/jikan_moe.dart';

void main() {
  test(
    'retries rate limit errors before returning a successful response',
    () async {
      final client = RateLimitedJikanClient(
        perSecondLimit: 100,
        perMinuteLimit: 100,
        retryDelay: Duration.zero,
      );
      var attempts = 0;

      final result = await client.execute((_) async {
        attempts += 1;
        if (attempts < 3) {
          throw JikanException('{"status":"429","type":"RateLimitException"}');
        }

        return 'ok';
      });

      expect(result, 'ok');
      expect(attempts, 3);
    },
  );

  test('throws rate limit errors after retry limit is exhausted', () async {
    final client = RateLimitedJikanClient(
      perSecondLimit: 100,
      perMinuteLimit: 100,
      maxRetries: 2,
      retryDelay: Duration.zero,
    );
    var attempts = 0;

    final result = client.execute((_) async {
      attempts += 1;
      throw JikanException('{"status":"429","type":"RateLimitException"}');
    });

    await expectLater(result, throwsA(isA<JikanException>()));
    expect(attempts, 3);
  });
}
