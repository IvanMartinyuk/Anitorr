import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:jikan_moe/jikan_moe.dart';

final class RateLimitedJikanClient {
  RateLimitedJikanClient({
    JikanClient? client,
    this.perSecondLimit = 3,
    this.perMinuteLimit = 60,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  }) : _client = client ?? JikanClient();

  static final instance = RateLimitedJikanClient();

  final JikanClient _client;
  final int perSecondLimit;
  final int perMinuteLimit;
  final int maxRetries;
  final Duration retryDelay;
  final Queue<_QueuedJikanRequest<dynamic>> _queue = Queue();
  final List<DateTime> _requestStarts = [];
  bool _isProcessing = false;

  Future<AnimeFullData> getAnimeFullById(int id) {
    return execute((client) => client.getAnimeFullById(id));
  }

  Future<AnimeSearchResponse> getAnimeSearch({
    bool unapproved = false,
    int? page = 1,
    int? limit = 25,
    String? q,
    String? type,
    double? score,
    double? minScore,
    double? maxScore,
    String? status,
    String? rating,
    bool? sfw = true,
    String? genres,
    String? genresExclude,
    String? orderBy,
    String? sort,
    String? letter,
    String? producers,
    String? startDate,
    String? endDate,
  }) {
    return execute(
      (client) => client.getAnimeSearch(
        unapproved: unapproved,
        page: page,
        limit: limit,
        q: q,
        type: type,
        score: score,
        minScore: minScore,
        maxScore: maxScore,
        status: status,
        rating: rating,
        sfw: sfw,
        genres: genres,
        genresExclude: genresExclude,
        orderBy: orderBy,
        sort: sort,
        letter: letter,
        producers: producers,
        startDate: startDate,
        endDate: endDate,
      ),
    );
  }

  Future<SeasonNowResponse> getSeasonNow({
    String? filter,
    bool? sfw,
    bool? unapproved,
    bool? continuing,
    int page = 1,
    int limit = 25,
  }) {
    return execute(
      (client) => client.getSeasonNow(
        filter: filter,
        sfw: sfw,
        unapproved: unapproved,
        continuing: continuing,
        page: page,
        limit: limit,
      ),
    );
  }

  Future<List<AnimeGenreData>> getAnimeGenres({String? filter}) {
    return execute((client) => client.getAnimeGenres(filter: filter));
  }

  Future<T> execute<T>(Future<T> Function(JikanClient client) request) {
    final task = _QueuedJikanRequest<T>(request);
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
    Future<T> Function(JikanClient client) request,
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
    if (error is! JikanException) {
      return false;
    }

    final message = error.message.toLowerCase();
    return message.contains('"status": "429"') ||
        message.contains('"status":"429"') ||
        message.contains('ratelimitexception') ||
        message.contains('rate-limited');
  }
}

final class _QueuedJikanRequest<T> {
  _QueuedJikanRequest(this.request);

  final Future<T> Function(JikanClient client) request;
  final Completer<T> completer = Completer<T>();
}
