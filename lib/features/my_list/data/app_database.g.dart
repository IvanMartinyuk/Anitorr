// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AnimeSnapshotsTable extends AnimeSnapshots
    with TableInfo<$AnimeSnapshotsTable, AnimeSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AnimeSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleEnglishMeta = const VerificationMeta(
    'titleEnglish',
  );
  @override
  late final GeneratedColumn<String> titleEnglish = GeneratedColumn<String>(
    'title_english',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _episodesMeta = const VerificationMeta(
    'episodes',
  );
  @override
  late final GeneratedColumn<int> episodes = GeneratedColumn<int>(
    'episodes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _airingMeta = const VerificationMeta('airing');
  @override
  late final GeneratedColumn<bool> airing = GeneratedColumn<bool>(
    'airing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("airing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    titleEnglish,
    imageUrl,
    type,
    episodes,
    score,
    year,
    airing,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'anime_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnimeSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('title_english')) {
      context.handle(
        _titleEnglishMeta,
        titleEnglish.isAcceptableOrUnknown(
          data['title_english']!,
          _titleEnglishMeta,
        ),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    } else if (isInserting) {
      context.missing(_imageUrlMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    }
    if (data.containsKey('episodes')) {
      context.handle(
        _episodesMeta,
        episodes.isAcceptableOrUnknown(data['episodes']!, _episodesMeta),
      );
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    }
    if (data.containsKey('airing')) {
      context.handle(
        _airingMeta,
        airing.isAcceptableOrUnknown(data['airing']!, _airingMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AnimeSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnimeSnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      titleEnglish: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_english'],
      ),
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      ),
      episodes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}episodes'],
      ),
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      ),
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      ),
      airing: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}airing'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AnimeSnapshotsTable createAlias(String alias) {
    return $AnimeSnapshotsTable(attachedDatabase, alias);
  }
}

class AnimeSnapshot extends DataClass implements Insertable<AnimeSnapshot> {
  final int id;
  final String title;
  final String? titleEnglish;
  final String imageUrl;
  final String? type;
  final int? episodes;
  final double? score;
  final int? year;
  final bool airing;
  final DateTime updatedAt;
  const AnimeSnapshot({
    required this.id,
    required this.title,
    this.titleEnglish,
    required this.imageUrl,
    this.type,
    this.episodes,
    this.score,
    this.year,
    required this.airing,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || titleEnglish != null) {
      map['title_english'] = Variable<String>(titleEnglish);
    }
    map['image_url'] = Variable<String>(imageUrl);
    if (!nullToAbsent || type != null) {
      map['type'] = Variable<String>(type);
    }
    if (!nullToAbsent || episodes != null) {
      map['episodes'] = Variable<int>(episodes);
    }
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<double>(score);
    }
    if (!nullToAbsent || year != null) {
      map['year'] = Variable<int>(year);
    }
    map['airing'] = Variable<bool>(airing);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AnimeSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return AnimeSnapshotsCompanion(
      id: Value(id),
      title: Value(title),
      titleEnglish: titleEnglish == null && nullToAbsent
          ? const Value.absent()
          : Value(titleEnglish),
      imageUrl: Value(imageUrl),
      type: type == null && nullToAbsent ? const Value.absent() : Value(type),
      episodes: episodes == null && nullToAbsent
          ? const Value.absent()
          : Value(episodes),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      year: year == null && nullToAbsent ? const Value.absent() : Value(year),
      airing: Value(airing),
      updatedAt: Value(updatedAt),
    );
  }

  factory AnimeSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnimeSnapshot(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      titleEnglish: serializer.fromJson<String?>(json['titleEnglish']),
      imageUrl: serializer.fromJson<String>(json['imageUrl']),
      type: serializer.fromJson<String?>(json['type']),
      episodes: serializer.fromJson<int?>(json['episodes']),
      score: serializer.fromJson<double?>(json['score']),
      year: serializer.fromJson<int?>(json['year']),
      airing: serializer.fromJson<bool>(json['airing']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'titleEnglish': serializer.toJson<String?>(titleEnglish),
      'imageUrl': serializer.toJson<String>(imageUrl),
      'type': serializer.toJson<String?>(type),
      'episodes': serializer.toJson<int?>(episodes),
      'score': serializer.toJson<double?>(score),
      'year': serializer.toJson<int?>(year),
      'airing': serializer.toJson<bool>(airing),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AnimeSnapshot copyWith({
    int? id,
    String? title,
    Value<String?> titleEnglish = const Value.absent(),
    String? imageUrl,
    Value<String?> type = const Value.absent(),
    Value<int?> episodes = const Value.absent(),
    Value<double?> score = const Value.absent(),
    Value<int?> year = const Value.absent(),
    bool? airing,
    DateTime? updatedAt,
  }) => AnimeSnapshot(
    id: id ?? this.id,
    title: title ?? this.title,
    titleEnglish: titleEnglish.present ? titleEnglish.value : this.titleEnglish,
    imageUrl: imageUrl ?? this.imageUrl,
    type: type.present ? type.value : this.type,
    episodes: episodes.present ? episodes.value : this.episodes,
    score: score.present ? score.value : this.score,
    year: year.present ? year.value : this.year,
    airing: airing ?? this.airing,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AnimeSnapshot copyWithCompanion(AnimeSnapshotsCompanion data) {
    return AnimeSnapshot(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      titleEnglish: data.titleEnglish.present
          ? data.titleEnglish.value
          : this.titleEnglish,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      type: data.type.present ? data.type.value : this.type,
      episodes: data.episodes.present ? data.episodes.value : this.episodes,
      score: data.score.present ? data.score.value : this.score,
      year: data.year.present ? data.year.value : this.year,
      airing: data.airing.present ? data.airing.value : this.airing,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnimeSnapshot(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleEnglish: $titleEnglish, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('type: $type, ')
          ..write('episodes: $episodes, ')
          ..write('score: $score, ')
          ..write('year: $year, ')
          ..write('airing: $airing, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    titleEnglish,
    imageUrl,
    type,
    episodes,
    score,
    year,
    airing,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnimeSnapshot &&
          other.id == this.id &&
          other.title == this.title &&
          other.titleEnglish == this.titleEnglish &&
          other.imageUrl == this.imageUrl &&
          other.type == this.type &&
          other.episodes == this.episodes &&
          other.score == this.score &&
          other.year == this.year &&
          other.airing == this.airing &&
          other.updatedAt == this.updatedAt);
}

class AnimeSnapshotsCompanion extends UpdateCompanion<AnimeSnapshot> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> titleEnglish;
  final Value<String> imageUrl;
  final Value<String?> type;
  final Value<int?> episodes;
  final Value<double?> score;
  final Value<int?> year;
  final Value<bool> airing;
  final Value<DateTime> updatedAt;
  const AnimeSnapshotsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.titleEnglish = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.type = const Value.absent(),
    this.episodes = const Value.absent(),
    this.score = const Value.absent(),
    this.year = const Value.absent(),
    this.airing = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  AnimeSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.titleEnglish = const Value.absent(),
    required String imageUrl,
    this.type = const Value.absent(),
    this.episodes = const Value.absent(),
    this.score = const Value.absent(),
    this.year = const Value.absent(),
    this.airing = const Value.absent(),
    required DateTime updatedAt,
  }) : title = Value(title),
       imageUrl = Value(imageUrl),
       updatedAt = Value(updatedAt);
  static Insertable<AnimeSnapshot> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? titleEnglish,
    Expression<String>? imageUrl,
    Expression<String>? type,
    Expression<int>? episodes,
    Expression<double>? score,
    Expression<int>? year,
    Expression<bool>? airing,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (titleEnglish != null) 'title_english': titleEnglish,
      if (imageUrl != null) 'image_url': imageUrl,
      if (type != null) 'type': type,
      if (episodes != null) 'episodes': episodes,
      if (score != null) 'score': score,
      if (year != null) 'year': year,
      if (airing != null) 'airing': airing,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  AnimeSnapshotsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? titleEnglish,
    Value<String>? imageUrl,
    Value<String?>? type,
    Value<int?>? episodes,
    Value<double?>? score,
    Value<int?>? year,
    Value<bool>? airing,
    Value<DateTime>? updatedAt,
  }) {
    return AnimeSnapshotsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      titleEnglish: titleEnglish ?? this.titleEnglish,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      episodes: episodes ?? this.episodes,
      score: score ?? this.score,
      year: year ?? this.year,
      airing: airing ?? this.airing,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (titleEnglish.present) {
      map['title_english'] = Variable<String>(titleEnglish.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (episodes.present) {
      map['episodes'] = Variable<int>(episodes.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (airing.present) {
      map['airing'] = Variable<bool>(airing.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnimeSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('titleEnglish: $titleEnglish, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('type: $type, ')
          ..write('episodes: $episodes, ')
          ..write('score: $score, ')
          ..write('year: $year, ')
          ..write('airing: $airing, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $UserAnimeEntriesTable extends UserAnimeEntries
    with TableInfo<$UserAnimeEntriesTable, UserAnimeEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserAnimeEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _animeIdMeta = const VerificationMeta(
    'animeId',
  );
  @override
  late final GeneratedColumn<int> animeId = GeneratedColumn<int>(
    'anime_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES anime_snapshots (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _progressMeta = const VerificationMeta(
    'progress',
  );
  @override
  late final GeneratedColumn<int> progress = GeneratedColumn<int>(
    'progress',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _userScoreMeta = const VerificationMeta(
    'userScore',
  );
  @override
  late final GeneratedColumn<double> userScore = GeneratedColumn<double>(
    'user_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _rewatchCountMeta = const VerificationMeta(
    'rewatchCount',
  );
  @override
  late final GeneratedColumn<int> rewatchCount = GeneratedColumn<int>(
    'rewatch_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    animeId,
    status,
    progress,
    userScore,
    startedAt,
    completedAt,
    rewatchCount,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_anime_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserAnimeEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('anime_id')) {
      context.handle(
        _animeIdMeta,
        animeId.isAcceptableOrUnknown(data['anime_id']!, _animeIdMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('progress')) {
      context.handle(
        _progressMeta,
        progress.isAcceptableOrUnknown(data['progress']!, _progressMeta),
      );
    }
    if (data.containsKey('user_score')) {
      context.handle(
        _userScoreMeta,
        userScore.isAcceptableOrUnknown(data['user_score']!, _userScoreMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('rewatch_count')) {
      context.handle(
        _rewatchCountMeta,
        rewatchCount.isAcceptableOrUnknown(
          data['rewatch_count']!,
          _rewatchCountMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {animeId};
  @override
  UserAnimeEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserAnimeEntry(
      animeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anime_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      progress: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}progress'],
      )!,
      userScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}user_score'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      ),
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      rewatchCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rewatch_count'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserAnimeEntriesTable createAlias(String alias) {
    return $UserAnimeEntriesTable(attachedDatabase, alias);
  }
}

class UserAnimeEntry extends DataClass implements Insertable<UserAnimeEntry> {
  final int animeId;
  final String status;
  final int progress;
  final double? userScore;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final int rewatchCount;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserAnimeEntry({
    required this.animeId,
    required this.status,
    required this.progress,
    this.userScore,
    this.startedAt,
    this.completedAt,
    required this.rewatchCount,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['anime_id'] = Variable<int>(animeId);
    map['status'] = Variable<String>(status);
    map['progress'] = Variable<int>(progress);
    if (!nullToAbsent || userScore != null) {
      map['user_score'] = Variable<double>(userScore);
    }
    if (!nullToAbsent || startedAt != null) {
      map['started_at'] = Variable<DateTime>(startedAt);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    map['rewatch_count'] = Variable<int>(rewatchCount);
    map['notes'] = Variable<String>(notes);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserAnimeEntriesCompanion toCompanion(bool nullToAbsent) {
    return UserAnimeEntriesCompanion(
      animeId: Value(animeId),
      status: Value(status),
      progress: Value(progress),
      userScore: userScore == null && nullToAbsent
          ? const Value.absent()
          : Value(userScore),
      startedAt: startedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      rewatchCount: Value(rewatchCount),
      notes: Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserAnimeEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserAnimeEntry(
      animeId: serializer.fromJson<int>(json['animeId']),
      status: serializer.fromJson<String>(json['status']),
      progress: serializer.fromJson<int>(json['progress']),
      userScore: serializer.fromJson<double?>(json['userScore']),
      startedAt: serializer.fromJson<DateTime?>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      rewatchCount: serializer.fromJson<int>(json['rewatchCount']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'animeId': serializer.toJson<int>(animeId),
      'status': serializer.toJson<String>(status),
      'progress': serializer.toJson<int>(progress),
      'userScore': serializer.toJson<double?>(userScore),
      'startedAt': serializer.toJson<DateTime?>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'rewatchCount': serializer.toJson<int>(rewatchCount),
      'notes': serializer.toJson<String>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserAnimeEntry copyWith({
    int? animeId,
    String? status,
    int? progress,
    Value<double?> userScore = const Value.absent(),
    Value<DateTime?> startedAt = const Value.absent(),
    Value<DateTime?> completedAt = const Value.absent(),
    int? rewatchCount,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserAnimeEntry(
    animeId: animeId ?? this.animeId,
    status: status ?? this.status,
    progress: progress ?? this.progress,
    userScore: userScore.present ? userScore.value : this.userScore,
    startedAt: startedAt.present ? startedAt.value : this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    rewatchCount: rewatchCount ?? this.rewatchCount,
    notes: notes ?? this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserAnimeEntry copyWithCompanion(UserAnimeEntriesCompanion data) {
    return UserAnimeEntry(
      animeId: data.animeId.present ? data.animeId.value : this.animeId,
      status: data.status.present ? data.status.value : this.status,
      progress: data.progress.present ? data.progress.value : this.progress,
      userScore: data.userScore.present ? data.userScore.value : this.userScore,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      rewatchCount: data.rewatchCount.present
          ? data.rewatchCount.value
          : this.rewatchCount,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserAnimeEntry(')
          ..write('animeId: $animeId, ')
          ..write('status: $status, ')
          ..write('progress: $progress, ')
          ..write('userScore: $userScore, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rewatchCount: $rewatchCount, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    animeId,
    status,
    progress,
    userScore,
    startedAt,
    completedAt,
    rewatchCount,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserAnimeEntry &&
          other.animeId == this.animeId &&
          other.status == this.status &&
          other.progress == this.progress &&
          other.userScore == this.userScore &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.rewatchCount == this.rewatchCount &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserAnimeEntriesCompanion extends UpdateCompanion<UserAnimeEntry> {
  final Value<int> animeId;
  final Value<String> status;
  final Value<int> progress;
  final Value<double?> userScore;
  final Value<DateTime?> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int> rewatchCount;
  final Value<String> notes;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const UserAnimeEntriesCompanion({
    this.animeId = const Value.absent(),
    this.status = const Value.absent(),
    this.progress = const Value.absent(),
    this.userScore = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rewatchCount = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserAnimeEntriesCompanion.insert({
    this.animeId = const Value.absent(),
    required String status,
    this.progress = const Value.absent(),
    this.userScore = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rewatchCount = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : status = Value(status),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserAnimeEntry> custom({
    Expression<int>? animeId,
    Expression<String>? status,
    Expression<int>? progress,
    Expression<double>? userScore,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? rewatchCount,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (animeId != null) 'anime_id': animeId,
      if (status != null) 'status': status,
      if (progress != null) 'progress': progress,
      if (userScore != null) 'user_score': userScore,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (rewatchCount != null) 'rewatch_count': rewatchCount,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserAnimeEntriesCompanion copyWith({
    Value<int>? animeId,
    Value<String>? status,
    Value<int>? progress,
    Value<double?>? userScore,
    Value<DateTime?>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int>? rewatchCount,
    Value<String>? notes,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return UserAnimeEntriesCompanion(
      animeId: animeId ?? this.animeId,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      userScore: userScore ?? this.userScore,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      rewatchCount: rewatchCount ?? this.rewatchCount,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (animeId.present) {
      map['anime_id'] = Variable<int>(animeId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (progress.present) {
      map['progress'] = Variable<int>(progress.value);
    }
    if (userScore.present) {
      map['user_score'] = Variable<double>(userScore.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (rewatchCount.present) {
      map['rewatch_count'] = Variable<int>(rewatchCount.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserAnimeEntriesCompanion(')
          ..write('animeId: $animeId, ')
          ..write('status: $status, ')
          ..write('progress: $progress, ')
          ..write('userScore: $userScore, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('rewatchCount: $rewatchCount, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $CustomListsTable extends CustomLists
    with TableInfo<$CustomListsTable, CustomList> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomListsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_lists';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomList> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CustomList map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomList(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CustomListsTable createAlias(String alias) {
    return $CustomListsTable(attachedDatabase, alias);
  }
}

class CustomList extends DataClass implements Insertable<CustomList> {
  final int id;
  final String name;
  final DateTime createdAt;
  const CustomList({
    required this.id,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CustomListsCompanion toCompanion(bool nullToAbsent) {
    return CustomListsCompanion(
      id: Value(id),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory CustomList.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomList(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CustomList copyWith({int? id, String? name, DateTime? createdAt}) =>
      CustomList(
        id: id ?? this.id,
        name: name ?? this.name,
        createdAt: createdAt ?? this.createdAt,
      );
  CustomList copyWithCompanion(CustomListsCompanion data) {
    return CustomList(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomList(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomList &&
          other.id == this.id &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class CustomListsCompanion extends UpdateCompanion<CustomList> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> createdAt;
  const CustomListsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CustomListsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<CustomList> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CustomListsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<DateTime>? createdAt,
  }) {
    return CustomListsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomListsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CustomListItemsTable extends CustomListItems
    with TableInfo<$CustomListItemsTable, CustomListItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CustomListItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _listIdMeta = const VerificationMeta('listId');
  @override
  late final GeneratedColumn<int> listId = GeneratedColumn<int>(
    'list_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES custom_lists (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _animeIdMeta = const VerificationMeta(
    'animeId',
  );
  @override
  late final GeneratedColumn<int> animeId = GeneratedColumn<int>(
    'anime_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES anime_snapshots (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [listId, animeId, addedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'custom_list_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CustomListItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('list_id')) {
      context.handle(
        _listIdMeta,
        listId.isAcceptableOrUnknown(data['list_id']!, _listIdMeta),
      );
    } else if (isInserting) {
      context.missing(_listIdMeta);
    }
    if (data.containsKey('anime_id')) {
      context.handle(
        _animeIdMeta,
        animeId.isAcceptableOrUnknown(data['anime_id']!, _animeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animeIdMeta);
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {listId, animeId};
  @override
  CustomListItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CustomListItem(
      listId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}list_id'],
      )!,
      animeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anime_id'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $CustomListItemsTable createAlias(String alias) {
    return $CustomListItemsTable(attachedDatabase, alias);
  }
}

class CustomListItem extends DataClass implements Insertable<CustomListItem> {
  final int listId;
  final int animeId;
  final DateTime addedAt;
  const CustomListItem({
    required this.listId,
    required this.animeId,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['list_id'] = Variable<int>(listId);
    map['anime_id'] = Variable<int>(animeId);
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  CustomListItemsCompanion toCompanion(bool nullToAbsent) {
    return CustomListItemsCompanion(
      listId: Value(listId),
      animeId: Value(animeId),
      addedAt: Value(addedAt),
    );
  }

  factory CustomListItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CustomListItem(
      listId: serializer.fromJson<int>(json['listId']),
      animeId: serializer.fromJson<int>(json['animeId']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'listId': serializer.toJson<int>(listId),
      'animeId': serializer.toJson<int>(animeId),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  CustomListItem copyWith({int? listId, int? animeId, DateTime? addedAt}) =>
      CustomListItem(
        listId: listId ?? this.listId,
        animeId: animeId ?? this.animeId,
        addedAt: addedAt ?? this.addedAt,
      );
  CustomListItem copyWithCompanion(CustomListItemsCompanion data) {
    return CustomListItem(
      listId: data.listId.present ? data.listId.value : this.listId,
      animeId: data.animeId.present ? data.animeId.value : this.animeId,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CustomListItem(')
          ..write('listId: $listId, ')
          ..write('animeId: $animeId, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(listId, animeId, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CustomListItem &&
          other.listId == this.listId &&
          other.animeId == this.animeId &&
          other.addedAt == this.addedAt);
}

class CustomListItemsCompanion extends UpdateCompanion<CustomListItem> {
  final Value<int> listId;
  final Value<int> animeId;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const CustomListItemsCompanion({
    this.listId = const Value.absent(),
    this.animeId = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CustomListItemsCompanion.insert({
    required int listId,
    required int animeId,
    required DateTime addedAt,
    this.rowid = const Value.absent(),
  }) : listId = Value(listId),
       animeId = Value(animeId),
       addedAt = Value(addedAt);
  static Insertable<CustomListItem> custom({
    Expression<int>? listId,
    Expression<int>? animeId,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (listId != null) 'list_id': listId,
      if (animeId != null) 'anime_id': animeId,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CustomListItemsCompanion copyWith({
    Value<int>? listId,
    Value<int>? animeId,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return CustomListItemsCompanion(
      listId: listId ?? this.listId,
      animeId: animeId ?? this.animeId,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (listId.present) {
      map['list_id'] = Variable<int>(listId.value);
    }
    if (animeId.present) {
      map['anime_id'] = Variable<int>(animeId.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CustomListItemsCompanion(')
          ..write('listId: $listId, ')
          ..write('animeId: $animeId, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DownloadIntentsTable extends DownloadIntents
    with TableInfo<$DownloadIntentsTable, DownloadIntent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadIntentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _animeIdMeta = const VerificationMeta(
    'animeId',
  );
  @override
  late final GeneratedColumn<int> animeId = GeneratedColumn<int>(
    'anime_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES anime_snapshots (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _selectedEpisodesJsonMeta =
      const VerificationMeta('selectedEpisodesJson');
  @override
  late final GeneratedColumn<String> selectedEpisodesJson =
      GeneratedColumn<String>(
        'selected_episodes_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _allAvailableEpisodesMeta =
      const VerificationMeta('allAvailableEpisodes');
  @override
  late final GeneratedColumn<bool> allAvailableEpisodes = GeneratedColumn<bool>(
    'all_available_episodes',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("all_available_episodes" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _autoDownloadFutureMeta =
      const VerificationMeta('autoDownloadFuture');
  @override
  late final GeneratedColumn<bool> autoDownloadFuture = GeneratedColumn<bool>(
    'auto_download_future',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_download_future" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pausedMeta = const VerificationMeta('paused');
  @override
  late final GeneratedColumn<bool> paused = GeneratedColumn<bool>(
    'paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paused" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _destinationOverrideMeta =
      const VerificationMeta('destinationOverride');
  @override
  late final GeneratedColumn<String> destinationOverride =
      GeneratedColumn<String>(
        'destination_override',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _lastCheckedAtMeta = const VerificationMeta(
    'lastCheckedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastCheckedAt =
      GeneratedColumn<DateTime>(
        'last_checked_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    animeId,
    selectedEpisodesJson,
    allAvailableEpisodes,
    autoDownloadFuture,
    state,
    paused,
    destinationOverride,
    lastCheckedAt,
    errorMessage,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'download_intents';
  @override
  VerificationContext validateIntegrity(
    Insertable<DownloadIntent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('anime_id')) {
      context.handle(
        _animeIdMeta,
        animeId.isAcceptableOrUnknown(data['anime_id']!, _animeIdMeta),
      );
    }
    if (data.containsKey('selected_episodes_json')) {
      context.handle(
        _selectedEpisodesJsonMeta,
        selectedEpisodesJson.isAcceptableOrUnknown(
          data['selected_episodes_json']!,
          _selectedEpisodesJsonMeta,
        ),
      );
    }
    if (data.containsKey('all_available_episodes')) {
      context.handle(
        _allAvailableEpisodesMeta,
        allAvailableEpisodes.isAcceptableOrUnknown(
          data['all_available_episodes']!,
          _allAvailableEpisodesMeta,
        ),
      );
    }
    if (data.containsKey('auto_download_future')) {
      context.handle(
        _autoDownloadFutureMeta,
        autoDownloadFuture.isAcceptableOrUnknown(
          data['auto_download_future']!,
          _autoDownloadFutureMeta,
        ),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('paused')) {
      context.handle(
        _pausedMeta,
        paused.isAcceptableOrUnknown(data['paused']!, _pausedMeta),
      );
    }
    if (data.containsKey('destination_override')) {
      context.handle(
        _destinationOverrideMeta,
        destinationOverride.isAcceptableOrUnknown(
          data['destination_override']!,
          _destinationOverrideMeta,
        ),
      );
    }
    if (data.containsKey('last_checked_at')) {
      context.handle(
        _lastCheckedAtMeta,
        lastCheckedAt.isAcceptableOrUnknown(
          data['last_checked_at']!,
          _lastCheckedAtMeta,
        ),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {animeId};
  @override
  DownloadIntent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadIntent(
      animeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anime_id'],
      )!,
      selectedEpisodesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_episodes_json'],
      )!,
      allAvailableEpisodes: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}all_available_episodes'],
      )!,
      autoDownloadFuture: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_download_future'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      paused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paused'],
      )!,
      destinationOverride: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_override'],
      ),
      lastCheckedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_checked_at'],
      ),
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DownloadIntentsTable createAlias(String alias) {
    return $DownloadIntentsTable(attachedDatabase, alias);
  }
}

class DownloadIntent extends DataClass implements Insertable<DownloadIntent> {
  final int animeId;
  final String selectedEpisodesJson;
  final bool allAvailableEpisodes;
  final bool autoDownloadFuture;
  final String state;
  final bool paused;
  final String? destinationOverride;
  final DateTime? lastCheckedAt;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DownloadIntent({
    required this.animeId,
    required this.selectedEpisodesJson,
    required this.allAvailableEpisodes,
    required this.autoDownloadFuture,
    required this.state,
    required this.paused,
    this.destinationOverride,
    this.lastCheckedAt,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['anime_id'] = Variable<int>(animeId);
    map['selected_episodes_json'] = Variable<String>(selectedEpisodesJson);
    map['all_available_episodes'] = Variable<bool>(allAvailableEpisodes);
    map['auto_download_future'] = Variable<bool>(autoDownloadFuture);
    map['state'] = Variable<String>(state);
    map['paused'] = Variable<bool>(paused);
    if (!nullToAbsent || destinationOverride != null) {
      map['destination_override'] = Variable<String>(destinationOverride);
    }
    if (!nullToAbsent || lastCheckedAt != null) {
      map['last_checked_at'] = Variable<DateTime>(lastCheckedAt);
    }
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DownloadIntentsCompanion toCompanion(bool nullToAbsent) {
    return DownloadIntentsCompanion(
      animeId: Value(animeId),
      selectedEpisodesJson: Value(selectedEpisodesJson),
      allAvailableEpisodes: Value(allAvailableEpisodes),
      autoDownloadFuture: Value(autoDownloadFuture),
      state: Value(state),
      paused: Value(paused),
      destinationOverride: destinationOverride == null && nullToAbsent
          ? const Value.absent()
          : Value(destinationOverride),
      lastCheckedAt: lastCheckedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCheckedAt),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DownloadIntent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadIntent(
      animeId: serializer.fromJson<int>(json['animeId']),
      selectedEpisodesJson: serializer.fromJson<String>(
        json['selectedEpisodesJson'],
      ),
      allAvailableEpisodes: serializer.fromJson<bool>(
        json['allAvailableEpisodes'],
      ),
      autoDownloadFuture: serializer.fromJson<bool>(json['autoDownloadFuture']),
      state: serializer.fromJson<String>(json['state']),
      paused: serializer.fromJson<bool>(json['paused']),
      destinationOverride: serializer.fromJson<String?>(
        json['destinationOverride'],
      ),
      lastCheckedAt: serializer.fromJson<DateTime?>(json['lastCheckedAt']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'animeId': serializer.toJson<int>(animeId),
      'selectedEpisodesJson': serializer.toJson<String>(selectedEpisodesJson),
      'allAvailableEpisodes': serializer.toJson<bool>(allAvailableEpisodes),
      'autoDownloadFuture': serializer.toJson<bool>(autoDownloadFuture),
      'state': serializer.toJson<String>(state),
      'paused': serializer.toJson<bool>(paused),
      'destinationOverride': serializer.toJson<String?>(destinationOverride),
      'lastCheckedAt': serializer.toJson<DateTime?>(lastCheckedAt),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DownloadIntent copyWith({
    int? animeId,
    String? selectedEpisodesJson,
    bool? allAvailableEpisodes,
    bool? autoDownloadFuture,
    String? state,
    bool? paused,
    Value<String?> destinationOverride = const Value.absent(),
    Value<DateTime?> lastCheckedAt = const Value.absent(),
    Value<String?> errorMessage = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DownloadIntent(
    animeId: animeId ?? this.animeId,
    selectedEpisodesJson: selectedEpisodesJson ?? this.selectedEpisodesJson,
    allAvailableEpisodes: allAvailableEpisodes ?? this.allAvailableEpisodes,
    autoDownloadFuture: autoDownloadFuture ?? this.autoDownloadFuture,
    state: state ?? this.state,
    paused: paused ?? this.paused,
    destinationOverride: destinationOverride.present
        ? destinationOverride.value
        : this.destinationOverride,
    lastCheckedAt: lastCheckedAt.present
        ? lastCheckedAt.value
        : this.lastCheckedAt,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DownloadIntent copyWithCompanion(DownloadIntentsCompanion data) {
    return DownloadIntent(
      animeId: data.animeId.present ? data.animeId.value : this.animeId,
      selectedEpisodesJson: data.selectedEpisodesJson.present
          ? data.selectedEpisodesJson.value
          : this.selectedEpisodesJson,
      allAvailableEpisodes: data.allAvailableEpisodes.present
          ? data.allAvailableEpisodes.value
          : this.allAvailableEpisodes,
      autoDownloadFuture: data.autoDownloadFuture.present
          ? data.autoDownloadFuture.value
          : this.autoDownloadFuture,
      state: data.state.present ? data.state.value : this.state,
      paused: data.paused.present ? data.paused.value : this.paused,
      destinationOverride: data.destinationOverride.present
          ? data.destinationOverride.value
          : this.destinationOverride,
      lastCheckedAt: data.lastCheckedAt.present
          ? data.lastCheckedAt.value
          : this.lastCheckedAt,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadIntent(')
          ..write('animeId: $animeId, ')
          ..write('selectedEpisodesJson: $selectedEpisodesJson, ')
          ..write('allAvailableEpisodes: $allAvailableEpisodes, ')
          ..write('autoDownloadFuture: $autoDownloadFuture, ')
          ..write('state: $state, ')
          ..write('paused: $paused, ')
          ..write('destinationOverride: $destinationOverride, ')
          ..write('lastCheckedAt: $lastCheckedAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    animeId,
    selectedEpisodesJson,
    allAvailableEpisodes,
    autoDownloadFuture,
    state,
    paused,
    destinationOverride,
    lastCheckedAt,
    errorMessage,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadIntent &&
          other.animeId == this.animeId &&
          other.selectedEpisodesJson == this.selectedEpisodesJson &&
          other.allAvailableEpisodes == this.allAvailableEpisodes &&
          other.autoDownloadFuture == this.autoDownloadFuture &&
          other.state == this.state &&
          other.paused == this.paused &&
          other.destinationOverride == this.destinationOverride &&
          other.lastCheckedAt == this.lastCheckedAt &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DownloadIntentsCompanion extends UpdateCompanion<DownloadIntent> {
  final Value<int> animeId;
  final Value<String> selectedEpisodesJson;
  final Value<bool> allAvailableEpisodes;
  final Value<bool> autoDownloadFuture;
  final Value<String> state;
  final Value<bool> paused;
  final Value<String?> destinationOverride;
  final Value<DateTime?> lastCheckedAt;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DownloadIntentsCompanion({
    this.animeId = const Value.absent(),
    this.selectedEpisodesJson = const Value.absent(),
    this.allAvailableEpisodes = const Value.absent(),
    this.autoDownloadFuture = const Value.absent(),
    this.state = const Value.absent(),
    this.paused = const Value.absent(),
    this.destinationOverride = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DownloadIntentsCompanion.insert({
    this.animeId = const Value.absent(),
    this.selectedEpisodesJson = const Value.absent(),
    this.allAvailableEpisodes = const Value.absent(),
    this.autoDownloadFuture = const Value.absent(),
    required String state,
    this.paused = const Value.absent(),
    this.destinationOverride = const Value.absent(),
    this.lastCheckedAt = const Value.absent(),
    this.errorMessage = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : state = Value(state),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DownloadIntent> custom({
    Expression<int>? animeId,
    Expression<String>? selectedEpisodesJson,
    Expression<bool>? allAvailableEpisodes,
    Expression<bool>? autoDownloadFuture,
    Expression<String>? state,
    Expression<bool>? paused,
    Expression<String>? destinationOverride,
    Expression<DateTime>? lastCheckedAt,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (animeId != null) 'anime_id': animeId,
      if (selectedEpisodesJson != null)
        'selected_episodes_json': selectedEpisodesJson,
      if (allAvailableEpisodes != null)
        'all_available_episodes': allAvailableEpisodes,
      if (autoDownloadFuture != null)
        'auto_download_future': autoDownloadFuture,
      if (state != null) 'state': state,
      if (paused != null) 'paused': paused,
      if (destinationOverride != null)
        'destination_override': destinationOverride,
      if (lastCheckedAt != null) 'last_checked_at': lastCheckedAt,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DownloadIntentsCompanion copyWith({
    Value<int>? animeId,
    Value<String>? selectedEpisodesJson,
    Value<bool>? allAvailableEpisodes,
    Value<bool>? autoDownloadFuture,
    Value<String>? state,
    Value<bool>? paused,
    Value<String?>? destinationOverride,
    Value<DateTime?>? lastCheckedAt,
    Value<String?>? errorMessage,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DownloadIntentsCompanion(
      animeId: animeId ?? this.animeId,
      selectedEpisodesJson: selectedEpisodesJson ?? this.selectedEpisodesJson,
      allAvailableEpisodes: allAvailableEpisodes ?? this.allAvailableEpisodes,
      autoDownloadFuture: autoDownloadFuture ?? this.autoDownloadFuture,
      state: state ?? this.state,
      paused: paused ?? this.paused,
      destinationOverride: destinationOverride ?? this.destinationOverride,
      lastCheckedAt: lastCheckedAt ?? this.lastCheckedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (animeId.present) {
      map['anime_id'] = Variable<int>(animeId.value);
    }
    if (selectedEpisodesJson.present) {
      map['selected_episodes_json'] = Variable<String>(
        selectedEpisodesJson.value,
      );
    }
    if (allAvailableEpisodes.present) {
      map['all_available_episodes'] = Variable<bool>(
        allAvailableEpisodes.value,
      );
    }
    if (autoDownloadFuture.present) {
      map['auto_download_future'] = Variable<bool>(autoDownloadFuture.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (paused.present) {
      map['paused'] = Variable<bool>(paused.value);
    }
    if (destinationOverride.present) {
      map['destination_override'] = Variable<String>(destinationOverride.value);
    }
    if (lastCheckedAt.present) {
      map['last_checked_at'] = Variable<DateTime>(lastCheckedAt.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadIntentsCompanion(')
          ..write('animeId: $animeId, ')
          ..write('selectedEpisodesJson: $selectedEpisodesJson, ')
          ..write('allAvailableEpisodes: $allAvailableEpisodes, ')
          ..write('autoDownloadFuture: $autoDownloadFuture, ')
          ..write('state: $state, ')
          ..write('paused: $paused, ')
          ..write('destinationOverride: $destinationOverride, ')
          ..write('lastCheckedAt: $lastCheckedAt, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $DownloadJobsTable extends DownloadJobs
    with TableInfo<$DownloadJobsTable, DownloadJob> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DownloadJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _animeIdMeta = const VerificationMeta(
    'animeId',
  );
  @override
  late final GeneratedColumn<int> animeId = GeneratedColumn<int>(
    'anime_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES download_intents (anime_id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta(
    'sourceId',
  );
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _sourceUriMeta = const VerificationMeta(
    'sourceUri',
  );
  @override
  late final GeneratedColumn<String> sourceUri = GeneratedColumn<String>(
    'source_uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeCoverageJsonMeta =
      const VerificationMeta('episodeCoverageJson');
  @override
  late final GeneratedColumn<String> episodeCoverageJson =
      GeneratedColumn<String>(
        'episode_coverage_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _destinationMeta = const VerificationMeta(
    'destination',
  );
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
    'destination',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _torrentHashMeta = const VerificationMeta(
    'torrentHash',
  );
  @override
  late final GeneratedColumn<String> torrentHash = GeneratedColumn<String>(
    'torrent_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _errorMessageMeta = const VerificationMeta(
    'errorMessage',
  );
  @override
  late final GeneratedColumn<String> errorMessage = GeneratedColumn<String>(
    'error_message',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    animeId,
    sourceId,
    sourceUri,
    episodeCoverageJson,
    destination,
    torrentHash,
    state,
    retryCount,
    errorMessage,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'download_jobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<DownloadJob> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('anime_id')) {
      context.handle(
        _animeIdMeta,
        animeId.isAcceptableOrUnknown(data['anime_id']!, _animeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_animeIdMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(
        _sourceIdMeta,
        sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('source_uri')) {
      context.handle(
        _sourceUriMeta,
        sourceUri.isAcceptableOrUnknown(data['source_uri']!, _sourceUriMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceUriMeta);
    }
    if (data.containsKey('episode_coverage_json')) {
      context.handle(
        _episodeCoverageJsonMeta,
        episodeCoverageJson.isAcceptableOrUnknown(
          data['episode_coverage_json']!,
          _episodeCoverageJsonMeta,
        ),
      );
    }
    if (data.containsKey('destination')) {
      context.handle(
        _destinationMeta,
        destination.isAcceptableOrUnknown(
          data['destination']!,
          _destinationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationMeta);
    }
    if (data.containsKey('torrent_hash')) {
      context.handle(
        _torrentHashMeta,
        torrentHash.isAcceptableOrUnknown(
          data['torrent_hash']!,
          _torrentHashMeta,
        ),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    if (data.containsKey('error_message')) {
      context.handle(
        _errorMessageMeta,
        errorMessage.isAcceptableOrUnknown(
          data['error_message']!,
          _errorMessageMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DownloadJob map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DownloadJob(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      animeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}anime_id'],
      )!,
      sourceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_id'],
      )!,
      sourceUri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_uri'],
      )!,
      episodeCoverageJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}episode_coverage_json'],
      )!,
      destination: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination'],
      )!,
      torrentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}torrent_hash'],
      ),
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
      errorMessage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error_message'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DownloadJobsTable createAlias(String alias) {
    return $DownloadJobsTable(attachedDatabase, alias);
  }
}

class DownloadJob extends DataClass implements Insertable<DownloadJob> {
  final int id;
  final int animeId;
  final String sourceId;
  final String sourceUri;
  final String episodeCoverageJson;
  final String destination;
  final String? torrentHash;
  final String state;
  final int retryCount;
  final String? errorMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DownloadJob({
    required this.id,
    required this.animeId,
    required this.sourceId,
    required this.sourceUri,
    required this.episodeCoverageJson,
    required this.destination,
    this.torrentHash,
    required this.state,
    required this.retryCount,
    this.errorMessage,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['anime_id'] = Variable<int>(animeId);
    map['source_id'] = Variable<String>(sourceId);
    map['source_uri'] = Variable<String>(sourceUri);
    map['episode_coverage_json'] = Variable<String>(episodeCoverageJson);
    map['destination'] = Variable<String>(destination);
    if (!nullToAbsent || torrentHash != null) {
      map['torrent_hash'] = Variable<String>(torrentHash);
    }
    map['state'] = Variable<String>(state);
    map['retry_count'] = Variable<int>(retryCount);
    if (!nullToAbsent || errorMessage != null) {
      map['error_message'] = Variable<String>(errorMessage);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DownloadJobsCompanion toCompanion(bool nullToAbsent) {
    return DownloadJobsCompanion(
      id: Value(id),
      animeId: Value(animeId),
      sourceId: Value(sourceId),
      sourceUri: Value(sourceUri),
      episodeCoverageJson: Value(episodeCoverageJson),
      destination: Value(destination),
      torrentHash: torrentHash == null && nullToAbsent
          ? const Value.absent()
          : Value(torrentHash),
      state: Value(state),
      retryCount: Value(retryCount),
      errorMessage: errorMessage == null && nullToAbsent
          ? const Value.absent()
          : Value(errorMessage),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DownloadJob.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DownloadJob(
      id: serializer.fromJson<int>(json['id']),
      animeId: serializer.fromJson<int>(json['animeId']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      sourceUri: serializer.fromJson<String>(json['sourceUri']),
      episodeCoverageJson: serializer.fromJson<String>(
        json['episodeCoverageJson'],
      ),
      destination: serializer.fromJson<String>(json['destination']),
      torrentHash: serializer.fromJson<String?>(json['torrentHash']),
      state: serializer.fromJson<String>(json['state']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
      errorMessage: serializer.fromJson<String?>(json['errorMessage']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'animeId': serializer.toJson<int>(animeId),
      'sourceId': serializer.toJson<String>(sourceId),
      'sourceUri': serializer.toJson<String>(sourceUri),
      'episodeCoverageJson': serializer.toJson<String>(episodeCoverageJson),
      'destination': serializer.toJson<String>(destination),
      'torrentHash': serializer.toJson<String?>(torrentHash),
      'state': serializer.toJson<String>(state),
      'retryCount': serializer.toJson<int>(retryCount),
      'errorMessage': serializer.toJson<String?>(errorMessage),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DownloadJob copyWith({
    int? id,
    int? animeId,
    String? sourceId,
    String? sourceUri,
    String? episodeCoverageJson,
    String? destination,
    Value<String?> torrentHash = const Value.absent(),
    String? state,
    int? retryCount,
    Value<String?> errorMessage = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DownloadJob(
    id: id ?? this.id,
    animeId: animeId ?? this.animeId,
    sourceId: sourceId ?? this.sourceId,
    sourceUri: sourceUri ?? this.sourceUri,
    episodeCoverageJson: episodeCoverageJson ?? this.episodeCoverageJson,
    destination: destination ?? this.destination,
    torrentHash: torrentHash.present ? torrentHash.value : this.torrentHash,
    state: state ?? this.state,
    retryCount: retryCount ?? this.retryCount,
    errorMessage: errorMessage.present ? errorMessage.value : this.errorMessage,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DownloadJob copyWithCompanion(DownloadJobsCompanion data) {
    return DownloadJob(
      id: data.id.present ? data.id.value : this.id,
      animeId: data.animeId.present ? data.animeId.value : this.animeId,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      sourceUri: data.sourceUri.present ? data.sourceUri.value : this.sourceUri,
      episodeCoverageJson: data.episodeCoverageJson.present
          ? data.episodeCoverageJson.value
          : this.episodeCoverageJson,
      destination: data.destination.present
          ? data.destination.value
          : this.destination,
      torrentHash: data.torrentHash.present
          ? data.torrentHash.value
          : this.torrentHash,
      state: data.state.present ? data.state.value : this.state,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
      errorMessage: data.errorMessage.present
          ? data.errorMessage.value
          : this.errorMessage,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DownloadJob(')
          ..write('id: $id, ')
          ..write('animeId: $animeId, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('episodeCoverageJson: $episodeCoverageJson, ')
          ..write('destination: $destination, ')
          ..write('torrentHash: $torrentHash, ')
          ..write('state: $state, ')
          ..write('retryCount: $retryCount, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    animeId,
    sourceId,
    sourceUri,
    episodeCoverageJson,
    destination,
    torrentHash,
    state,
    retryCount,
    errorMessage,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DownloadJob &&
          other.id == this.id &&
          other.animeId == this.animeId &&
          other.sourceId == this.sourceId &&
          other.sourceUri == this.sourceUri &&
          other.episodeCoverageJson == this.episodeCoverageJson &&
          other.destination == this.destination &&
          other.torrentHash == this.torrentHash &&
          other.state == this.state &&
          other.retryCount == this.retryCount &&
          other.errorMessage == this.errorMessage &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DownloadJobsCompanion extends UpdateCompanion<DownloadJob> {
  final Value<int> id;
  final Value<int> animeId;
  final Value<String> sourceId;
  final Value<String> sourceUri;
  final Value<String> episodeCoverageJson;
  final Value<String> destination;
  final Value<String?> torrentHash;
  final Value<String> state;
  final Value<int> retryCount;
  final Value<String?> errorMessage;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const DownloadJobsCompanion({
    this.id = const Value.absent(),
    this.animeId = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.sourceUri = const Value.absent(),
    this.episodeCoverageJson = const Value.absent(),
    this.destination = const Value.absent(),
    this.torrentHash = const Value.absent(),
    this.state = const Value.absent(),
    this.retryCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  DownloadJobsCompanion.insert({
    this.id = const Value.absent(),
    required int animeId,
    required String sourceId,
    required String sourceUri,
    this.episodeCoverageJson = const Value.absent(),
    required String destination,
    this.torrentHash = const Value.absent(),
    required String state,
    this.retryCount = const Value.absent(),
    this.errorMessage = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : animeId = Value(animeId),
       sourceId = Value(sourceId),
       sourceUri = Value(sourceUri),
       destination = Value(destination),
       state = Value(state),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DownloadJob> custom({
    Expression<int>? id,
    Expression<int>? animeId,
    Expression<String>? sourceId,
    Expression<String>? sourceUri,
    Expression<String>? episodeCoverageJson,
    Expression<String>? destination,
    Expression<String>? torrentHash,
    Expression<String>? state,
    Expression<int>? retryCount,
    Expression<String>? errorMessage,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (animeId != null) 'anime_id': animeId,
      if (sourceId != null) 'source_id': sourceId,
      if (sourceUri != null) 'source_uri': sourceUri,
      if (episodeCoverageJson != null)
        'episode_coverage_json': episodeCoverageJson,
      if (destination != null) 'destination': destination,
      if (torrentHash != null) 'torrent_hash': torrentHash,
      if (state != null) 'state': state,
      if (retryCount != null) 'retry_count': retryCount,
      if (errorMessage != null) 'error_message': errorMessage,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  DownloadJobsCompanion copyWith({
    Value<int>? id,
    Value<int>? animeId,
    Value<String>? sourceId,
    Value<String>? sourceUri,
    Value<String>? episodeCoverageJson,
    Value<String>? destination,
    Value<String?>? torrentHash,
    Value<String>? state,
    Value<int>? retryCount,
    Value<String?>? errorMessage,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return DownloadJobsCompanion(
      id: id ?? this.id,
      animeId: animeId ?? this.animeId,
      sourceId: sourceId ?? this.sourceId,
      sourceUri: sourceUri ?? this.sourceUri,
      episodeCoverageJson: episodeCoverageJson ?? this.episodeCoverageJson,
      destination: destination ?? this.destination,
      torrentHash: torrentHash ?? this.torrentHash,
      state: state ?? this.state,
      retryCount: retryCount ?? this.retryCount,
      errorMessage: errorMessage ?? this.errorMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (animeId.present) {
      map['anime_id'] = Variable<int>(animeId.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (sourceUri.present) {
      map['source_uri'] = Variable<String>(sourceUri.value);
    }
    if (episodeCoverageJson.present) {
      map['episode_coverage_json'] = Variable<String>(
        episodeCoverageJson.value,
      );
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (torrentHash.present) {
      map['torrent_hash'] = Variable<String>(torrentHash.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    if (errorMessage.present) {
      map['error_message'] = Variable<String>(errorMessage.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DownloadJobsCompanion(')
          ..write('id: $id, ')
          ..write('animeId: $animeId, ')
          ..write('sourceId: $sourceId, ')
          ..write('sourceUri: $sourceUri, ')
          ..write('episodeCoverageJson: $episodeCoverageJson, ')
          ..write('destination: $destination, ')
          ..write('torrentHash: $torrentHash, ')
          ..write('state: $state, ')
          ..write('retryCount: $retryCount, ')
          ..write('errorMessage: $errorMessage, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AnimeSnapshotsTable animeSnapshots = $AnimeSnapshotsTable(this);
  late final $UserAnimeEntriesTable userAnimeEntries = $UserAnimeEntriesTable(
    this,
  );
  late final $CustomListsTable customLists = $CustomListsTable(this);
  late final $CustomListItemsTable customListItems = $CustomListItemsTable(
    this,
  );
  late final $DownloadIntentsTable downloadIntents = $DownloadIntentsTable(
    this,
  );
  late final $DownloadJobsTable downloadJobs = $DownloadJobsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    animeSnapshots,
    userAnimeEntries,
    customLists,
    customListItems,
    downloadIntents,
    downloadJobs,
    appSettings,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'anime_snapshots',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('user_anime_entries', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'custom_lists',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('custom_list_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'anime_snapshots',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('custom_list_items', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'anime_snapshots',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('download_intents', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'download_intents',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('download_jobs', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$AnimeSnapshotsTableCreateCompanionBuilder =
    AnimeSnapshotsCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> titleEnglish,
      required String imageUrl,
      Value<String?> type,
      Value<int?> episodes,
      Value<double?> score,
      Value<int?> year,
      Value<bool> airing,
      required DateTime updatedAt,
    });
typedef $$AnimeSnapshotsTableUpdateCompanionBuilder =
    AnimeSnapshotsCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> titleEnglish,
      Value<String> imageUrl,
      Value<String?> type,
      Value<int?> episodes,
      Value<double?> score,
      Value<int?> year,
      Value<bool> airing,
      Value<DateTime> updatedAt,
    });

final class $$AnimeSnapshotsTableReferences
    extends BaseReferences<_$AppDatabase, $AnimeSnapshotsTable, AnimeSnapshot> {
  $$AnimeSnapshotsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$UserAnimeEntriesTable, List<UserAnimeEntry>>
  _userAnimeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userAnimeEntries,
    aliasName: $_aliasNameGenerator(
      db.animeSnapshots.id,
      db.userAnimeEntries.animeId,
    ),
  );

  $$UserAnimeEntriesTableProcessedTableManager get userAnimeEntriesRefs {
    final manager = $$UserAnimeEntriesTableTableManager(
      $_db,
      $_db.userAnimeEntries,
    ).filter((f) => f.animeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _userAnimeEntriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CustomListItemsTable, List<CustomListItem>>
  _customListItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.customListItems,
    aliasName: $_aliasNameGenerator(
      db.animeSnapshots.id,
      db.customListItems.animeId,
    ),
  );

  $$CustomListItemsTableProcessedTableManager get customListItemsRefs {
    final manager = $$CustomListItemsTableTableManager(
      $_db,
      $_db.customListItems,
    ).filter((f) => f.animeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _customListItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DownloadIntentsTable, List<DownloadIntent>>
  _downloadIntentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.downloadIntents,
    aliasName: $_aliasNameGenerator(
      db.animeSnapshots.id,
      db.downloadIntents.animeId,
    ),
  );

  $$DownloadIntentsTableProcessedTableManager get downloadIntentsRefs {
    final manager = $$DownloadIntentsTableTableManager(
      $_db,
      $_db.downloadIntents,
    ).filter((f) => f.animeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _downloadIntentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AnimeSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $AnimeSnapshotsTable> {
  $$AnimeSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleEnglish => $composableBuilder(
    column: $table.titleEnglish,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get episodes => $composableBuilder(
    column: $table.episodes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get airing => $composableBuilder(
    column: $table.airing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> userAnimeEntriesRefs(
    Expression<bool> Function($$UserAnimeEntriesTableFilterComposer f) f,
  ) {
    final $$UserAnimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userAnimeEntries,
      getReferencedColumn: (t) => t.animeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserAnimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.userAnimeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> customListItemsRefs(
    Expression<bool> Function($$CustomListItemsTableFilterComposer f) f,
  ) {
    final $$CustomListItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customListItems,
      getReferencedColumn: (t) => t.animeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomListItemsTableFilterComposer(
            $db: $db,
            $table: $db.customListItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> downloadIntentsRefs(
    Expression<bool> Function($$DownloadIntentsTableFilterComposer f) f,
  ) {
    final $$DownloadIntentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.downloadIntents,
      getReferencedColumn: (t) => t.animeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DownloadIntentsTableFilterComposer(
            $db: $db,
            $table: $db.downloadIntents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AnimeSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $AnimeSnapshotsTable> {
  $$AnimeSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleEnglish => $composableBuilder(
    column: $table.titleEnglish,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get episodes => $composableBuilder(
    column: $table.episodes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get airing => $composableBuilder(
    column: $table.airing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AnimeSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AnimeSnapshotsTable> {
  $$AnimeSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get titleEnglish => $composableBuilder(
    column: $table.titleEnglish,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get episodes =>
      $composableBuilder(column: $table.episodes, builder: (column) => column);

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumn<bool> get airing =>
      $composableBuilder(column: $table.airing, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> userAnimeEntriesRefs<T extends Object>(
    Expression<T> Function($$UserAnimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$UserAnimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.userAnimeEntries,
      getReferencedColumn: (t) => t.animeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserAnimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.userAnimeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> customListItemsRefs<T extends Object>(
    Expression<T> Function($$CustomListItemsTableAnnotationComposer a) f,
  ) {
    final $$CustomListItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customListItems,
      getReferencedColumn: (t) => t.animeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomListItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.customListItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> downloadIntentsRefs<T extends Object>(
    Expression<T> Function($$DownloadIntentsTableAnnotationComposer a) f,
  ) {
    final $$DownloadIntentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.downloadIntents,
      getReferencedColumn: (t) => t.animeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DownloadIntentsTableAnnotationComposer(
            $db: $db,
            $table: $db.downloadIntents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$AnimeSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AnimeSnapshotsTable,
          AnimeSnapshot,
          $$AnimeSnapshotsTableFilterComposer,
          $$AnimeSnapshotsTableOrderingComposer,
          $$AnimeSnapshotsTableAnnotationComposer,
          $$AnimeSnapshotsTableCreateCompanionBuilder,
          $$AnimeSnapshotsTableUpdateCompanionBuilder,
          (AnimeSnapshot, $$AnimeSnapshotsTableReferences),
          AnimeSnapshot,
          PrefetchHooks Function({
            bool userAnimeEntriesRefs,
            bool customListItemsRefs,
            bool downloadIntentsRefs,
          })
        > {
  $$AnimeSnapshotsTableTableManager(
    _$AppDatabase db,
    $AnimeSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AnimeSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AnimeSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AnimeSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> titleEnglish = const Value.absent(),
                Value<String> imageUrl = const Value.absent(),
                Value<String?> type = const Value.absent(),
                Value<int?> episodes = const Value.absent(),
                Value<double?> score = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<bool> airing = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => AnimeSnapshotsCompanion(
                id: id,
                title: title,
                titleEnglish: titleEnglish,
                imageUrl: imageUrl,
                type: type,
                episodes: episodes,
                score: score,
                year: year,
                airing: airing,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> titleEnglish = const Value.absent(),
                required String imageUrl,
                Value<String?> type = const Value.absent(),
                Value<int?> episodes = const Value.absent(),
                Value<double?> score = const Value.absent(),
                Value<int?> year = const Value.absent(),
                Value<bool> airing = const Value.absent(),
                required DateTime updatedAt,
              }) => AnimeSnapshotsCompanion.insert(
                id: id,
                title: title,
                titleEnglish: titleEnglish,
                imageUrl: imageUrl,
                type: type,
                episodes: episodes,
                score: score,
                year: year,
                airing: airing,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$AnimeSnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                userAnimeEntriesRefs = false,
                customListItemsRefs = false,
                downloadIntentsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (userAnimeEntriesRefs) db.userAnimeEntries,
                    if (customListItemsRefs) db.customListItems,
                    if (downloadIntentsRefs) db.downloadIntents,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (userAnimeEntriesRefs)
                        await $_getPrefetchedData<
                          AnimeSnapshot,
                          $AnimeSnapshotsTable,
                          UserAnimeEntry
                        >(
                          currentTable: table,
                          referencedTable: $$AnimeSnapshotsTableReferences
                              ._userAnimeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnimeSnapshotsTableReferences(
                                db,
                                table,
                                p0,
                              ).userAnimeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.animeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (customListItemsRefs)
                        await $_getPrefetchedData<
                          AnimeSnapshot,
                          $AnimeSnapshotsTable,
                          CustomListItem
                        >(
                          currentTable: table,
                          referencedTable: $$AnimeSnapshotsTableReferences
                              ._customListItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnimeSnapshotsTableReferences(
                                db,
                                table,
                                p0,
                              ).customListItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.animeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (downloadIntentsRefs)
                        await $_getPrefetchedData<
                          AnimeSnapshot,
                          $AnimeSnapshotsTable,
                          DownloadIntent
                        >(
                          currentTable: table,
                          referencedTable: $$AnimeSnapshotsTableReferences
                              ._downloadIntentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AnimeSnapshotsTableReferences(
                                db,
                                table,
                                p0,
                              ).downloadIntentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.animeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AnimeSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AnimeSnapshotsTable,
      AnimeSnapshot,
      $$AnimeSnapshotsTableFilterComposer,
      $$AnimeSnapshotsTableOrderingComposer,
      $$AnimeSnapshotsTableAnnotationComposer,
      $$AnimeSnapshotsTableCreateCompanionBuilder,
      $$AnimeSnapshotsTableUpdateCompanionBuilder,
      (AnimeSnapshot, $$AnimeSnapshotsTableReferences),
      AnimeSnapshot,
      PrefetchHooks Function({
        bool userAnimeEntriesRefs,
        bool customListItemsRefs,
        bool downloadIntentsRefs,
      })
    >;
typedef $$UserAnimeEntriesTableCreateCompanionBuilder =
    UserAnimeEntriesCompanion Function({
      Value<int> animeId,
      required String status,
      Value<int> progress,
      Value<double?> userScore,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<int> rewatchCount,
      Value<String> notes,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$UserAnimeEntriesTableUpdateCompanionBuilder =
    UserAnimeEntriesCompanion Function({
      Value<int> animeId,
      Value<String> status,
      Value<int> progress,
      Value<double?> userScore,
      Value<DateTime?> startedAt,
      Value<DateTime?> completedAt,
      Value<int> rewatchCount,
      Value<String> notes,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$UserAnimeEntriesTableReferences
    extends
        BaseReferences<_$AppDatabase, $UserAnimeEntriesTable, UserAnimeEntry> {
  $$UserAnimeEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AnimeSnapshotsTable _animeIdTable(_$AppDatabase db) =>
      db.animeSnapshots.createAlias(
        $_aliasNameGenerator(db.userAnimeEntries.animeId, db.animeSnapshots.id),
      );

  $$AnimeSnapshotsTableProcessedTableManager get animeId {
    final $_column = $_itemColumn<int>('anime_id')!;

    final manager = $$AnimeSnapshotsTableTableManager(
      $_db,
      $_db.animeSnapshots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_animeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$UserAnimeEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $UserAnimeEntriesTable> {
  $$UserAnimeEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get userScore => $composableBuilder(
    column: $table.userScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rewatchCount => $composableBuilder(
    column: $table.rewatchCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AnimeSnapshotsTableFilterComposer get animeId {
    final $$AnimeSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animeId,
      referencedTable: $db.animeSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnimeSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.animeSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserAnimeEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserAnimeEntriesTable> {
  $$UserAnimeEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get progress => $composableBuilder(
    column: $table.progress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get userScore => $composableBuilder(
    column: $table.userScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rewatchCount => $composableBuilder(
    column: $table.rewatchCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnimeSnapshotsTableOrderingComposer get animeId {
    final $$AnimeSnapshotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animeId,
      referencedTable: $db.animeSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnimeSnapshotsTableOrderingComposer(
            $db: $db,
            $table: $db.animeSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserAnimeEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserAnimeEntriesTable> {
  $$UserAnimeEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get progress =>
      $composableBuilder(column: $table.progress, builder: (column) => column);

  GeneratedColumn<double> get userScore =>
      $composableBuilder(column: $table.userScore, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rewatchCount => $composableBuilder(
    column: $table.rewatchCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AnimeSnapshotsTableAnnotationComposer get animeId {
    final $$AnimeSnapshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animeId,
      referencedTable: $db.animeSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnimeSnapshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.animeSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserAnimeEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserAnimeEntriesTable,
          UserAnimeEntry,
          $$UserAnimeEntriesTableFilterComposer,
          $$UserAnimeEntriesTableOrderingComposer,
          $$UserAnimeEntriesTableAnnotationComposer,
          $$UserAnimeEntriesTableCreateCompanionBuilder,
          $$UserAnimeEntriesTableUpdateCompanionBuilder,
          (UserAnimeEntry, $$UserAnimeEntriesTableReferences),
          UserAnimeEntry,
          PrefetchHooks Function({bool animeId})
        > {
  $$UserAnimeEntriesTableTableManager(
    _$AppDatabase db,
    $UserAnimeEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserAnimeEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserAnimeEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserAnimeEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> animeId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> progress = const Value.absent(),
                Value<double?> userScore = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rewatchCount = const Value.absent(),
                Value<String> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserAnimeEntriesCompanion(
                animeId: animeId,
                status: status,
                progress: progress,
                userScore: userScore,
                startedAt: startedAt,
                completedAt: completedAt,
                rewatchCount: rewatchCount,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> animeId = const Value.absent(),
                required String status,
                Value<int> progress = const Value.absent(),
                Value<double?> userScore = const Value.absent(),
                Value<DateTime?> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int> rewatchCount = const Value.absent(),
                Value<String> notes = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => UserAnimeEntriesCompanion.insert(
                animeId: animeId,
                status: status,
                progress: progress,
                userScore: userScore,
                startedAt: startedAt,
                completedAt: completedAt,
                rewatchCount: rewatchCount,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$UserAnimeEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({animeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (animeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.animeId,
                                referencedTable:
                                    $$UserAnimeEntriesTableReferences
                                        ._animeIdTable(db),
                                referencedColumn:
                                    $$UserAnimeEntriesTableReferences
                                        ._animeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$UserAnimeEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserAnimeEntriesTable,
      UserAnimeEntry,
      $$UserAnimeEntriesTableFilterComposer,
      $$UserAnimeEntriesTableOrderingComposer,
      $$UserAnimeEntriesTableAnnotationComposer,
      $$UserAnimeEntriesTableCreateCompanionBuilder,
      $$UserAnimeEntriesTableUpdateCompanionBuilder,
      (UserAnimeEntry, $$UserAnimeEntriesTableReferences),
      UserAnimeEntry,
      PrefetchHooks Function({bool animeId})
    >;
typedef $$CustomListsTableCreateCompanionBuilder =
    CustomListsCompanion Function({
      Value<int> id,
      required String name,
      required DateTime createdAt,
    });
typedef $$CustomListsTableUpdateCompanionBuilder =
    CustomListsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<DateTime> createdAt,
    });

final class $$CustomListsTableReferences
    extends BaseReferences<_$AppDatabase, $CustomListsTable, CustomList> {
  $$CustomListsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CustomListItemsTable, List<CustomListItem>>
  _customListItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.customListItems,
    aliasName: $_aliasNameGenerator(
      db.customLists.id,
      db.customListItems.listId,
    ),
  );

  $$CustomListItemsTableProcessedTableManager get customListItemsRefs {
    final manager = $$CustomListItemsTableTableManager(
      $_db,
      $_db.customListItems,
    ).filter((f) => f.listId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _customListItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CustomListsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomListsTable> {
  $$CustomListsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> customListItemsRefs(
    Expression<bool> Function($$CustomListItemsTableFilterComposer f) f,
  ) {
    final $$CustomListItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customListItems,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomListItemsTableFilterComposer(
            $db: $db,
            $table: $db.customListItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomListsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomListsTable> {
  $$CustomListsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CustomListsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomListsTable> {
  $$CustomListsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> customListItemsRefs<T extends Object>(
    Expression<T> Function($$CustomListItemsTableAnnotationComposer a) f,
  ) {
    final $$CustomListItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.customListItems,
      getReferencedColumn: (t) => t.listId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomListItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.customListItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CustomListsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomListsTable,
          CustomList,
          $$CustomListsTableFilterComposer,
          $$CustomListsTableOrderingComposer,
          $$CustomListsTableAnnotationComposer,
          $$CustomListsTableCreateCompanionBuilder,
          $$CustomListsTableUpdateCompanionBuilder,
          (CustomList, $$CustomListsTableReferences),
          CustomList,
          PrefetchHooks Function({bool customListItemsRefs})
        > {
  $$CustomListsTableTableManager(_$AppDatabase db, $CustomListsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomListsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomListsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomListsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CustomListsCompanion(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required DateTime createdAt,
              }) => CustomListsCompanion.insert(
                id: id,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomListsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({customListItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (customListItemsRefs) db.customListItems,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (customListItemsRefs)
                    await $_getPrefetchedData<
                      CustomList,
                      $CustomListsTable,
                      CustomListItem
                    >(
                      currentTable: table,
                      referencedTable: $$CustomListsTableReferences
                          ._customListItemsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CustomListsTableReferences(
                            db,
                            table,
                            p0,
                          ).customListItemsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.listId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CustomListsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomListsTable,
      CustomList,
      $$CustomListsTableFilterComposer,
      $$CustomListsTableOrderingComposer,
      $$CustomListsTableAnnotationComposer,
      $$CustomListsTableCreateCompanionBuilder,
      $$CustomListsTableUpdateCompanionBuilder,
      (CustomList, $$CustomListsTableReferences),
      CustomList,
      PrefetchHooks Function({bool customListItemsRefs})
    >;
typedef $$CustomListItemsTableCreateCompanionBuilder =
    CustomListItemsCompanion Function({
      required int listId,
      required int animeId,
      required DateTime addedAt,
      Value<int> rowid,
    });
typedef $$CustomListItemsTableUpdateCompanionBuilder =
    CustomListItemsCompanion Function({
      Value<int> listId,
      Value<int> animeId,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });

final class $$CustomListItemsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CustomListItemsTable, CustomListItem> {
  $$CustomListItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CustomListsTable _listIdTable(_$AppDatabase db) =>
      db.customLists.createAlias(
        $_aliasNameGenerator(db.customListItems.listId, db.customLists.id),
      );

  $$CustomListsTableProcessedTableManager get listId {
    final $_column = $_itemColumn<int>('list_id')!;

    final manager = $$CustomListsTableTableManager(
      $_db,
      $_db.customLists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_listIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AnimeSnapshotsTable _animeIdTable(_$AppDatabase db) =>
      db.animeSnapshots.createAlias(
        $_aliasNameGenerator(db.customListItems.animeId, db.animeSnapshots.id),
      );

  $$AnimeSnapshotsTableProcessedTableManager get animeId {
    final $_column = $_itemColumn<int>('anime_id')!;

    final manager = $$AnimeSnapshotsTableTableManager(
      $_db,
      $_db.animeSnapshots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_animeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CustomListItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CustomListItemsTable> {
  $$CustomListItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CustomListsTableFilterComposer get listId {
    final $$CustomListsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.customLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomListsTableFilterComposer(
            $db: $db,
            $table: $db.customLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AnimeSnapshotsTableFilterComposer get animeId {
    final $$AnimeSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animeId,
      referencedTable: $db.animeSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnimeSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.animeSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomListItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CustomListItemsTable> {
  $$CustomListItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CustomListsTableOrderingComposer get listId {
    final $$CustomListsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.customLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomListsTableOrderingComposer(
            $db: $db,
            $table: $db.customLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AnimeSnapshotsTableOrderingComposer get animeId {
    final $$AnimeSnapshotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animeId,
      referencedTable: $db.animeSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnimeSnapshotsTableOrderingComposer(
            $db: $db,
            $table: $db.animeSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomListItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CustomListItemsTable> {
  $$CustomListItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$CustomListsTableAnnotationComposer get listId {
    final $$CustomListsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.listId,
      referencedTable: $db.customLists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CustomListsTableAnnotationComposer(
            $db: $db,
            $table: $db.customLists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AnimeSnapshotsTableAnnotationComposer get animeId {
    final $$AnimeSnapshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animeId,
      referencedTable: $db.animeSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnimeSnapshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.animeSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CustomListItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CustomListItemsTable,
          CustomListItem,
          $$CustomListItemsTableFilterComposer,
          $$CustomListItemsTableOrderingComposer,
          $$CustomListItemsTableAnnotationComposer,
          $$CustomListItemsTableCreateCompanionBuilder,
          $$CustomListItemsTableUpdateCompanionBuilder,
          (CustomListItem, $$CustomListItemsTableReferences),
          CustomListItem,
          PrefetchHooks Function({bool listId, bool animeId})
        > {
  $$CustomListItemsTableTableManager(
    _$AppDatabase db,
    $CustomListItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CustomListItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CustomListItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CustomListItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> listId = const Value.absent(),
                Value<int> animeId = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CustomListItemsCompanion(
                listId: listId,
                animeId: animeId,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int listId,
                required int animeId,
                required DateTime addedAt,
                Value<int> rowid = const Value.absent(),
              }) => CustomListItemsCompanion.insert(
                listId: listId,
                animeId: animeId,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CustomListItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({listId = false, animeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (listId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.listId,
                                referencedTable:
                                    $$CustomListItemsTableReferences
                                        ._listIdTable(db),
                                referencedColumn:
                                    $$CustomListItemsTableReferences
                                        ._listIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (animeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.animeId,
                                referencedTable:
                                    $$CustomListItemsTableReferences
                                        ._animeIdTable(db),
                                referencedColumn:
                                    $$CustomListItemsTableReferences
                                        ._animeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CustomListItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CustomListItemsTable,
      CustomListItem,
      $$CustomListItemsTableFilterComposer,
      $$CustomListItemsTableOrderingComposer,
      $$CustomListItemsTableAnnotationComposer,
      $$CustomListItemsTableCreateCompanionBuilder,
      $$CustomListItemsTableUpdateCompanionBuilder,
      (CustomListItem, $$CustomListItemsTableReferences),
      CustomListItem,
      PrefetchHooks Function({bool listId, bool animeId})
    >;
typedef $$DownloadIntentsTableCreateCompanionBuilder =
    DownloadIntentsCompanion Function({
      Value<int> animeId,
      Value<String> selectedEpisodesJson,
      Value<bool> allAvailableEpisodes,
      Value<bool> autoDownloadFuture,
      required String state,
      Value<bool> paused,
      Value<String?> destinationOverride,
      Value<DateTime?> lastCheckedAt,
      Value<String?> errorMessage,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$DownloadIntentsTableUpdateCompanionBuilder =
    DownloadIntentsCompanion Function({
      Value<int> animeId,
      Value<String> selectedEpisodesJson,
      Value<bool> allAvailableEpisodes,
      Value<bool> autoDownloadFuture,
      Value<String> state,
      Value<bool> paused,
      Value<String?> destinationOverride,
      Value<DateTime?> lastCheckedAt,
      Value<String?> errorMessage,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$DownloadIntentsTableReferences
    extends
        BaseReferences<_$AppDatabase, $DownloadIntentsTable, DownloadIntent> {
  $$DownloadIntentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AnimeSnapshotsTable _animeIdTable(_$AppDatabase db) =>
      db.animeSnapshots.createAlias(
        $_aliasNameGenerator(db.downloadIntents.animeId, db.animeSnapshots.id),
      );

  $$AnimeSnapshotsTableProcessedTableManager get animeId {
    final $_column = $_itemColumn<int>('anime_id')!;

    final manager = $$AnimeSnapshotsTableTableManager(
      $_db,
      $_db.animeSnapshots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_animeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DownloadIntentsTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadIntentsTable> {
  $$DownloadIntentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get selectedEpisodesJson => $composableBuilder(
    column: $table.selectedEpisodesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allAvailableEpisodes => $composableBuilder(
    column: $table.allAvailableEpisodes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoDownloadFuture => $composableBuilder(
    column: $table.autoDownloadFuture,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destinationOverride => $composableBuilder(
    column: $table.destinationOverride,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastCheckedAt => $composableBuilder(
    column: $table.lastCheckedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AnimeSnapshotsTableFilterComposer get animeId {
    final $$AnimeSnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animeId,
      referencedTable: $db.animeSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnimeSnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.animeSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadIntentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadIntentsTable> {
  $$DownloadIntentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get selectedEpisodesJson => $composableBuilder(
    column: $table.selectedEpisodesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allAvailableEpisodes => $composableBuilder(
    column: $table.allAvailableEpisodes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoDownloadFuture => $composableBuilder(
    column: $table.autoDownloadFuture,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destinationOverride => $composableBuilder(
    column: $table.destinationOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastCheckedAt => $composableBuilder(
    column: $table.lastCheckedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AnimeSnapshotsTableOrderingComposer get animeId {
    final $$AnimeSnapshotsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animeId,
      referencedTable: $db.animeSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnimeSnapshotsTableOrderingComposer(
            $db: $db,
            $table: $db.animeSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadIntentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadIntentsTable> {
  $$DownloadIntentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get selectedEpisodesJson => $composableBuilder(
    column: $table.selectedEpisodesJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get allAvailableEpisodes => $composableBuilder(
    column: $table.allAvailableEpisodes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoDownloadFuture => $composableBuilder(
    column: $table.autoDownloadFuture,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<bool> get paused =>
      $composableBuilder(column: $table.paused, builder: (column) => column);

  GeneratedColumn<String> get destinationOverride => $composableBuilder(
    column: $table.destinationOverride,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastCheckedAt => $composableBuilder(
    column: $table.lastCheckedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AnimeSnapshotsTableAnnotationComposer get animeId {
    final $$AnimeSnapshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.animeId,
      referencedTable: $db.animeSnapshots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AnimeSnapshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.animeSnapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DownloadIntentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DownloadIntentsTable,
          DownloadIntent,
          $$DownloadIntentsTableFilterComposer,
          $$DownloadIntentsTableOrderingComposer,
          $$DownloadIntentsTableAnnotationComposer,
          $$DownloadIntentsTableCreateCompanionBuilder,
          $$DownloadIntentsTableUpdateCompanionBuilder,
          (DownloadIntent, $$DownloadIntentsTableReferences),
          DownloadIntent,
          PrefetchHooks Function({bool animeId})
        > {
  $$DownloadIntentsTableTableManager(
    _$AppDatabase db,
    $DownloadIntentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadIntentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadIntentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadIntentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> animeId = const Value.absent(),
                Value<String> selectedEpisodesJson = const Value.absent(),
                Value<bool> allAvailableEpisodes = const Value.absent(),
                Value<bool> autoDownloadFuture = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                Value<String?> destinationOverride = const Value.absent(),
                Value<DateTime?> lastCheckedAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DownloadIntentsCompanion(
                animeId: animeId,
                selectedEpisodesJson: selectedEpisodesJson,
                allAvailableEpisodes: allAvailableEpisodes,
                autoDownloadFuture: autoDownloadFuture,
                state: state,
                paused: paused,
                destinationOverride: destinationOverride,
                lastCheckedAt: lastCheckedAt,
                errorMessage: errorMessage,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> animeId = const Value.absent(),
                Value<String> selectedEpisodesJson = const Value.absent(),
                Value<bool> allAvailableEpisodes = const Value.absent(),
                Value<bool> autoDownloadFuture = const Value.absent(),
                required String state,
                Value<bool> paused = const Value.absent(),
                Value<String?> destinationOverride = const Value.absent(),
                Value<DateTime?> lastCheckedAt = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => DownloadIntentsCompanion.insert(
                animeId: animeId,
                selectedEpisodesJson: selectedEpisodesJson,
                allAvailableEpisodes: allAvailableEpisodes,
                autoDownloadFuture: autoDownloadFuture,
                state: state,
                paused: paused,
                destinationOverride: destinationOverride,
                lastCheckedAt: lastCheckedAt,
                errorMessage: errorMessage,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DownloadIntentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({animeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (animeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.animeId,
                                referencedTable:
                                    $$DownloadIntentsTableReferences
                                        ._animeIdTable(db),
                                referencedColumn:
                                    $$DownloadIntentsTableReferences
                                        ._animeIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DownloadIntentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DownloadIntentsTable,
      DownloadIntent,
      $$DownloadIntentsTableFilterComposer,
      $$DownloadIntentsTableOrderingComposer,
      $$DownloadIntentsTableAnnotationComposer,
      $$DownloadIntentsTableCreateCompanionBuilder,
      $$DownloadIntentsTableUpdateCompanionBuilder,
      (DownloadIntent, $$DownloadIntentsTableReferences),
      DownloadIntent,
      PrefetchHooks Function({bool animeId})
    >;
typedef $$DownloadJobsTableCreateCompanionBuilder =
    DownloadJobsCompanion Function({
      Value<int> id,
      required int animeId,
      required String sourceId,
      required String sourceUri,
      Value<String> episodeCoverageJson,
      required String destination,
      Value<String?> torrentHash,
      required String state,
      Value<int> retryCount,
      Value<String?> errorMessage,
      required DateTime createdAt,
      required DateTime updatedAt,
    });
typedef $$DownloadJobsTableUpdateCompanionBuilder =
    DownloadJobsCompanion Function({
      Value<int> id,
      Value<int> animeId,
      Value<String> sourceId,
      Value<String> sourceUri,
      Value<String> episodeCoverageJson,
      Value<String> destination,
      Value<String?> torrentHash,
      Value<String> state,
      Value<int> retryCount,
      Value<String?> errorMessage,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

class $$DownloadJobsTableFilterComposer
    extends Composer<_$AppDatabase, $DownloadJobsTable> {
  $$DownloadJobsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceUri => $composableBuilder(
    column: $table.sourceUri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get episodeCoverageJson => $composableBuilder(
    column: $table.episodeCoverageJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get torrentHash => $composableBuilder(
    column: $table.torrentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DownloadJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $DownloadJobsTable> {
  $$DownloadJobsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceId => $composableBuilder(
    column: $table.sourceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUri => $composableBuilder(
    column: $table.sourceUri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get episodeCoverageJson => $composableBuilder(
    column: $table.episodeCoverageJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get torrentHash => $composableBuilder(
    column: $table.torrentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DownloadJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DownloadJobsTable> {
  $$DownloadJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get sourceUri =>
      $composableBuilder(column: $table.sourceUri, builder: (column) => column);

  GeneratedColumn<String> get episodeCoverageJson => $composableBuilder(
    column: $table.episodeCoverageJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => column,
  );

  GeneratedColumn<String> get torrentHash => $composableBuilder(
    column: $table.torrentHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get errorMessage => $composableBuilder(
    column: $table.errorMessage,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DownloadJobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DownloadJobsTable,
          DownloadJob,
          $$DownloadJobsTableFilterComposer,
          $$DownloadJobsTableOrderingComposer,
          $$DownloadJobsTableAnnotationComposer,
          $$DownloadJobsTableCreateCompanionBuilder,
          $$DownloadJobsTableUpdateCompanionBuilder,
          (
            DownloadJob,
            BaseReferences<_$AppDatabase, $DownloadJobsTable, DownloadJob>,
          ),
          DownloadJob,
          PrefetchHooks Function()
        > {
  $$DownloadJobsTableTableManager(_$AppDatabase db, $DownloadJobsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DownloadJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DownloadJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DownloadJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> animeId = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> sourceUri = const Value.absent(),
                Value<String> episodeCoverageJson = const Value.absent(),
                Value<String> destination = const Value.absent(),
                Value<String?> torrentHash = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => DownloadJobsCompanion(
                id: id,
                animeId: animeId,
                sourceId: sourceId,
                sourceUri: sourceUri,
                episodeCoverageJson: episodeCoverageJson,
                destination: destination,
                torrentHash: torrentHash,
                state: state,
                retryCount: retryCount,
                errorMessage: errorMessage,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int animeId,
                required String sourceId,
                required String sourceUri,
                Value<String> episodeCoverageJson = const Value.absent(),
                required String destination,
                Value<String?> torrentHash = const Value.absent(),
                required String state,
                Value<int> retryCount = const Value.absent(),
                Value<String?> errorMessage = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
              }) => DownloadJobsCompanion.insert(
                id: id,
                animeId: animeId,
                sourceId: sourceId,
                sourceUri: sourceUri,
                episodeCoverageJson: episodeCoverageJson,
                destination: destination,
                torrentHash: torrentHash,
                state: state,
                retryCount: retryCount,
                errorMessage: errorMessage,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DownloadJobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DownloadJobsTable,
      DownloadJob,
      $$DownloadJobsTableFilterComposer,
      $$DownloadJobsTableOrderingComposer,
      $$DownloadJobsTableAnnotationComposer,
      $$DownloadJobsTableCreateCompanionBuilder,
      $$DownloadJobsTableUpdateCompanionBuilder,
      (
        DownloadJob,
        BaseReferences<_$AppDatabase, $DownloadJobsTable, DownloadJob>,
      ),
      DownloadJob,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AnimeSnapshotsTableTableManager get animeSnapshots =>
      $$AnimeSnapshotsTableTableManager(_db, _db.animeSnapshots);
  $$UserAnimeEntriesTableTableManager get userAnimeEntries =>
      $$UserAnimeEntriesTableTableManager(_db, _db.userAnimeEntries);
  $$CustomListsTableTableManager get customLists =>
      $$CustomListsTableTableManager(_db, _db.customLists);
  $$CustomListItemsTableTableManager get customListItems =>
      $$CustomListItemsTableTableManager(_db, _db.customListItems);
  $$DownloadIntentsTableTableManager get downloadIntents =>
      $$DownloadIntentsTableTableManager(_db, _db.downloadIntents);
  $$DownloadJobsTableTableManager get downloadJobs =>
      $$DownloadJobsTableTableManager(_db, _db.downloadJobs);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
