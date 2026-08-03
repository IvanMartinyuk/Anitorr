import 'dart:ffi';
import 'dart:io';

import 'package:anitorr/features/my_list/data/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/open.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  setUpAll(() {
    open.overrideFor(
      OperatingSystem.linux,
      () => DynamicLibrary.open('libsqlite3.so.0'),
    );
  });

  test('recovers an interrupted schema 3 migration', () async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'anitorr-migration-test-',
    );
    addTearDown(() => tempDirectory.delete(recursive: true));
    final databaseFile = File('${tempDirectory.path}/anitorr.sqlite');
    final rawDatabase = sqlite3.open(databaseFile.path);
    rawDatabase.execute('''
      CREATE TABLE download_intents (
        anime_id INTEGER NOT NULL PRIMARY KEY,
        preferred_size_bytes INTEGER NULL
      );
      PRAGMA user_version = 2;
    ''');
    rawDatabase.dispose();

    final database = AppDatabase.forTesting(NativeDatabase(databaseFile));
    addTearDown(database.close);
    await database.customSelect('SELECT 1').get();

    final version = await database
        .customSelect('PRAGMA user_version')
        .getSingle();
    expect(version.read<int>('user_version'), 3);
  });
}
