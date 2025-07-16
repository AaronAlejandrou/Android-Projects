import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  AppDatabase._internal();
  factory AppDatabase() => _instance;

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database as Database;
  }

  Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'songapp.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites (
            id TEXT PRIMARY KEY,
            title TEXT,
            artist TEXT,
            album TEXT,
            year TEXT,
            duration TEXT,
            genre TEXT,
            rating REAL,
            image TEXT
          )
        ''');
      },
    );
  }
} 