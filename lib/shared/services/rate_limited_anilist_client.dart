import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:anilist_api/anilist_api.dart';

final class RateLimitedAniListClient {
  RateLimitedAniListClient({
    AniListClient? client,
    this.perSecondLimit = 3,
    this.perMinuteLimit = 60,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  }) : _client = client ?? AniListClient();

  static final instance = RateLimitedAniListClient();

  final AniListClient _client;
  final int perSecondLimit;
  final int perMinuteLimit;
  final int maxRetries;
  final Duration retryDelay;
  final Queue<_QueuedAniListRequest<dynamic>> _queue = Queue();
  final List<DateTime> _requestStarts = [];
  bool _isProcessing = false;

  Future<AnimeFullData> getAnimeFullById(int id) {
    return execute((client) => client.getAnimeFullById(id));
  }

  Future<AnimeSearchResponse> getAnimeSearch({
    int page = 1,
    int perPage = 25,
    String? q,
    MediaFormat? format,
    MediaStatus? status,
    int? averageScoreGreater,
    int? averageScoreLesser,
    int? startDateGreater,
    int? startDateLesser,
    List<String>? genres,
    List<String>? genresNotIn,
    List<String>? tags,
    List<String>? tagsNotIn,
    List<MediaSort>? sort,
    bool? isAdult,
  }) {
    return execute(
      (client) => client.getAnimeSearch(
        page: page,
        perPage: perPage,
        q: q,
        format: format,
        status: status,
        averageScoreGreater: averageScoreGreater,
        averageScoreLesser: averageScoreLesser,
        startDateGreater: startDateGreater,
        startDateLesser: startDateLesser,
        genres: genres,
        genresNotIn: genresNotIn,
        tags: tags,
        tagsNotIn: tagsNotIn,
        sort: sort,
        isAdult: isAdult,
      ),
    );
  }

  Future<SeasonAnimeResponse> getSeasonNow({
    int page = 1,
    int perPage = 25,
    MediaFormat? format,
    List<MediaSort>? sort,
    bool? isAdult,
  }) {
    final now = DateTime.now();
    return execute((client) async {
      final response = await client.getAnimeSearch(
        seasonYear: now.year,
        season: _seasonForMonth(now.month),
        format: format,
        page: page,
        perPage: perPage,
        sort: sort ?? const [MediaSort.popularityDesc],
        isAdult: isAdult,
      );
      return SeasonAnimeResponse(
        pageInfo: response.pageInfo,
        data: response.data,
      );
    });
  }

  Future<List<String>> getGenres() {
    return execute((client) => client.getGenres());
  }

  Future<List<MediaTag>> getMediaTags() {
    return execute((client) => client.getMediaTags());
  }

  Future<T> execute<T>(Future<T> Function(AniListClient client) request) {
    final task = _QueuedAniListRequest<T>(request);
    _queue.add(task);
    unawaited(_processQueue());
    return task.completer.future;
  }

  Future<void> _processQueue() async {
    if (_isProcessing) {
      return;
    }

    _isProcessing = true;
    try {
      while (_queue.isNotEmpty) {
        final task = _queue.removeFirst();
        try {
          final result = await _executeWithRetries(task.request);
          task.completer.complete(result);
        } catch (error, stackTrace) {
          task.completer.completeError(error, stackTrace);
        }
      }
    } finally {
      _isProcessing = false;
      if (_queue.isNotEmpty) {
        unawaited(_processQueue());
      }
    }
  }

  Future<T> _executeWithRetries<T>(
    Future<T> Function(AniListClient client) request,
  ) async {
    var retryCount = 0;

    while (true) {
      await _waitForAvailableSlot();
      _requestStarts.add(DateTime.now());

      try {
        return await request(_client);
      } catch (error) {
        if (!_isRateLimitError(error) || retryCount >= maxRetries) {
          rethrow;
        }

        retryCount += 1;
        await Future<void>.delayed(_retryDelayFor(retryCount));
      }
    }
  }

  Future<void> _waitForAvailableSlot() async {
    while (true) {
      final delay = _delayUntilAvailableSlot();
      if (delay == Duration.zero) {
        return;
      }

      await Future<void>.delayed(delay);
    }
  }

  Duration _delayUntilAvailableSlot() {
    final now = DateTime.now();
    _requestStarts.removeWhere((startedAt) {
      return now.difference(startedAt) >= const Duration(minutes: 1);
    });

    final secondWindow = _activeStartsSince(
      now.subtract(const Duration(seconds: 1)),
    );
    final minuteWindow = _requestStarts;
    final delays = <Duration>[];

    if (secondWindow.length >= perSecondLimit) {
      delays.add(
        _remainingDelay(now, secondWindow.first, const Duration(seconds: 1)),
      );
    }

    if (minuteWindow.length >= perMinuteLimit) {
      delays.add(
        _remainingDelay(now, minuteWindow.first, const Duration(minutes: 1)),
      );
    }

    if (delays.isEmpty) {
      return Duration.zero;
    }

    return delays.reduce((a, b) => a > b ? a : b);
  }

  List<DateTime> _activeStartsSince(DateTime threshold) {
    return [
      for (final startedAt in _requestStarts)
        if (startedAt.isAfter(threshold)) startedAt,
    ];
  }

  Duration _remainingDelay(DateTime now, DateTime startedAt, Duration window) {
    final elapsed = now.difference(startedAt);
    final remaining = window - elapsed;
    if (remaining <= Duration.zero) {
      return Duration.zero;
    }

    return remaining + const Duration(milliseconds: 50);
  }

  Duration _retryDelayFor(int retryCount) {
    final multiplier = pow(2, retryCount - 1).toInt();
    return retryDelay * multiplier;
  }

  bool _isRateLimitError(Object error) {
    return error is AniListRateLimitException;
  }

  MediaSeason _seasonForMonth(int month) {
    if (month <= 3) {
      return MediaSeason.winter;
    }
    if (month <= 6) {
      return MediaSeason.spring;
    }
    if (month <= 9) {
      return MediaSeason.summer;
    }
    return MediaSeason.fall;
  }
}

final class _QueuedAniListRequest<T> {
  _QueuedAniListRequest(this.request);

  final Future<T> Function(AniListClient client) request;
  final Completer<T> completer = Completer<T>();
}
