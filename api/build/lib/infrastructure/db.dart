import 'dart:io';

import 'package:sqlite3/sqlite3.dart' as sqlite3;

import 'migrations.dart';

class Database {
  Database._(this._db);

  final sqlite3.Database _db;

  static Database? _instance;

  factory Database.open({String? path, bool forTesting = false}) {
    if (!forTesting && _instance != null) {
      return _instance!;
    }
    final dbPath = path ?? _defaultDbPath();
    final file = File(dbPath);
    if (!file.parent.existsSync()) {
      file.parent.createSync(recursive: true);
    }
    final db = sqlite3.sqlite3.open(dbPath);
    db.execute('PRAGMA foreign_keys = ON;');
    final instance = Database._(db);
    instance._migrate();
    if (!forTesting) {
      _instance = instance;
    }
    return instance;
  }

  static String _defaultDbPath() {
    final base = Directory.current.path;
    return '$base/storage/som.db';
  }

  void _migrate() {
    if (migrations.isEmpty) {
      return;
    }
    _db.execute(migrations.first);
    final versionRows = _db.select('SELECT version FROM schema_version');
    var currentVersion = 0;
    if (versionRows.isNotEmpty) {
      currentVersion = versionRows.first['version'] as int;
    } else {
      _db.execute('INSERT INTO schema_version (version) VALUES (0)');
    }
    for (var i = currentVersion; i < migrations.length; i++) {
      if (i == 0) {
        continue;
      }
      _db.execute('BEGIN');
      try {
        _db.execute(migrations[i]);
        _db.execute('UPDATE schema_version SET version = ?', [i]);
        _db.execute('COMMIT');
      } catch (_) {
        _db.execute('ROLLBACK');
        rethrow;
      }
    }
  }

  sqlite3.ResultSet select(String sql, [List<Object?> params = const []]) {
    return _db.select(sql, params);
  }

  void execute(String sql, [List<Object?> params = const []]) {
    _db.execute(sql, params);
  }

  int lastInsertRowId() => _db.lastInsertRowId;

  void dispose() {
    _db.dispose();
  }
}
