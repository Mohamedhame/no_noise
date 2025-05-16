import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper() {
    database;
  }
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'downloads.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE downloaded(id INTEGER PRIMARY KEY, data TEXT, idx INTEGER, title TEXT,  status TEXT, date TEXT)',
        );
      },
      version: 1,
    );
  }

  // INSERT //
  Future<int> insertDownload(Map<String, dynamic> download) async {
    final db = await database;
    int id = await db.insert(
      'downloaded',
      download,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  // VIEW //
  Future<List<Map<String, dynamic>>> getDownloads({String? where}) async {
    final db = await database;
    return await db.query('downloaded', where: where);
  }

  Future<Map<String, dynamic>?> getDownloadById(int id) async {
    final db = await database;
    final results = await db.query(
      'downloaded',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return Map<String, dynamic>.from(results.first);
    } else {
      return null;
    }
  }

  //====================
  Future<Map<String, dynamic>?> getDownloadByTitle(String title) async {
    final db = await database;
    final results = await db.query(
      'downloaded',
      where: 'title = ?',
      whereArgs: [title],
    );

    if (results.isNotEmpty) {
      return Map<String, dynamic>.from(results.first);
    } else {
      return null;
    }
  }

  // UPDATE //
  Future<int> updateDownload(Map<String, dynamic> download) async {
    final db = await database;
    return await db.update(
      'downloaded',
      download,
      where: 'id = ?',
      whereArgs: [download['id']],
    );
  }

  // DELETE //
  Future<int> deleteDownload(int id) async {
    final db = await database;
    return await db.delete('downloaded', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteDownloadByTitle(String title) async {
    final db = await database;
    return await db.delete(
      'downloaded',
      where: 'title = ?',
      whereArgs: [title],
    );
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'downloads.db');

    await deleteDatabase(path);
    print('✅ قاعدة البيانات تم حذفها بنجاح');
  }
}
